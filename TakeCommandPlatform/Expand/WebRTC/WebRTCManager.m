//
//  WebRTCManager.m
//  TakeCommandPlatform
//
//  Created by jyd on 2018/1/23.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import "WebRTCManager.h"

static NSString *kRoomServerHostUrl =
@"https://apprtc.appspot.com";
static NSString *kRoomServerRegisterFormat =
@"%@/join/%@";
static NSString *kRoomServerMessageFormat =
@"%@/message/%@/%@";
static NSString *kRoomServerByeFormat =
@"%@/leave/%@/%@";

static NSString *kDefaultSTUNServerUrl =
@"stun:stun.l.google.com:19302";
// TODO(tkchin): figure out a better username for CEOD statistics.
static NSString *kTurnRequestUrl =
@"https://computeengineondemand.appspot.com"
@"/turn?username=iapprtc&key=4080218913";




@interface WebRTCManager () <SRWebSocketDelegate, RTCPeerConnectionDelegate>


@property(nonatomic, strong) SRWebSocket *webSocket;
@property(nonatomic, strong) RTCPeerConnection *peerConnection;
@property(nonatomic, strong) RTCPeerConnectionFactory *factory;
@property(nonatomic, strong) NSMutableArray *messageQueue;

@property(nonatomic, assign) BOOL isTurnComplete;
@property(nonatomic, assign) BOOL hasReceivedSdp;
@property(nonatomic, readonly) BOOL isRegisteredWithRoomServer;

@property(nonatomic, strong) NSString *roomId;
@property(nonatomic, strong) NSString *clientId;
@property(nonatomic, assign) BOOL isInitiator;
@property(nonatomic, assign) BOOL isSpeakerEnabled;
@property(nonatomic, strong) NSMutableArray *iceServers;
@property(nonatomic, strong) NSURL *webSocketURL;
@property(nonatomic, strong) NSURL *webSocketRestURL;
@property(nonatomic, strong) RTCAudioTrack *defaultAudioTrack;
@property(nonatomic, strong) RTCVideoTrack *defaultVideoTrack;

@end

@implementation WebRTCManager


#pragma mark - Singleton
static WebRTCManager *manager;
+ (instancetype)shareManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    if (self = [super init]) {
        
        _factory = [[RTCPeerConnectionFactory alloc] init];
        _messageQueue = [NSMutableArray array];
        _iceServers = [NSMutableArray arrayWithObject:[self defaultSTUNServer]];
        _serverHostUrl = kRoomServerHostUrl;
        _isSpeakerEnabled = YES;
        
        RTCInitializeSSL();
    }
    return self;
}

#pragma mark — connect / disconnect Socket
- (void)connectToRoomWithId:(NSString *)roomId
{
    _roomId = roomId;
# warning  WebSocket URL暂时还不知道
    NSURL *url = [NSURL URLWithString:@""];
    _webSocket = [[SRWebSocket alloc] initWithURL:url];
    _webSocket.delegate = self;
    [_webSocket open];
}

///断开连接
- (void)disconnect {
    if (_managerState == ManagerClientStateDisconnected) {
        return;
    }
    if (self.isRegisteredWithRoomServer) {
        //注销房间
//        [self unregisterWithRoomServer];
    }
    if (_webSocket) {
        if (_webSocketState == WebSocketChannelStateRegistered) {
            // Tell the other client we're hanging up.
            NSDictionary *leaveMessage = @{
                                              @"cmd": @"leave",
                                              @"roomid" : _roomId,
                                              @"clientid" : _clientId,
                                              };
            NSData *message = [leaveMessage yy_modelToJSONData];
            [_webSocket send:message];
        }
        // Disconnect from collider.
//        _webSocket = nil;
    }
    _clientId = nil;
    _roomId = nil;
    _isInitiator = NO;
    _hasReceivedSdp = NO;
    _messageQueue = [NSMutableArray array];
    _peerConnection = nil;
   _managerState = ManagerClientStateDisconnected;
}



