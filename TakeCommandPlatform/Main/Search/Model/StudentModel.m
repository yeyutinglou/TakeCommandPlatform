//
//  StudentModel.m
//  TakeCommandPlatform
//
//  Created by jyd on 2018/4/11.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import "StudentModel.h"

@implementation StudentModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper
{
    return @{@"studentId" : @"id"};
}

@end
