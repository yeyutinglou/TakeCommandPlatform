//
//  StudentSeatModel.m
//  TakeCommandPlatform
//
//  Created by jyd on 2017/12/21.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import "StudentSeatModel.h"

@implementation StudentSeatModel

- (NSArray *)students
{
    return [NSArray yy_modelArrayWithClass:[StudentModel class] json:_students];
}

@end


@implementation Device

@end