#pragma mark - SRWebSocketDelegate
- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
    NSLog(@"WebSocket connection opened.");
    self.webSocketState = WebSocketChannelStateOpen;
    if (_roomId.length && _clientId.length) {
        [self registerAndJoinRoom];
    }
    
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    NSLog(@"WebSocket error: %@", error);
    self.webSocketState = WebSocketChannelStateError;
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    NSLog(@"WebSocket closed with code: %ld reason:%@ wasClean:%d",
          (long)code, reason, wasClean);
    NSParameterAssert(_webSocketState != WebSocketChannelStateError);
    self.webSocketState = WebSocketChannelStateClosed;
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    //接收
    NSMutableDictionary *resultDic = [message yy_modelToJSONObject];
    NSString *eventName = resultDic[@"eventName"];
    
    if ([eventName isEqualToString:@"_peers"]) {
        /** 3. 服务器根据用户所加入的房间,发送一个其他用户信令(peers),信令中包含聊天室中其他用户的信息,客户端根据信息来逐个构建与其他用户的点对点连接*/
//        [self sendOffers:resultDic];
    }
    else if ([eventName isEqualToString:@"_offer"]) {
//        [self receiveOffer:resultDic];
    }
    else if ([eventName isEqualToString:@"_answer"]) {
//        [self receiveAnswer:resultDic];
    }
    else if ([eventName isEqualToString:@"_ice_candidate"]) { // 接收到新加入的人发了ICE候选,(即经过ICEServer而获取到的地址)
//        [self setCandidateToConnection:resultDic];
    }
    else if ([eventName isEqualToString:@"_new_peer"]) {
        /** 5. 若有新用户加入,服务器发送一个用户加入信令(new_peer),信令中包含新加入的用户的信息,客户端根据信息来建立与这个新用户的点对点连接 */
//        [self memberEnter:resultDic];
    }
    else if ([eventName isEqualToString:@"_remove_peer"]) {
        /** 4. 若有用户离开,服务器发送一个用户离开信令(remove_peer),信令中包含离开的用户的信息,客户端根据信息关闭与离开用户的信息,并作相应的清除操作 */
//        [self memberLeave:resultDic];
    }
}

#pragma mark - RTCPeerConnectionDelegate
- (void)peerConnection:(RTCPeerConnection *)peerConnection didChangeSignalingState:(RTCSignalingState)stateChanged
{
    
}

- (void)peerConnection:(RTCPeerConnection *)peerConnection didAddStream:(RTCMediaStream *)stream
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (stream.videoTracks.count) {
            RTCVideoTrack *videoTrack = stream.videoTracks[0];
            if (_delegate  && [_delegate respondsToSelector:@selector(webRTC:didReceiveRemoteVideoTrack:)]) {
                [_delegate webRTC:self didReceiveRemoteVideoTrack:videoTrack];
            }
            if (_isSpeakerEnabled) {
                [self enableSpeaker];
            }
        }
    });
}

- (void)peerConnection:(RTCPeerConnection *)peerConnection didRemoveStream:(RTCMediaStream *)stream
{
     NSLog(@"Stream was removed.");
}

- (void)peerConnection:(RTCPeerConnection *)peerConnection didGenerateIceCandidate:(RTCIceCandidate *)candidate
{
    //把自己的网络地址通过 socket 转发给对端
//    NSString *connectionID = [self findConnectionID:peerConnection];
    NSDictionary *dic = @{@"eventName" : @"__ice_candidate",
                          @"data": @{@"id" : candidate.sdpMid,
                                     @"label" : [NSNumber numberWithInteger:candidate.sdpMLineIndex],
                                     @"candidate" : candidate.sdp,
                                     @"socketId": _clientId}
                          };
    
    if (_webSocket.readyState == SR_OPEN) {
        [_webSocket send:[dic yy_modelToJSONData]];
    }
}

- (void)peerConnection:(nonnull RTCPeerConnection *)peerConnection didChangeIceConnectionState:(RTCIceConnectionState)newState { 
    
}


- (void)peerConnection:(nonnull RTCPeerConnection *)peerConnection didChangeIceGatheringState:(RTCIceGatheringState)newState { 
    
}


- (void)peerConnection:(nonnull RTCPeerConnection *)peerConnection didOpenDataChannel:(nonnull RTCDataChannel *)dataChannel { 
    
}


- (void)peerConnection:(nonnull RTCPeerConnection *)peerConnection didRemoveIceCandidates:(nonnull NSArray<RTCIceCandidate *> *)candidates { 
    
}


- (void)peerConnectionShouldNegotiate:(nonnull RTCPeerConnection *)peerConnection { 
    
}




#pragma mark - Private
///注册加入房间
- (void)registerAndJoinRoom
{
    if (_webSocketState == WebSocketChannelStateRegistered) {
        return;
    }
    
    NSParameterAssert(_roomId.length);
    NSParameterAssert(_clientId.length);
    
    NSDictionary *registerMessage = @{
                                      @"cmd": @"register",
                                      @"roomid" : _roomId,
                                      @"clientid" : _clientId,
                                      };
    NSData *message = [registerMessage yy_modelToJSONData];
    [_webSocket send:message];
    
    _webSocketState = WebSocketChannelStateRegistered;
}


- (BOOL)isRegisteredWithRoomServer {
    return _clientId.length;
}

