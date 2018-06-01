//
//  ChatTextMessageModel.m
//  TakeCommandPlatform
//
//  Created by jyd on 2018/3/5.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import "ChatTextMessageModel.h"

@implementation ChatTextMessageModel

+ (instancetype)text:(NSString *)text
            username:(NSString *)username
           timeStamp:(NSString *)timeStamp
            isSender:(BOOL)isSender

{
    return [[self alloc]initWithText:text username:username timeStamp:timeStamp isSender:isSender];
}


- (instancetype)initWithText:(NSString *)text
                    username:(NSString *)username
                   timeStamp:(NSString *)timeStamp
                    isSender:(BOOL)isSender

{
    self = [super init];
    if (self) {
        self.text = text;
        
        self.username = username;
        self.timeStamp = timeStamp;
        
        self.bubbleMessageBodyType = MessageBodyTypeText;
        self.isSender = isSender;
    }
    return self;
    
}
@end
