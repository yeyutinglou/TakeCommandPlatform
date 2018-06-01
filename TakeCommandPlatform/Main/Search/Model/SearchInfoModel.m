//
//  SearchInfoModel.m
//  TakeCommandPlatform
//
//  Created by jyd on 2018/4/10.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import "SearchInfoModel.h"

@implementation SearchInfoModel

- (NSArray *)students
{
    NSArray *arr = [NSArray yy_modelArrayWithClass:[Student class] json:_students];
    return arr;
}

- (NSArray *)staffs
{
    NSArray *arr = [NSArray yy_modelArrayWithClass:[Staff class] json:_staffs];
    return arr;
}

- (NSArray *)rooms
{
    NSArray *arr = [NSArray yy_modelArrayWithClass:[Room class] json:_rooms];
    return arr;
}

- (NSArray *)sites
{
    NSArray *arr = [NSArray yy_modelArrayWithClass:[Site class] json:_sites];
    return arr;
}

@end


@implementation Student

@end

@implementation Staff

@end

@implementation Room

@end

@implementation Site

@end
