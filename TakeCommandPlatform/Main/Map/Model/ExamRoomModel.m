//
//  ExamRoomModel.m
//  TakeCommandPlatform
//
//  Created by jyd on 2017/12/19.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import "ExamRoomModel.h"

@implementation ExamRoomModel

- (void)setRoominfo:(NSArray *)roominfo
{
    NSArray *arr = [NSArray yy_modelArrayWithClass:[RoomInfo class] json:roominfo];
    _roominfo = arr;
}

@end

@implementation RoomInfo

@end