- (void)startSignalingIfReady {
    if (!_isTurnComplete || !self.isRegisteredWithRoomServer) {
        return;
    }
    self.managerState = ManagerClientStateConnected;
    
    // Create peer connection.
    RTCMediaConstraints *constraints = [self defaultPeerConnectionConstraints];
    RTCConfiguration *configuration = [[RTCConfiguration alloc] init];
    configuration.iceServers = _iceServers;
    _peerConnection = [_factory peerConnectionWithConfiguration:configuration constraints:constraints delegate:self];
    RTCMediaStream *localStream = [self createLocalMediaStream];
    [_peerConnection addStream:localStream];
    if (_isInitiator) {
        [self sendOffer];
    } else {
        [self waitForAnswer];
    }
}

- (void)sendOffer {
    [_peerConnection offerForConstraints:[self defaultOfferConstraints] completionHandler:^(RTCSessionDescription * _Nullable sdp, NSError * _Nullable error) {
        if (error) {
            NSLog(@"offerForConstraints error");
            return ;
        }
        
//        __weak __typeof (_peerConnection) weakConnection = _peerConnection;
        // A:设置连接本端 SDP
        [_peerConnection setLocalDescription:sdp completionHandler:^(NSError * _Nullable error) {
            if (error) {
                NSLog(@"setLocalDescription error");
                return;
            }
            
        }];
            
    }];
}

- (void)waitForAnswer {
    
}

- (void)drainMessageQueueIfReady {
    if (!_peerConnection || !_hasReceivedSdp) {
        return;
    }
//    for (ARDSignalingMessage *message in _messageQueue) {
//        [self processSignalingMessage:message];
//    }
    [_messageQueue removeAllObjects];
}

//- (void)processSignalingMessage:(ARDSignalingMessage *)message {
//    NSParameterAssert(_peerConnection ||
//                      message.type == kARDSignalingMessageTypeBye);
//    switch (message.type) {
//        case kARDSignalingMessageTypeOffer:
//        case kARDSignalingMessageTypeAnswer: {
//            ARDSessionDescriptionMessage *sdpMessage =
//            (ARDSessionDescriptionMessage *)message;
//            RTCSessionDescription *description = sdpMessage.sessionDescription;
//            [_peerConnection setRemoteDescriptionWithDelegate:self
//                                           sessionDescription:description];
//            break;
//        }
//        case kARDSignalingMessageTypeCandidate: {
//            ARDICECandidateMessage *candidateMessage =
//            (ARDICECandidateMessage *)message;
//            [_peerConnection addICECandidate:candidateMessage.candidate];
//            break;
//        }
//        case kARDSignalingMessageTypeBye:
//            // Other client disconnected.
//            // TODO(tkchin): support waiting in room for next client. For now just
//            // disconnect.
//            [self disconnect];
//            break;
//    }
//}
//
//- (void)sendSignalingMessage:(ARDSignalingMessage *)message {
//    if (_isInitiator) {
//        [self sendSignalingMessageToRoomServer:message completionHandler:nil];
//    } else {
//        [self sendSignalingMessageToCollider:message];
//    }
//}


- (RTCVideoTrack *)createLocalVideoTrackWithBackCamera:(BOOL)isBack {
    
    RTCVideoTrack *localVideoTrack = nil;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    NSArray<AVCaptureDevice *> *devices;
    
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) { // 摄像头权限
        NSLog(@"相机访问受限");
        
    } else {
#if __IPHONE_OS_VERSION_MIN_REQUIRED < 100000
        if (@available(iOS 10.0, *)) {
            if ([AVCaptureDeviceDiscoverySession class]) {
                AVCaptureDeviceDiscoverySession *deviceDiscoverySession = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionFront];
                devices = [deviceDiscoverySession devices];
            }
            else {
                devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
            }
        } else {
            // Fallback on earlier versions
        }
#else
        AVCaptureDeviceDiscoverySession *deviceDiscoverySession = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInWideAngleCamera] mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionFront];
        devices = [deviceDiscoverySession devices];
#endif
        
        AVCaptureDevice *device = [devices lastObject];
        
        if (device) {
            RTCAVFoundationVideoSource *videoSource = [_factory avFoundationVideoSourceWithConstraints:[self defaultMediaStreamConstraints]];
            [videoSource setUseBackCamera:isBack];
            localVideoTrack = [_factory videoTrackWithSource:videoSource trackId:@"ARDAMSv0"];
        }
    }
    

    return localVideoTrack;
}

- (RTCMediaStream *)createLocalMediaStream {
    RTCMediaStream* localStream = [_factory mediaStreamWithStreamId:@"ARDAMS"];
    
    RTCVideoTrack *localVideoTrack = [self createLocalVideoTrackWithBackCamera:NO];
    if (localVideoTrack) {
        [localStream addVideoTrack:localVideoTrack];
        [_delegate webRTC:self didReceiveLocalVideoTrack:localVideoTrack];
    }
    
    [localStream addAudioTrack:[_factory audioTrackWithTrackId:@"ARDAMSa0"]];
    if (_isSpeakerEnabled) [self enableSpeaker];
    return localStream;
}



