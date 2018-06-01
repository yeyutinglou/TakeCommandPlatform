//
//  EmojiEmoticonsView.h
//  TakeCommandPlatform
//
//  Created by jyd on 2018/2/7.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmojiEmoticonsViewDelegate.h"


@interface EmojiEmoticonsView : UIView

/** 第几个emoji */
@property (nonatomic, assign) NSInteger emojiEmoticonsViewNum;

/** emoji页数 */
@property (nonatomic, assign) NSInteger page;


/** emojiType */
@property (nonatomic, assign) EmotionType emotionType;

/** delegate */
@property (nonatomic, weak) id <EmojiEmoticonsViewDelegate> delegate;



+ (instancetype)emojiEmoticonsView:(NSInteger)emojiEmoticonsViewNum scrollView:(UIScrollView *)scrollView frame:(CGRect)frame;

@end
