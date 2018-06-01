//
//  VideoPhoneWebRTCManager.h
//  TakeCommandPlatform
//
//  Created by jyd on 2018/1/15.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol VideoPhoneWebRTCManagerDelegate <NSObject>

- (void)webRTCsetLocalStream:(RTCMediaStream *)stream;

- (void)webRTCaddRemoteStream:(RTCMediaStream *)stream;

- (void)webRTCremoveConnection:(NSString *)connectionID;

@end
@interface VideoPhoneWebRTCManager : NSObject

/** delegate */
@property (nonatomic,weak) id<VideoPhoneWebRTCManagerDelegate> delegate;

+ (instancetype)shareInstance;

- (void)connect:(NSString *)host port:(NSString *)port;

- (void)close;
@end
