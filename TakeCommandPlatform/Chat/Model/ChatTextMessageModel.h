//
//  ChatTextMessageModel.h
//  TakeCommandPlatform
//
//  Created by jyd on 2018/3/5.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatMessageModel.h"
@interface ChatTextMessageModel : ChatMessageModel

+ (instancetype)text:(NSString *)text
            username:(NSString *)username
           timeStamp:(NSString *)timeStamp
            isSender:(BOOL)isSender;
@end
