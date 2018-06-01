//
//  MessageSendManager.h
//  TakeCommandPlatform
//
//  Created by jyd on 2018/3/7.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatMessageModel.h"
#import "ChatMessageServiceModel.h"
@interface MessageSendManager : NSObject

/**
 *  @brief 发送消息
 *
 *  @param message         消息
 *  @param completion 返回消息,含消息发送状态:
 */
+ (void)sendMessage:(ChatMessageModel *)message
         completion:(void(^)(ChatMessageServiceModel *))completion;

@end
