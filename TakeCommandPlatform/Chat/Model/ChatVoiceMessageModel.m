//
//  ChatVoiceMessageModel.m
//  TakeCommandPlatform
//
//  Created by jyd on 2018/3/5.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import "ChatVoiceMessageModel.h"

@implementation ChatVoiceMessageModel

+ (instancetype)voicePath:(NSString *)voicePath
                 voiceUrl:(NSString *)voiceUrl
            voiceDuration:(NSString *)voiceDuration
                 username:(NSString *)username
                timeStamp:(NSString *)timeStamp
                 isSender:(BOOL)isSender
{
    return  [[self alloc]initWithVoicePath:voicePath voiceUrl:voiceUrl voiceDuration:voiceDuration username:username timeStamp:timeStamp isRead:NO isSender:isSender];
}


+ (instancetype)voicePath:(NSString *)voicePath
                 voiceUrl:(NSString *)voiceUrl
            voiceDuration:(NSString *)voiceDuration
                 username:(NSString *)username
                timeStamp:(NSString *)timeStamp
                   isRead:(BOOL)isRead
                 isSender:(BOOL)isSender


{
    return  [[self alloc]initWithVoicePath:voicePath voiceUrl:voiceUrl voiceDuration:voiceDuration username:username timeStamp:timeStamp isRead:isRead isSender:isSender];
}




- (instancetype)initWithVoicePath:(NSString *)voicePath
                         voiceUrl:(NSString *)voiceUrl
                    voiceDuration:(NSString *)voiceDuration
                         username:(NSString *)username
                        timeStamp:(NSString *)timeStamp
                         isSender:(BOOL)isSender
{
    
    return [self initWithVoicePath:voicePath voiceUrl:voiceUrl voiceDuration:voiceDuration username:username timeStamp:timeStamp isRead:NO isSender:isSender];
    
    
}
- (instancetype)initWithVoicePath:(NSString *)voicePath
                         voiceUrl:(NSString *)voiceUrl
                    voiceDuration:(NSString *)voiceDuration
                         username:(NSString *)username
                        timeStamp:(NSString *)timeStamp
                           isRead:(BOOL)isRead
                         isSender:(BOOL)isSender
{
    
    self = [super init];
    if (self) {
        self.voicePath = voicePath;
        
        
        self.username = username;
        self.timeStamp = timeStamp;
        self.isRead = isRead;
        self.voiceDuration = voiceDuration;
        
        self.bubbleMessageBodyType = MessageBodyTypeVoice;
        self.isSender = isSender;
    }
    return self;
}


@end
