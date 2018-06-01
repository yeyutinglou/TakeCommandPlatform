//
//  VoiceRecordBtn.h
//  TakeCommandPlatform
//
//  Created by jyd on 2018/1/29.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol VoiceRecordingDelegate <NSObject>


///准备录音
- (void)prepareRecordingVoiceAction;

///开始录音
- (void)startRecordingVoiceAction;

///取消录音
- (void)cancelRecordingVoiceAction;

///完成录音
- (void)finishRecordingVoiceAction;

///手指离开按钮的范围内
- (void)dragOutsideAction;

///手指进入按钮的范围内
- (void)dragInsideAction;

@end

@interface VoiceRecordBtn : UIButton

/** delegate */
@property (nonatomic, weak) id <VoiceRecordingDelegate> delegate;

/** 声音大小 */
@property (nonatomic, assign) float peakPower;

@end
