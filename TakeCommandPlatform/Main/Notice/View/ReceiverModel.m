//
//  Receiver.m
//  TakeCommandPlatform
//
//  Created by jyd on 2018/1/3.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import "ReceiverModel.h"

@implementation ReceiverModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper
{
    return @{@"receiverId" : @"id"};
}
@end
