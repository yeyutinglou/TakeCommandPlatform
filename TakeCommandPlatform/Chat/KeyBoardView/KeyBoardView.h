//
//  KeyBoardView.h
//  TakeCommandPlatform
//
//  Created by jyd on 2018/2/5.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MoreView.h"
#import "BottomEmojiView.h"
#import "EmojiEmoticonsViewDelegate.h"
#import "KeyBoardToolBar.h"
@interface KeyBoardView : UIView


@property(nonatomic,weak) id<VoiceRecordingDelegate> voiceRecordingDelegate;
@property(nonatomic,assign)float peakPower;



@property(nonatomic,weak) id<KeyBoardToolBarDelegate> keyBoardToolBarDelegate;

@property(nonatomic,weak) id<EmojiEmoticonsViewDelegate> emojiEmoticonsViewDelegate;



@property(nonatomic,weak) id<MoreViewDelegate>moreViewDelegate;

@property(nonatomic,assign) BOOL hideKeyBoard;

//键盘变化
@property(nonatomic,assign) CGFloat keyBoardDetalChange;



@end
