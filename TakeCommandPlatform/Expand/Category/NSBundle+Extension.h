//
//  NSBundle+Extension.h
//  TakeCommandPlatform
//
//  Created by jyd on 2018/2/6.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSBundle (Extension)

///根据名称获取图片
+ (UIImage *)imageWithBundle:(NSString *)bundleName imageName:(NSString *)imageName;

///根据名称获取bundle
+ (NSBundle *)bundle:(NSString *)bundleName;
@end
