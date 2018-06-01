//
//  ChatVoiceMessageModel.h
//  TakeCommandPlatform
//
//  Created by jyd on 2018/3/5.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import "ChatMessageModel.h"

@interface ChatVoiceMessageModel : ChatMessageModel

+ (instancetype)voicePath:(NSString *)voicePath
                 voiceUrl:(NSString *)voiceUrl
            voiceDuration:(NSString *)voiceDuration
                 username:(NSString *)username
                timeStamp:(NSString *)timeStamp
                 isSender:(BOOL)isSender;



+ (instancetype)voicePath:(NSString *)voicePath
                 voiceUrl:(NSString *)voiceUrl
            voiceDuration:(NSString *)voiceDuration
                 username:(NSString *)username
                timeStamp:(NSString *)timeStamp
                   isRead:(BOOL)isRead
                 isSender:(BOOL)isSender;

@end
