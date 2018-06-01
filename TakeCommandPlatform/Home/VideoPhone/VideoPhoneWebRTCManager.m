//
//  VideoPhoneWebRTCManager.m
//  TakeCommandPlatform
//
//  Created by jyd on 2018/1/15.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import "VideoPhoneWebRTCManager.h"

//STUN服务器
static NSString *const RTCSTUNServerURL = @"stun:stun.l.google.com:19302";
static NSString *const RTCSTUNServerURL2 = @"stun:23.21.150.121";

typedef NS_ENUM(NSUInteger, RoleType) {
    RoleTypeSender,
    RoleTypeReceiver,
};

@interface VideoPhoneWebRTCManager () <SRWebSocketDelegate, RTCPeerConnectionDelegate>
/** host */
@property (nonatomic,copy) NSString *host;

/** port */
@property (nonatomic,copy) NSString *port;

/** room */
@property (nonatomic,copy) NSString *room;


/** webSocket */
@property (nonatomic, strong) SRWebSocket *webSocket;

/** RTCPeerConnectionFactory */
@property (nonatomic, strong) RTCPeerConnectionFactory *factory;

/** localStream */
@property (nonatomic, strong) RTCMediaStream *localStream;

/** roleType */
@property (nonatomic, assign) RoleType roleType;

@property (nonatomic, strong) NSMutableArray <RTCIceServer *> *iceServers;

/**< 对端ID集合 */
@property (nonatomic, strong) NSMutableArray <NSString *> *peerConnectionIDS;

/**< 连接集合 */
@property (nonatomic, strong) NSMutableDictionary <NSString *, RTCPeerConnection *> *peerConnections;

@end

@implementation VideoPhoneWebRTCManager

#pragma mark - Singleton
static VideoPhoneWebRTCManager *manager;
+ (instancetype)shareInstance
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
        
        if (!_peerConnections) {
            _peerConnections = [NSMutableDictionary dictionary];
        }
        
        if (!_peerConnectionIDS) {
            _peerConnectionIDS = [NSMutableArray array];
        }
        
        RTCInitializeSSL();
    }
    return self;
}

#pragma mark - public method
///建立socket连接
- (void)connect:(NSString *)host port:(NSString *)port
{
    NSParameterAssert(host);
    NSParameterAssert(port);
    
    _host = host;
    _port = port;
    
    [self setupSocket];
}

///断开连接
- (void)close
{
    _localStream = nil;
    [_peerConnectionIDS enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self closeConnection:obj];
    }];
    [_webSocket close];
}

#pragma mark - private Method
///创建webSocket
- (void)setupSocket
{
    if (_webSocket) {
        [_webSocket close];
        _webSocket = nil;
    }
    
    NSString *str = [NSString stringWithFormat:@"ws://%@:%@", _host, _port];
    _webSocket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:str]];
    _webSocket.delegate = self;
    [_webSocket open];
}

- (void)setupFactory
{
    if (!_factory) {
        _factory = [[RTCPeerConnectionFactory alloc] init];
    }
}

- (void)setupLocalStream
{
    if (!_localStream) {
        //设置点连接工厂
        [self setupFactory];
        
        RTCAudioTrack *audioTrack = [_factory audioTrackWithTrackId:@"ARDAMSa0"];
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        NSArray<AVCaptureDevice *> *devices;
        
        _localStream = [_factory mediaStreamWithStreamId:@"ARDAMS"];
        // 添加音频轨迹
        [_localStream addAudioTrack:audioTrack];
        
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
                RTCAVFoundationVideoSource *videoSource = [_factory avFoundationVideoSourceWithConstraints:[self setupLocalVideoonstraints]];
                [videoSource setUseBackCamera:NO];
                RTCVideoTrack *videoTrack = [_factory videoTrackWithSource:videoSource trackId:@"ARDAMSv0"];
                
                // 添加视频轨迹
                [_localStream addVideoTrack:videoTrack];
                
                if ([_delegate respondsToSelector:@selector(webRTCHelper:setLocalStream:)]) {
//                    [_delegate webRTCHelper:self setLocalStream:_localStream];
                }
            }
            else {
                NSLog(@"该设备不能打开摄像头");
                if ([_delegate respondsToSelector:@selector(webRTCHelper:setLocalStream:)]) {
//                    [_delegate webRTCHelper:self setLocalStream:nil];
                }
            }
        }
        
    }
}

