//
//  ChatPhotoMessageModel.m
//  TakeCommandPlatform
//
//  Created by jyd on 2018/3/5.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import "ChatPhotoMessageModel.h"

@implementation ChatPhotoMessageModel

+ (instancetype)photo:(NSString *)localPhotoPath
         thumbnailUrl:(NSString *)thumbnailUrl
       originPhotoUrl:(NSString *)originPhotoUrl
             username:(NSString *)username
            timeStamp:(NSString *)timeStamp
             isSender:(BOOL)isSender

{
    return [[self alloc]initWithPhoto:localPhotoPath thumbnailUrl:thumbnailUrl originPhotoUrl:originPhotoUrl username:username timeStamp:timeStamp isSender:isSender];
}


- (instancetype)initWithPhoto:(NSString *)localPhotoPath
                 thumbnailUrl:(NSString *)thumbnailUrl
               originPhotoUrl:(NSString *)originPhotoUrl
                     username:(NSString *)username
                    timeStamp:(NSString *)timeStamp
                     isSender:(BOOL)isSender
{
    self = [super init];
    if (self) {
        self.localPhotoPath = localPhotoPath;
        self.thumbnailUrl = thumbnailUrl;
        self.originPhotoUrl = originPhotoUrl;
        self.username = username;
        self.timeStamp = timeStamp;
        
        self.bubbleMessageBodyType = MessageBodyTypePhoto;
        self.isSender = isSender;
    }
    return self;
}

@end
