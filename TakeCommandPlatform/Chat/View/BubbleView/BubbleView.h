//
//  BubbleView.h
//  TakeCommandPlatform
//
//  Created by jyd on 2018/3/5.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BubbleView : UIView

/** 背景图片 */
@property (nonatomic, strong) UIImage *bubbleImage;

/** 发送者or接收者 */
@property (nonatomic, assign) BOOL isSender;


- (void)setBubbleImage:(UIImage *)bubbleImage
              isSender:(BOOL)isSender;

@end
