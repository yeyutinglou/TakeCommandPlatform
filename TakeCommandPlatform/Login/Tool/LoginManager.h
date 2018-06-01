//
//  LoginManager.h
//  TakeCommandPlatform
//
//  Created by jyd on 2017/12/12.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
@interface LoginManager : NSObject

/** 账号 */
@property (nonatomic,copy) NSString *account;

/** 密码 */
@property (nonatomic,copy) NSString *password;

/** 记住密码 */
@property (nonatomic, assign) BOOL isPassword;

/** 自动登录 */
@property (nonatomic, assign) BOOL isLogin;

/** 用户数据 */
@property (nonatomic, strong) UserModel *user;


+ (instancetype)sharedInstance;


/** 清空登录状态 */
- (void)clearLoginState;

@end
