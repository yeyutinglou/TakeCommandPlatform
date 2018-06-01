//
//  VoiceRecordBtn.m
//  TakeCommandPlatform
//
//  Created by jyd on 2018/1/29.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import "VoiceRecordBtn.h"
#import "PQVoiceInput.h"

@interface VoiceRecordBtn ()

/** 话筒动画 */
@property (nonatomic, strong) PQVoiceInputView *voiceInputView;


@end

@implementation VoiceRecordBtn

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        
        [self addTarget:self action:@selector(recordButtonTouchDown) forControlEvents:UIControlEventTouchDown];
        [self addTarget:self action:@selector(recordButtonTouchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
        [self addTarget:self action:@selector(recordButtonTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
//        [self addTarget:self action:@selector(recordDragOutside) forControlEvents:UIControlEventTouchDragExit];
//        [self addTarget:self action:@selector(recordDragInside) forControlEvents:UIControlEventTouchDragEnter];
        
        
        [self setTitle:@"按住说话" forState:UIControlStateNormal];
        [self setTitle:@"松开发送" forState:UIControlStateHighlighted];
        self.titleLabel.font = [UIFont systemFontOfSize:14];
        
        
        
        self.voiceInputView = [[PQVoiceInputView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-60, SCREEN_HEIGHT/2-60, 120, 120)];
        
        
    }
    return self;
}


- (void)setPeakPower:(float)peakPower
{
    _peakPower = peakPower;
    //更新声音大小UI
    [self.voiceInputView updateVoiceViewWithVolume:peakPower];
}

- (void)recordButtonTouchDown
{
    if (_delegate && [_delegate respondsToSelector:@selector(prepareRecordingVoiceAction)]) {
        [_delegate prepareRecordingVoiceAction];
    }
    
    if (_delegate && [_delegate respondsToSelector:@selector(startRecordingVoiceAction)]) {
        [_delegate startRecordingVoiceAction];
    }
    
    [self.voiceInputView updateTitle:@"手指上滑，取消发送"];
    [[self lastWindow] addSubview:self.voiceInputView];
}

- (void)recordButtonTouchUpOutside
{
    if (_delegate && [_delegate respondsToSelector:@selector(cancelRecordingVoiceAction)])
    {
        [_delegate cancelRecordingVoiceAction];
    }
    
    [self.voiceInputView removeFromSuperview];
}

- (void)recordButtonTouchUpInside
{
    
    if (_delegate && [_delegate respondsToSelector:@selector(finishRecordingVoiceAction)])
    {
        [_delegate finishRecordingVoiceAction];
    }
    
   
    
    [self.voiceInputView removeFromSuperview];
}


- (UIWindow *)lastWindow
{
    NSArray *windows = [UIApplication sharedApplication].windows;
    for(UIWindow *window in [windows reverseObjectEnumerator]) {
        
        if ([window isKindOfClass:[UIWindow class]] && !window.hidden &&
            CGRectEqualToRect(window.bounds, [UIScreen mainScreen].bounds))
            
            return window;
    }
    
    return [UIApplication sharedApplication].keyWindow;
}


@end
