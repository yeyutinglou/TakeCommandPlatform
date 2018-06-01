//
//  AreaBtn.m
//  TakeCommandPlatform
//
//  Created by jyd on 2018/3/21.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import "AreaBtn.h"

#define margin 10

@implementation AreaBtn

 - (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        //设置一些初始化状态
        self.imageView.contentMode    = UIViewContentModeTop;
        self.titleLabel.contentMode = UIViewContentModeBottom;
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:13];
        [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
    return self;
}


/**
 *  设定自定义的按钮的图片尺寸、位置
 */
-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    CGFloat imageW = contentRect.size.width;
    CGFloat imageH = contentRect.size.height - margin ;
    return CGRectMake(imageX, imageY, imageW, imageH);
}


/**
 *  设定自定义的按钮的title的尺寸、位置
 */
-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    CGFloat titleX = 0;
    CGFloat titleY = contentRect.size.height - margin - 20; //contentRect.size.height * ZJImageRatio;
    CGFloat titleW = contentRect.size.width;
    CGFloat titleH = 20;

    return CGRectMake(titleX, titleY, titleW, titleH);
}
@end