- (RTCMediaConstraints *)setupLocalVideoonstraints
{
    NSDictionary *mandatory = @{kRTCMediaConstraintsMinFrameRate : @"20"};
    RTCMediaConstraints *constraints = [[RTCMediaConstraints alloc] initWithMandatoryConstraints:mandatory optionalConstraints:nil];
    return constraints;
}

- (RTCMediaConstraints *)setupPeerVideoConstraints
{
    NSDictionary *mandatory = @{kRTCMediaConstraintsOfferToReceiveAudio : kRTCMediaConstraintsValueTrue,
                                kRTCMediaConstraintsOfferToReceiveVideo : kRTCMediaConstraintsValueTrue};
    RTCMediaConstraints *constraints = [[RTCMediaConstraints alloc] initWithMandatoryConstraints:mandatory optionalConstraints:nil];
    return constraints;
}

- (RTCMediaConstraints *)setupOfferOrAnswerConstraint
{
    NSDictionary *mandatory = @{kRTCMediaConstraintsOfferToReceiveAudio : kRTCMediaConstraintsValueTrue,
                                kRTCMediaConstraintsOfferToReceiveVideo : kRTCMediaConstraintsValueTrue};
    RTCMediaConstraints *constraints = [[RTCMediaConstraints alloc] initWithMandatoryConstraints:mandatory optionalConstraints:nil];
    return constraints;
}

- (void)setupConnections
{
    [_peerConnectionIDS enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        RTCPeerConnection *connection = [self createConnection:obj];
        [_peerConnections setObject:connection forKey:obj];
    }];
}
- (void)setupIceServers
{
    if (!_iceServers) {
        _iceServers = [[NSMutableArray alloc] init];
        [_iceServers addObject:[self setupIceServer:RTCSTUNServerURL ]];
        [_iceServers addObject:[self setupIceServer:RTCSTUNServerURL2]];
    }
}
- (RTCIceServer *)setupIceServer:(NSString *)stunURL
{
    return [[RTCIceServer alloc] initWithURLStrings:@[stunURL]];
}

- (RTCPeerConnection *)createConnection:(NSString *)connectionID
{
    [self setupFactory];
    [self setupIceServers];
    RTCConfiguration *configuration = [[RTCConfiguration alloc] init];
    configuration.iceServers = _iceServers;
    RTCPeerConnection *connection = [_factory peerConnectionWithConfiguration:configuration constraints:[self setupPeerVideoConstraints] delegate:self];
    return connection;
}

- (void)closeConnection:(NSString *)connectionID
{
    RTCPeerConnection *connection = [_peerConnections objectForKey:connectionID];
    if (connection) {
        [connection close];
    }
    [_peerConnectionIDS removeObject:connectionID];
    [_peerConnections removeObjectForKey:connectionID];
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([_delegate respondsToSelector:@selector(webRTCHelper:removeConnection:)]) {
//            [_delegate webRTCHelper:self removeConnection:connectionID];
        }
    });
}

- (void)join:(NSString *)room
{
    if (_webSocket.readyState == SR_OPEN) {
        NSDictionary *dic = @{@"eventName": @"__join", @"data": @{@"room": room}};
        NSData *para = [dic yy_modelToJSONData];
        // 发送加入房间的数据
        [_webSocket send:para];
    }
}

- (void)addConnectionIDS:(NSArray <NSString *>*)connections
{
    [connections enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
    }];
    [_peerConnectionIDS addObjectsFromArray:connections];
}

- (void)addLocalStreamConnections
{
    [_peerConnections enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, RTCPeerConnection * _Nonnull obj, BOOL * _Nonnull stop) {
        [self setupLocalStream];
        [obj addStream:_localStream];
    }];
}

