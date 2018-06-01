//
//  WebRTCManager.h
//  TakeCommandPlatform
//
//  Created by jyd on 2018/1/23.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <WebRTC/WebRTC.h>

typedef NS_ENUM(NSUInteger, ManagerClientState) {
    ManagerClientStateDisconnected,
    ManagerClientStateConnecting,
    ManagerClientStateConnected
};

typedef NS_ENUM(NSInteger, WebSocketChannelState) {
    ///关闭
    WebSocketChannelStateClosed,
    ///打开
    WebSocketChannelStateOpen,
    ///注册
    WebSocketChannelStateRegistered,
    ///错误
    WebSocketChannelStateError
};


@class WebRTCManager;
@protocol WebRTCManagerDelegate <NSObject>

- (void)webRTC:(WebRTCManager *)manager
   didChangeState:(ManagerClientState)state;

- (void)webRTC:(WebRTCManager *)manager
didReceiveLocalVideoTrack:(RTCVideoTrack *)localVideoTrack;

- (void)webRTC:(WebRTCManager *)manager
didReceiveRemoteVideoTrack:(RTCVideoTrack *)remoteVideoTrack;

- (void)webRTC:(WebRTCManager *)manager
         didError:(NSError *)error;

@end

@interface WebRTCManager : NSObject

/** manage连接状态 */
@property (nonatomic, assign) ManagerClientState managerState;

/** socket连接状态 */
@property (nonatomic, assign) WebSocketChannelState webSocketState;

/** delegate */
@property (nonatomic, weak) id <WebRTCManagerDelegate> delegate;

/** 服务器地址 */
@property (nonatomic, copy) NSString *serverHostUrl;


+ (instancetype)shareManager;

- (void)connectToRoomWithId:(NSString *)roomId;


- (void)muteAudioIn;
- (void)unmuteAudioIn;


- (void)muteVideoIn;
- (void)unmuteVideoIn;


- (void)enableSpeaker;
- (void)disableSpeaker;


- (void)swapCameraToFront;
- (void)swapCameraToBack;


- (void)disconnect;


@end
