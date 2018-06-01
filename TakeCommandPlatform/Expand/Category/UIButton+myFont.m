//
//  UIButton+myFont.m
//  wenbaStudentNew
//
//  Created by jyd on 15/12/6.
//  Copyright © 2015年 zxhl. All rights reserved.
//

#import "UIButton+myFont.h"
#import <objc/runtime.h>

@implementation UIButton (myFont)

+ (void)load
{
    Method imp = class_getInstanceMethod([self class], @selector(initWithCoder:));
    Method myImp = class_getInstanceMethod([self class], @selector(myInitWithCoder:));
    method_exchangeImplementations(imp, myImp);
}

/**
 *  注意： 以下方法只用于全局修改由 Xib 加载的界面的 UIButton, UILabel的字体，其他的如UITextField等类似，新建Catogery就好
 *  想修改代码生成的界面，修改 initWithCoder 为 init就好
 *  参考:http://ju.outofmemory.cn/entry/122460
 */
- (id)myInitWithCoder:(NSCoder*)aDecode
{
    [self myInitWithCoder:aDecode];
    if (self) {
//        CGFloat fontSize = self.titleLabel.font.pointSize;
//        self.titleLabel.font = [UIFont fontWithName:@"FZKTJW--GB1-0" size:fontSize];
        //登录按钮样式
//        [self setBackgroundImage:[UIImage imageWithColor:JYDColorFromRGB(0x2CAFD7) size:self.size] forState:UIControlStateNormal];
//        [self setBackgroundImage:[UIImage imageWithColor:JYDColorFromRGB(0x0099D9) size:self.size] forState:UIControlStateHighlighted];
//        
//        self.layer.cornerRadius = 5;
//        self.clipsToBounds = YES;
    }
    return self;
}

- (id) init {
    self = [super init];
    if (self){
//        CGFloat fontSize = self.titleLabel.font.pointSize;
//        self.titleLabel.font = [UIFont fontWithName:@"FZKTJW--GB1-0" size:fontSize];
        [self setBackgroundImage:[UIImage imageWithColor:JYDColorFromRGB(0x2CAFD7) size:self.size] forState:UIControlStateNormal];
        [self setBackgroundImage:[UIImage imageWithColor:JYDColorFromRGB(0x0099D9) size:self.size] forState:UIControlStateHighlighted];
        
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;
    }
    return self;
}

@end
