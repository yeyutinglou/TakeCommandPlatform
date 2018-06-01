//
//  LoginManager.m
//  TakeCommandPlatform
//
//  Created by jyd on 2017/12/12.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import "LoginManager.h"

#define accountKey @"account"

#define passwordKey @"password"

#define isPasswordKey @"isPassword"

#define isLoginKey @"isLogin"

@implementation LoginManager

static LoginManager *manager;
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LoginManager alloc] init];
    });
    return manager;
}

- (NSString *)account
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:accountKey];
}

- (NSString *)password
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:passwordKey];
}

- (BOOL)isPassword
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:isPasswordKey];
}

- (BOOL)isLogin
{
    return [[NSUserDefaults standardUserDefaults] boolForKey:isLoginKey];
}
- (void)setIsLogin:(BOOL)isLogin
{
    [[NSUserDefaults standardUserDefaults] setBool:isLogin forKey:isLoginKey];
}

- (UserModel *)user
{
    id json = [[NSUserDefaults standardUserDefaults] objectForKey:kUserKey];
    UserModel * user = [UserModel yy_modelWithJSON:json];
    return user;
}

- (void)clearLoginState
{
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:isLoginKey];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:isPasswordKey];
     [[NSUserDefaults standardUserDefaults] setObject:nil forKey:accountKey];
     [[NSUserDefaults standardUserDefaults] setObject:nil forKey:passwordKey];
}
@end
