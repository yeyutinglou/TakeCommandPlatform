//
//  NSBundle+Extension.m
//  TakeCommandPlatform
//
//  Created by jyd on 2018/2/6.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import "NSBundle+Extension.h"

@implementation NSBundle (Extension)

+ (UIImage *)imageWithBundle:(NSString *)bundleName imageName:(NSString *)imageName
{
    NSString *imagePath = [[self bundle:bundleName] pathForResource:imageName ofType:@"png"];
    return [UIImage imageWithContentsOfFile:imagePath];
}


+ (NSBundle *)bundle:(NSString *)bundleName
{
    NSString *bundlePath = [[NSBundle mainBundle] pathForResource:bundleName ofType:@"bundle"];
    return [NSBundle bundleWithPath:bundlePath];
}

@end
