//
//  AudioPlayManager.m
//  TakeCommandPlatform
//
//  Created by jyd on 2018/3/9.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import "AudioPlayManager.h"

@interface AudioPlayManager ()<AVAudioPlayerDelegate>
/** audioPlalyer */
@property (nonatomic, strong) AVAudioPlayer *player;

@end

@implementation AudioPlayManager

singleton_implementation(AudioPlayManager)

- (void)playAudioWithFileUrl:(NSURL *)url finishPlay:(void (^)(NSString *))didFinishPlaying
{
    self.audioPlayerDidFinishPlaying = didFinishPlaying;
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:url error:nil];
    self.player.delegate = self;
    [self.player prepareToPlay];
    [self.player play];
}
- (void)pauseAudioWithFileUrl:(NSURL *)url
{
    [self.player stop];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    self.audioPlayerDidFinishPlaying ? self.audioPlayerDidFinishPlaying(self.player.url.path) : nil;
}

@end
