//
//  ChatLocationMessageModel.m
//  TakeCommandPlatform
//
//  Created by jyd on 2018/3/5.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import "ChatLocationMessageModel.h"

@implementation ChatLocationMessageModel

+ (instancetype)localPositionPhoto:(NSString *)localPositionPhotoPath
                           address:(NSString *)address
                          location:(CLLocation *)location
                          username:(NSString *)username
                         timeStamp:(NSString *)timeStamp
                          isSender:(BOOL)isSender

{
    return [[self alloc]initWithLocalPositionPhoto:localPositionPhotoPath address:address location:location username:username timeStamp:timeStamp isSender:isSender];
}





- (instancetype)initWithLocalPositionPhoto:(NSString *)localPositionPhotoPath
                                   address:(NSString *)address
                                  location:(CLLocation *)location
                                  username:(NSString *)username
                                 timeStamp:(NSString *)timeStamp
                                  isSender:(BOOL)isSender
{
    self = [super init];
    if (self) {
        self.localPositionPhotoPath = localPositionPhotoPath;
        self.address = address;
        self.location = location;
        
        self.username = username;
        self.timeStamp = timeStamp;
        
        self.bubbleMessageBodyType = MessageBodyTypeLocation;
        self.isSender = isSender;
    }
    return self;
}


@end
