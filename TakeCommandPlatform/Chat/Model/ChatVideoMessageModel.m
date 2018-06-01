//
//  ChatVideoMessageModel.m
//  TakeCommandPlatform
//
//  Created by jyd on 2018/3/5.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import "ChatVideoMessageModel.h"

@implementation ChatVideoMessageModel

+ (instancetype)videoThumbPhoto:(NSString *)videoThumbPhoto
                  videoThumbUrl:(NSString *)videoThumbUrl
                       videoUrl:(NSString *)videoUrl
                       username:(NSString *)username
                      timeStamp:(NSString *)timeStamp
                       isSender:(BOOL)isSender
{
    
    return [[self alloc]initWithVideoThumbPhoto:videoThumbPhoto videoThumbUrl:videoThumbUrl videoUrl:videoUrl username:username timeStamp:timeStamp isSender:isSender];
}


- (instancetype)initWithVideoThumbPhoto:(NSString *)videoThumbPhoto
                          videoThumbUrl:(NSString *)videoThumbUrl
                               videoUrl:(NSString *)videoUrl
                               username:(NSString *)username
                              timeStamp:(NSString *)timeStamp
                               isSender:(BOOL)isSender
{
    self = [super init];
    if (self) {
        self.videoThumbPhoto = videoThumbPhoto;
        self.videoThumbUrl = videoThumbUrl;
        self.videoUrl = videoUrl;
        
        
        self.username = username;
        self.timeStamp = timeStamp;
        
        self.bubbleMessageBodyType = MessageBodyTypeVideo;
        self.isSender = isSender;
    }
    return self;
    
}

@end
