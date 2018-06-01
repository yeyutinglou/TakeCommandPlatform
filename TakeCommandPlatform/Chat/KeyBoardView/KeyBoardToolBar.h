//
//  KeyBoardToolBar.h
//  TakeCommandPlatform
//
//  Created by jyd on 2018/2/27.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HPGrowingTextView.h"
#import "VoiceRecordBtn.h"

@protocol KeyBoardToolBarDelegate <NSObject>

- (void)sendTextAction:(NSString *)text;

@end

@interface KeyBoardToolBar : UIView

/** keyBoardToolBarDelegate */
@property (nonatomic, weak) id <KeyBoardToolBarDelegate> keyBoardToolBarDelegate;

/** voiceRecordDelegate */
@property (nonatomic, weak) id <VoiceRecordingDelegate> voiceRecordingDelegate;

/** growingTextViewDelegate */
@property (nonatomic, weak) id <HPGrowingTextViewDelegate> growingTextViewDelegate;

/** voice */
@property (nonatomic, assign) float peakPower;

/** keyBoardFrame */
@property(nonatomic,copy) void(^keyBoardFrameChange)(NSInteger index,BOOL isInput);

/** switchBtn */
@property(nonatomic,strong) UIButton *switchBtn;

/** recordBtn */
@property(nonatomic,strong) VoiceRecordBtn *recordBtn;

/** emojiBtn */
@property(nonatomic,strong) UIButton *emojiBtn;

/** textView */
@property(nonatomic,strong) HPGrowingTextView *textView;

/** moreBtn */
@property(nonatomic,strong) UIButton *moreBtn;

//Public：emoij表情输入时公开调用
- (void)textViewDidChange:(UITextView *)textView;


//public:emoij消息发送也需要:
/**
 *  @brief 将toolBar设置成44的默认高度状态
 */
- (void)setToolBarToNormalState;

@end
