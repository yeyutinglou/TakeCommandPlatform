//
//  UIButton+Swizzling.m
//  KVO
//
//  Created by jyd on 2017/7/10.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import "UIButton+Swizzling.h"
#import "NSObject+Swizzling.h"
#import <objc/message.h>

#define defaultInterval 1

@interface UIButton ()

/** 间隔 */
@property (nonatomic, assign) NSTimeInterval timeInterval;

/** 是否忽略事件 */
@property (nonatomic, assign) BOOL isIgnore;


@end

@implementation UIButton (Swizzling)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self DYW_methodSwizlingWithOriginalSelector:@selector(sendAction:to:forEvent:) swizzledSelector:@selector(DYW_sendAction:to:forEvent:)];
    });
}

- (NSTimeInterval)timeInterval
{
    return [objc_getAssociatedObject(self, _cmd) doubleValue];
}

- (void)setTimeInterval:(NSTimeInterval)timeInterval
{
    objc_setAssociatedObject(self, @selector(timeInterval), @(timeInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)isIgnore
{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

- (void)setIsIgnore:(BOOL)isIgnore
{
    objc_setAssociatedObject(self, @selector(isIgnore), @(isIgnore), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (void)resetState
{
    [self setIsIgnore:NO];
}

- (void)DYW_sendAction:(SEL)action to:(nullable id)target forEvent:(nullable UIEvent *)event
{
    
    
    if ([NSStringFromClass(self.class) isEqualToString:@"UIButton"]) {
    
        self.timeInterval = self.timeInterval == 0 ? defaultInterval : self.timeInterval;
        if (self.isIgnore) {
            return;
        }
        if (self.timeInterval > 0) {
            [self performSelector:@selector(resetState) withObject:nil afterDelay:self.timeInterval];
        }
    }
    self.isIgnore = YES;
    
    [self DYW_sendAction:action to:target forEvent:event];

    
}

@end