- (void)sendSDPOffersConnections
{
    [_peerConnections enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, RTCPeerConnection * _Nonnull obj, BOOL * _Nonnull stop) {
        [self sendSDPOffersConnection:obj];
    }];
}

- (void)sendSDPOffersConnection:(RTCPeerConnection *)connection
{
    _roleType = RoleTypeSender;
    
    [connection offerForConstraints:[self setupOfferOrAnswerConstraint] completionHandler:^(RTCSessionDescription * _Nullable sdp, NSError * _Nullable error) {
        if (error) {
            NSLog(@"offerForConstraints error");
            return ;
        }
        
        if (sdp.type == RTCSdpTypeOffer) {
            __weak __typeof (connection) weakConnection = connection;
            // A:设置连接本端 SDP
            [connection setLocalDescription:sdp completionHandler:^(NSError * _Nullable error) {
                if (error) {
                    NSLog(@"setLocalDescription error");
                    return;
                }
                [self didSetSessionDescription:weakConnection];
            }];
        }
    }];
}

- (NSString *)findConnectionID:(RTCPeerConnection *)connection
{
    __block NSString *connectionID;
    
    [_peerConnections enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, RTCPeerConnection * _Nonnull obj, BOOL * _Nonnull stop) {
        if ([connection isEqual:obj]) {
            connectionID = key;
            *stop = YES;
        }
    }];
    
    return connectionID;
}

- (RTCSdpType)typeForString:(NSString *)string
{
    RTCSdpType sdpType = RTCSdpTypeOffer;
    if ([string isEqualToString:@"answer"]) {
        sdpType = RTCSdpTypeAnswer;
    } else if ([string isEqualToString:@"offer"]) {
        sdpType = RTCSdpTypeOffer;
    }
    return sdpType;
}

- (void)didSetSessionDescription:(RTCPeerConnection *)connection
{
    NSString *connectionID = [self findConnectionID:connection];
    
    switch (connection.signalingState) {
        case RTCSignalingStateHaveRemoteOffer:
            {
                // 新人进入房间就调(远端发起 offer)
                [connection answerForConstraints:[self setupOfferOrAnswerConstraint] completionHandler:^(RTCSessionDescription * _Nullable sdp, NSError * _Nullable error) {
                    if (error) {
                        NSLog(@"answerForConstraint error");
                        return ;
                    }
                    
                    if (sdp.type == RTCSdpTypeAnswer) {
                        // B:设置连接本端 SDP
                        __weak __typeof(connection) weakConnection = connection;
                        [connection setLocalDescription:sdp completionHandler:^(NSError * _Nullable error) {
                            if (error) {
                                NSLog(@"setLocalDescription error");;
                                return ;
                            }
                            [self didSetSessionDescription:weakConnection];
                        }];
                    }
                    
                }];
            }
            break;
        case RTCSignalingStateHaveLocalOffer:
        {
            // 本地发送 offer
            if (_roleType == RoleTypeSender) {
                NSDictionary *dic = @{@"eventName": @"__offer",
                                      @"data": @{@"sdp": @{@"type": @"offer",
                                                           @"sdp": connection.localDescription.sdp
                                                           },
                                                 @"socketId": connectionID
                                                 }
                                      };
                
                if (_webSocket.readyState == SR_OPEN) {
                    NSLog(@"locationSDP:%@", dic);
                    [_webSocket send:[dic yy_modelToJSONData]];
                }
            }
        }
            break;
            case RTCSignalingStateStable:
        {
            //本地发送answer
            if (_roleType == RoleTypeReceiver) {
                NSDictionary *dic = @{@"eventName": @"__answer",
                                      @"data": @{@"sdp": @{@"type": @"answer",
                                                           @"sdp": connection.localDescription.sdp
                                                           },
                                                 @"socketId": connectionID
                                                 }
                                      };
                
                if (_webSocket.readyState == SR_OPEN) {
                    [_webSocket send:[dic yy_modelToJSONData]];
                }
            }
            
        }
            break;
        default:
            break;
    }
    
    
    
}

