//
//  NSDate+MJ.h
//  ItcastWeibo
//
//  Created by apple on 14-5-9.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (JYD)
/**
 *  是否为今天
 */
- (BOOL)isToday;
/**
 *  是否为昨天
 */
- (BOOL)isYesterday;
/**
 *  是否为今年
 */
- (BOOL)isThisYear;

/**
 *  返回一个只有年月日的时间
 */
- (NSDate *)dateWithYMD;

/**
 *  获得与当前时间的差距
 */
- (NSDateComponents *)deltaWithNow;

///根据时间格式获取时间字符串
+ (NSString *)date:(NSDate *)date WithFormate:(NSString *)formate;
///根据时间格式获取时间
+ (NSDate *)dateString:(NSString *)dateString WithFormate:(NSString *)formate;

///获取两个时间的时间差
+ (CGFloat)timeIntervalWithFormer:(NSDate *)former latter:(NSDate *)latter;
@end
