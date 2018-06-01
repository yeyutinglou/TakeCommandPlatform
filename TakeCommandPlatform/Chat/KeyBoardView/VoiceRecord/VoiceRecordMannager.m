
//
//  VoiceRecordMannager.m
//  TakeCommandPlatform
//
//  Created by jyd on 2018/1/30.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import "VoiceRecordMannager.h"
#import "ChatDefault.h"
@interface VoiceRecordMannager () <AVAudioRecorderDelegate>

/** timer */
@property (nonatomic, strong) NSTimer *timer;

/** 是否停止 */
@property (nonatomic, assign) BOOL isPause;

/** 语音路径 */
@property (nonatomic, copy) NSString *recordPath;

/** 语音时长 */
@property (nonatomic, assign) NSTimeInterval currentTimeInterval;

/** audioRecorder */
@property (nonatomic, strong) AVAudioRecorder *audioRecorder;


@end
@implementation VoiceRecordMannager

- (instancetype)init
{
    if (self = [super init]) {
        self.maxRecordTime = kMaxVoiceRecorderTime;
        self.recordDuration = @"0";
    }
    return self;
}

- (void)resetTimer
{
    if (!self.timer) {
        return;
    }
    [_timer invalidate];
    _timer = nil;
}

- (void)cancelRecoding
{
    if (!_audioRecorder) {
        return;
    }
    if (_audioRecorder.isRecording) {
        [_audioRecorder stop];
    }
    _audioRecorder = nil;
}

- (void)stopRecorded
{
    [self cancelRecoding];
    [self resetTimer];
}

- (void)prepareRecordingWithPath:(NSString *)path prepareRecorderCompletion:(PrepareRecorderCompletion)prepareRecorderCompletion
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _isPause = NO;
        NSError *error = nil;
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
        if (error) {
            NSLog(@"audioSession: %@ %ld %@", [error domain], [error code], [[error userInfo] description]);
            return ;
        }
        error = nil;
        [audioSession setActive:YES error:&error];
        if(error) {
            NSLog(@"audioSession: %@ %ld %@", [error domain], (long)[error code], [[error userInfo] description]);
            return;
        }
        
        NSMutableDictionary * recordSetting = [NSMutableDictionary dictionary];
        [recordSetting setValue :[NSNumber numberWithInt:kAudioFormatMPEG4AAC] forKey:AVFormatIDKey];
        [recordSetting setValue:[NSNumber numberWithFloat:16000.0] forKey:AVSampleRateKey];
        [recordSetting setValue:[NSNumber numberWithInt: 1] forKey:AVNumberOfChannelsKey];
        
        self.recordPath = path;
        error = nil;
        if (self.audioRecorder) {
            [self cancelRecoding];
        } else {
            self.audioRecorder = [[AVAudioRecorder alloc] initWithURL:[NSURL fileURLWithPath:self.recordPath] settings:recordSetting error:&error];
            self.audioRecorder.delegate = self;
            [self.audioRecorder prepareToRecord];
            self.audioRecorder.meteringEnabled = YES;
            [self.audioRecorder recordForDuration:160];
        }
        if(error) {
            NSLog(@"audioSession: %@ %ld %@", [error domain], (long)[error code], [[error userInfo] description]);
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!prepareRecorderCompletion()) {
                [self cancelledDeleteWithCompletion:^(NSString *path) {
                    
                }];
            }
        });
    });
}

- (void)startRecordingWithStartRecorderCompletion:(StartRecorderCompletion)startRecorderCompletion
{
    [self resetTimer];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(updateMeters) userInfo:nil repeats:YES];
    if (startRecorderCompletion) {
        dispatch_async(dispatch_get_main_queue(), ^{
            startRecorderCompletion();
        });
    }
}

- (void)resumeRecordingWithResumeRecorderCompletion:(ResumeRecorderCompletion)resumeRecorderCompletion
{
    _isPause = NO;
    if (_audioRecorder  && [_audioRecorder record]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            resumeRecorderCompletion();
        });
    }
}

- (void)pauseRecordingWithPauseRecorderCompletion:(PauseRecorderCompletion)pauseRecorderCompletion
{
    _isPause = YES;
    if (_audioRecorder) {
        [_audioRecorder pause];
    }
    if (!_audioRecorder.isRecording) {
        dispatch_async(dispatch_get_main_queue(), ^{
            pauseRecorderCompletion();
        });
    }
}

- (void)stopRecordingWithStopRecorderCompletion:(StopRecorderCompletion)stopRecorderCompletion
{
    _isPause = NO;
    [self stopRecorded];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self getVoiceDuration:self.recordPath];
        dispatch_async(dispatch_get_main_queue(), ^{
            stopRecorderCompletion(self.recordPath);
        });
    });
}


- (void)cancelledDeleteWithCompletion:(CancellRecorderDeleteFileCompletion)cancelledDeleteCompletion
{
    _isPause = NO;
    [self stopRecorded];
    
    if (self.recordPath) {
        // 删除目录下的文件
        NSFileManager *fileManeger = [NSFileManager defaultManager];
        if ([fileManeger fileExistsAtPath:self.recordPath]) {
            NSError *error = nil;
            [fileManeger removeItemAtPath:self.recordPath error:&error];
            if (error) {
                NSLog(@"error :%@", error.description);
            }
            dispatch_async(dispatch_get_main_queue(), ^{
                cancelledDeleteCompletion(error.description);
            });
        } else {
            dispatch_async(dispatch_get_main_queue(), ^{
                cancelledDeleteCompletion(self.recordPath);
            });
        }
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            cancelledDeleteCompletion(nil);
        });
    }
}


- (void)getVoiceDuration:(NSString*)recordPath {
    NSError *error = nil;
    AVAudioPlayer *play = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:recordPath] error:&error];
    if (error) {
        self.recordDuration = @"";
    } else {
        NSLog(@"时长:%f", play.duration);
        self.recordDuration = [NSString stringWithFormat:@"%.1f", play.duration];
    }
}

@end
