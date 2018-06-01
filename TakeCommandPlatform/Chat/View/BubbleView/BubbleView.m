//
//  BubbleView.m
//  TakeCommandPlatform
//
//  Created by jyd on 2018/3/5.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import "BubbleView.h"

@implementation BubbleView

- (void)setBubbleImage:(UIImage *)bubbleImage isSender:(BOOL)isSender
{
    _bubbleImage = bubbleImage;
    _isSender = isSender;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [UIImage drawImage:_bubbleImage rect:rect isSender:_isSender];
}

@end
