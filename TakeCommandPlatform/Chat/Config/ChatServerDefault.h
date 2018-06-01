//
//  ChatServerDefault.h
//  TakeCommandPlatform
//
//  Created by jyd on 2018/3/2.
//  Copyright © 2018年 jyd. All rights reserved.
//

#ifndef ChatServerDefault_h
#define ChatServerDefault_h

/**
 *  消息类型
 */
typedef NS_ENUM(NSUInteger, MessageBodyType) {
    /**
     *  纯文本消息
     */
    MessageBodyTypeText = 0,
    /**
     *  图片消息
     */
    MessageBodyTypePhoto = 1,
    /**
     *  视频消息
     */
    MessageBodyTypeVideo = 2,
    /**
     *  音频消息
     */
    MessageBodyTypeVoice = 3,
    /**
     *  位置消息
     */
    MessageBodyTypeLocation = 4,
};

/**
 *  @brief 聊天消息发送状态
 */
typedef NS_ENUM(NSInteger, MessageDeliveryState) {
    /**
     *  正在发送
     */
    MessageDeliveryStateDelivering,
    /**
     *  已发送, 成功
     */
    MessageDeliveryStateDelivered,
    /**
     *  已发送, 失败
     */
    MessageDeliveryStateFailure
};

#endif /* ChatServerDefault_h */
