//
//  Receiver.h
//  TakeCommandPlatform
//
//  Created by jyd on 2018/1/3.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReceiverModel : NSObject

/** 用户id */
@property (nonatomic,copy) NSString *receiverId;

/** 考点编码 */
@property (nonatomic,copy) NSString *account;

/** 考点名称 */
@property (nonatomic,copy) NSString *username;

/** 考点状态（1-通话中    -1-不在线    0-在线） */
@property (nonatomic,assign) int state;



@end
