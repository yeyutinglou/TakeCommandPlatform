//
//  NSObject+Swizzling.m
//  KVO
//
//  Created by jyd on 2017/7/10.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import "NSObject+Swizzling.h"
#import <objc/runtime.h>
@implementation NSObject (Swizzling)

+ (void)DYW_methodSwizlingWithOriginalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector
{
    Class class = [self class];
    
    //获取方法
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    
    //尝试给originalSelector添加IMP
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        //添加成功：说明originalSelector没有实现IMP，将originalSelector的IMP替换到swizzledSelector的IMP
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    } else {
        //添加失败: 说明originalSelector已实现IMP,直接将SEL的IMP进行替换
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    
}

@end
