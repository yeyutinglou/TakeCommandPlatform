//
//  AudioPlayManager.h
//  TakeCommandPlatform
//
//  Created by jyd on 2018/3/9.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioPlayManager : NSObject

@property(nonatomic,copy) void(^audioPlayerDidFinishPlaying)(NSString *);

singleton_interface(AudioPlayManager)

- (void)playAudioWithFileUrl:(NSURL *)url finishPlay:(void(^)(NSString *url))didFinishPlaying;
- (void)pauseAudioWithFileUrl:(NSURL *)url;

@end