// TODO:执行事件
///本端群发 offer
- (void)sendOffers:(NSMutableDictionary *)resultDic
{
    NSDictionary *dataDic = resultDic[@"data"];
    // 记录所有对端连接ID
    [self addConnectionIDS:dataDic[@"connections"]];
    // 建立本地流信息
    [self setupLocalStream];
    // 建立所有连接
    [self setupConnections];
    // 所有连接添加本地流信息
    [self addLocalStreamConnections];
    // 所有连接发送 SDP offer
    [self sendSDPOffersConnections];
}

///远端发来 offer
- (void)receiveOffer:(NSMutableDictionary *)resultDic
{
    _roleType = RoleTypeReceiver;
    NSDictionary *dataDic = resultDic[@"data"];
    NSDictionary *sdpDic = dataDic[@"sdp"];
    // 拿到SDP
    NSString *sdp = sdpDic[@"sdp"];
    NSString *type = sdpDic[@"type"];
    NSString *connectionID = dataDic[@"socketId"];
    //sdp类型
    RTCSdpType sdpType = [self typeForString:type];
    //点连接
    RTCPeerConnection *connection = [_peerConnections objectForKey:connectionID];
    // 根据类型和SDP 生成SDP描述对象
    RTCSessionDescription *remoteSdp = [[RTCSessionDescription alloc] initWithType:sdpType sdp:sdp];
    
    if (sdpType == RTCSdpTypeOffer) {
        // 设置给这个点对点连接
        __weak __typeof(connection) weakConnection = connection;
        // B:设置连接对端 SDP
        [connection setRemoteDescription:remoteSdp completionHandler:^(NSError * _Nullable error) {
            if (error) {
                NSLog(@"setRemoteDescription error");
                return ;
            }
            [self didSetSessionDescription:weakConnection];
        }];
    }
}

/// 远端发来 answer
- (void)receiveAnswer:(NSMutableDictionary *)resultDic
{
    NSDictionary *dataDic = resultDic[@"data"];
    NSDictionary *sdpDic = dataDic[@"sdp"];
    NSString *sdp = sdpDic[@"sdp"];
    NSString *type = sdpDic[@"type"];
    NSString *connectionID = dataDic[@"socketId"];
    RTCSdpType sdpType = [self typeForString:type];
    RTCPeerConnection *connection = [_peerConnections objectForKey:connectionID];
    RTCSessionDescription *remoteSdp = [[RTCSessionDescription alloc] initWithType:sdpType sdp:sdp];
    
    if (sdpType == RTCSdpTypeAnswer) {
        __weak __typeof(connection) wConnection = connection;
        /** Apply the supplied RTCSessionDescription as the remote description. */
        // A:设置连接对端 SDP
        [connection setRemoteDescription:remoteSdp completionHandler:^(NSError * _Nullable error) {
            if (error) {
                NSLog(@"setRemoteDescription error");
                return ;
            }
            
            [self didSetSessionDescription:wConnection];
        }];
    }
}

/// 设置连接 candidate  对端的网络地址通过 socket 转发给本端
- (void)setCandidateToConnection:(NSMutableDictionary *)resultDic
{
    NSDictionary *dataDic = resultDic[@"data"];
    NSString *connectionID = dataDic[@"socketId"];
    NSString *sdpMid = dataDic[@"id"];
    NSInteger sdpMLineIndex = [dataDic[@"label"] integerValue];
    NSString *sdp = dataDic[@"candidate"];
    // 生成远端网络地址对象
    RTCIceCandidate *candidate = [[RTCIceCandidate alloc] initWithSdp:sdp sdpMLineIndex:(int)sdpMLineIndex sdpMid:sdpMid];
    // 拿到当前对应的点对点连接
    RTCPeerConnection *connection = [_peerConnections objectForKey:connectionID];
    // 添加到点对点连接中
    [connection addIceCandidate:candidate];
}

