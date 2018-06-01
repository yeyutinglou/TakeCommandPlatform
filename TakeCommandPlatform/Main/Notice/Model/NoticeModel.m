//
//  NoticeModel.m
//  TakeCommandPlatform
//
//  Created by jyd on 2017/12/15.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import "NoticeModel.h"

@implementation NoticeModel



- (void)setReceiver:(NSArray *)receiver
{
    NSArray *arr = [NSArray yy_modelArrayWithClass:[Receiver class] json:receiver];
    _receiver = arr;
}

@end

@implementation Notice

@end

@implementation Receiver


+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper
{
    return @{@"schoolId" : @"id"};
}
@end
