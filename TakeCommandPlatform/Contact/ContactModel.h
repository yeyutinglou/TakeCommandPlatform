//
//  ContactModel.h
//  TakeCommandPlatform
//
//  Created by jyd on 2018/5/30.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactModel : NSObject

/** 用户id */
@property (nonatomic, copy) NSString *userId;

/** 用户名称 */
@property (nonatomic, copy) NSString *userName;

/** 账号 */
@property (nonatomic, copy) NSString *acccount;

@end