///成员进入
- (void)memberEnter:(NSMutableDictionary *)resultDic
{
    NSDictionary *dataDic = resultDic[@"data"];
    // 拿到新人的ID
    NSString *connectionID = dataDic[@"socketId"];
    [self setupLocalStream];
    // 再去创建一个连接
    RTCPeerConnection *connection = [self createConnection:connectionID];
    // 把本地流加到连接中去
    [connection addStream:_localStream];
    // 新加一个远端连接ID
    [_peerConnectionIDS addObject:connectionID];
    // 并且设置到Dic中去
    [_peerConnections setObject:connection forKey:connectionID];
}

///成员离开
- (void)memberLeave:(NSMutableDictionary *)resultDic
{
    NSDictionary *dataDic = resultDic[@"data"];
    NSString *connectionID = dataDic[@"socketId"];
    [self closeConnection:connectionID];
}

#pragma mark - SRWebSocketDelegate
- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
    //发送一个加入聊天室的信令(join),信令中需要包含用户所进入的聊天室名称
    [self join:_room];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    //接收
    NSMutableDictionary *resultDic = [message yy_modelToJSONObject];
    NSString *eventName = resultDic[@"eventName"];
    
    if ([eventName isEqualToString:@"_peers"]) {
        /** 3. 服务器根据用户所加入的房间,发送一个其他用户信令(peers),信令中包含聊天室中其他用户的信息,客户端根据信息来逐个构建与其他用户的点对点连接*/
        [self sendOffers:resultDic];
    }
    else if ([eventName isEqualToString:@"_offer"]) {
        [self receiveOffer:resultDic];
    }
    else if ([eventName isEqualToString:@"_answer"]) {
        [self receiveAnswer:resultDic];
    }
    else if ([eventName isEqualToString:@"_ice_candidate"]) { // 接收到新加入的人发了ICE候选,(即经过ICEServer而获取到的地址)
        [self setCandidateToConnection:resultDic];
    }
    else if ([eventName isEqualToString:@"_new_peer"]) {
        /** 5. 若有新用户加入,服务器发送一个用户加入信令(new_peer),信令中包含新加入的用户的信息,客户端根据信息来建立与这个新用户的点对点连接 */
        [self memberEnter:resultDic];
    }
    else if ([eventName isEqualToString:@"_remove_peer"]) {
        /** 4. 若有用户离开,服务器发送一个用户离开信令(remove_peer),信令中包含离开的用户的信息,客户端根据信息关闭与离开用户的信息,并作相应的清除操作 */
        [self memberLeave:resultDic];
    }
}

#pragma mark - RTCPeerConnectionDelegate
- (void)peerConnection:(RTCPeerConnection *)peerConnection didChangeSignalingState:(RTCSignalingState)stateChanged
{
    
}

- (void)peerConnection:(RTCPeerConnection *)peerConnection didAddStream:(RTCMediaStream *)stream
{
    NSString *connectionID = [self findConnectionID:peerConnection];
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([_delegate respondsToSelector:@selector(webRTCHelper:addRemoteStream:connectionID:)]) {
//            [_delegate webRTCHelper:self addRemoteStream:stream connectionID:connectionID];
        }
    });
}

- (void)peerConnection:(RTCPeerConnection *)peerConnection didRemoveStream:(RTCMediaStream *)stream
{
    
}

- (void)peerConnection:(RTCPeerConnection *)peerConnection didGenerateIceCandidate:(RTCIceCandidate *)candidate
{
    //把自己的网络地址通过 socket 转发给对端
    NSString *connectionID = [self findConnectionID:peerConnection];
    NSDictionary *dic = @{@"eventName" : @"__ice_candidate",
                          @"data": @{@"id" : candidate.sdpMid,
                                     @"label" : [NSNumber numberWithInteger:candidate.sdpMLineIndex],
                                     @"candidate" : candidate.sdp,
                                     @"socketId": connectionID}
                          };
    
    if (_webSocket.readyState == SR_OPEN) {
        [_webSocket send:[dic yy_modelToJSONData]];
    }
}

@end
