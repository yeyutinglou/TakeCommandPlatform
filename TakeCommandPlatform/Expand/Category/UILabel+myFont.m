//
//  UILabel+myFont.m
//  wenbaStudentNew
//
//  Created by jyd on 15/12/6.
//  Copyright © 2015年 zxhl. All rights reserved.
//

#import "UILabel+myFont.h"
#import <objc/runtime.h>

@implementation UILabel (myFont)

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
//        CGFloat fontSize = self.font.pointSize;
//        self.font = [UIFont fontWithName:@"FZKTJW--GB1-0" size:fontSize];
    }
    return self;
}

- (id) init {
    self = [super init];
    if (self){
//        CGFloat fontSize = self.font.pointSize;
//        self.font = [UIFont fontWithName:@"FZKTJW--GB1-0" size:fontSize];
        self.textColor = JYDColorFromRGB(0x727272);
    }
    return self;
}

@end
