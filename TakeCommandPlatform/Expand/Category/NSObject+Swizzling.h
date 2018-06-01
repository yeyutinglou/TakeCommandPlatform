//
//  NSObject+Swizzling.h
//  KVO
//
//  Created by jyd on 2017/7/10.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Swizzling)

+ (void)DYW_methodSwizlingWithOriginalSelector:(SEL)originalSelector
                              swizzledSelector:(SEL)swizzledSelector;

@end