#pragma mark - Defaults

- (RTCMediaConstraints *)defaultMediaStreamConstraints {
    RTCMediaConstraints* constraints =
    [[RTCMediaConstraints alloc]
     initWithMandatoryConstraints:nil
     optionalConstraints:nil];
    return constraints;
}

- (RTCMediaConstraints *)defaultAnswerConstraints {
    return [self defaultOfferConstraints];
}

- (RTCMediaConstraints *)defaultOfferConstraints {
    NSDictionary *mandatory = @{kRTCMediaConstraintsOfferToReceiveAudio : kRTCMediaConstraintsValueTrue,
                                kRTCMediaConstraintsOfferToReceiveVideo : kRTCMediaConstraintsValueTrue};
    RTCMediaConstraints* constraints =
    [[RTCMediaConstraints alloc]
     initWithMandatoryConstraints:mandatory
     optionalConstraints:nil];
    return constraints;
}

- (RTCMediaConstraints *)defaultPeerConnectionConstraints {
    NSDictionary *mandatory = @{kRTCMediaConstraintsOfferToReceiveAudio : kRTCMediaConstraintsValueTrue,
                                kRTCMediaConstraintsOfferToReceiveVideo : kRTCMediaConstraintsValueTrue};
    RTCMediaConstraints* constraints =
    [[RTCMediaConstraints alloc]
     initWithMandatoryConstraints:nil
     optionalConstraints:mandatory];
    return constraints;
}

- (RTCIceServer *)defaultSTUNServer {
    
    return [[RTCIceServer alloc] initWithURLStrings:@[kDefaultSTUNServerUrl]];
}

#pragma mark - Audio mute/unmute
- (void)muteAudioIn {
    NSLog(@"audio muted");
    RTCMediaStream *localStream = _peerConnection.localStreams[0];
    self.defaultAudioTrack = localStream.audioTracks[0];
    [localStream removeAudioTrack:localStream.audioTracks[0]];
    [_peerConnection removeStream:localStream];
    [_peerConnection addStream:localStream];
}
- (void)unmuteAudioIn {
    NSLog(@"audio unmuted");
    RTCMediaStream* localStream = _peerConnection.localStreams[0];
    [localStream addAudioTrack:self.defaultAudioTrack];
    [_peerConnection removeStream:localStream];
    [_peerConnection addStream:localStream];
    if (_isSpeakerEnabled) [self enableSpeaker];
}

#pragma mark - Video mute/unmute
- (void)muteVideoIn {
    NSLog(@"video muted");
    RTCMediaStream *localStream = _peerConnection.localStreams[0];
    self.defaultVideoTrack = localStream.videoTracks[0];
    [localStream removeVideoTrack:localStream.videoTracks[0]];
    [_peerConnection removeStream:localStream];
    [_peerConnection addStream:localStream];
}
- (void)unmuteVideoIn {
    NSLog(@"video unmuted");
    RTCMediaStream* localStream = _peerConnection.localStreams[0];
    [localStream addVideoTrack:self.defaultVideoTrack];
    [_peerConnection removeStream:localStream];
    [_peerConnection addStream:localStream];
}

#pragma mark - swap camera

- (void)swapCameraToFront{
    RTCMediaStream *localStream = _peerConnection.localStreams[0];
    [localStream removeVideoTrack:localStream.videoTracks[0]];
    
    RTCVideoTrack *localVideoTrack = [self createLocalVideoTrackWithBackCamera:NO];
    
    if (localVideoTrack) {
        [localStream addVideoTrack:localVideoTrack];
        [_delegate webRTC:self didReceiveLocalVideoTrack:localVideoTrack];
    }
    [_peerConnection removeStream:localStream];
    [_peerConnection addStream:localStream];
}
- (void)swapCameraToBack{
    RTCMediaStream *localStream = _peerConnection.localStreams[0];
    [localStream removeVideoTrack:localStream.videoTracks[0]];
    
    RTCVideoTrack *localVideoTrack = [self createLocalVideoTrackWithBackCamera:YES];
    
    if (localVideoTrack) {
        [localStream addVideoTrack:localVideoTrack];
        [_delegate webRTC:self didReceiveLocalVideoTrack:localVideoTrack];
    }
    [_peerConnection removeStream:localStream];
    [_peerConnection addStream:localStream];
}

#pragma mark - enable/disable speaker

- (void)enableSpeaker {
    [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideSpeaker error:nil];
    _isSpeakerEnabled = YES;
}

- (void)disableSpeaker {
    [[AVAudioSession sharedInstance] overrideOutputAudioPort:AVAudioSessionPortOverrideNone error:nil];
    _isSpeakerEnabled = NO;
}

@end
