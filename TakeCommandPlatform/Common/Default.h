//
//  Default.h
//  TakeCommandPlatform
//
//  Created by jyd on 2017/12/7.
//  Copyright © 2017年 jyd. All rights reserved.
//

#ifndef Default_h
#define Default_h

#define  kBaiduMap_key @"s4YhBEeQK8HNB4VfH4Ua71mXNEm3ZrYb"

///服务器地址
#define kServiceAdress [[ServiceConfigManager sharedInstance] getURLWithAddress:[ServiceConfigManager sharedInstance].serviceAddress]

#pragma mark - User
///用户key
#define kUserKey @"userKey"

//用户数据
#define kUser  [LoginManager sharedInstance].user
//用户id
#define kUserId kUser.userId
//用户sessionid
#define kUserSessionid kUser.sessionid
///用户等级
#define kUserLevel kUser.userLevel
//用户登录状态判断
#define kUserState kUser.loginState
//用户账户
#define kUserAccount kUser.acccount

#endif /* Default_h */
