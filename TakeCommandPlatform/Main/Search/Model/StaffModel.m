//
//  StaffModel.m
//  TakeCommandPlatform
//
//  Created by jyd on 2018/4/12.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import "StaffModel.h"

@implementation StaffModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper
{
    return @{@"staffId" : @"id"};
}
@end
