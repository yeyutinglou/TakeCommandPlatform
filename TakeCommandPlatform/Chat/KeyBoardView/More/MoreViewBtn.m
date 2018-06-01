//
//  MoreViewBtn.m
//  TakeCommandPlatform
//
//  Created by jyd on 2018/2/7.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import "MoreViewBtn.h"
#define KMargin 2
#define KBtnWidth 60

@implementation MoreViewBtn

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = kFont(14);
    }
    return self;
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(self.width/2-KBtnWidth/2, 0, KBtnWidth, KBtnWidth);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, CGRectGetMaxY(self.imageView.frame), self.width, 30);
}

@end
