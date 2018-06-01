//
//  EmojiEmoticonsToolBar.h
//  TakeCommandPlatform
//
//  Created by jyd on 2018/2/27.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmojiEmoticonsToolBar : UIView

/** isEmoji */
@property (nonatomic, assign) BOOL isEmoji;

/** 选择emojiView */
@property (nonatomic, copy) void(^switchEmojiBlock)(NSInteger);

/** 发送emoji */
@property (nonatomic, copy) void(^sendEmojiBlock)(void);

- (void)setBtnIndexSelect:(NSInteger)index;
@end
