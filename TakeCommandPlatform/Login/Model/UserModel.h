//
//  UserModel.h
//  TakeCommandPlatform
//
//  Created by jyd on 2017/12/12.
//  Copyright © 2017年 jyd. All rights reserved.
//



#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, LoginState) {
    ///登录失败
    LoginStateFail,
    ///登录成功
    LoginStateSuccess,
    
};

typedef NS_ENUM(NSUInteger, UserLevel) {
    ///国家
    UserLevelCountry = 1,
    ///省
    UserLevelProvince,
    ///市
    UserLevelCity,
    ///县
    UserLevelCounty,
    ///考点
    UserLevelExamSite,
    ///巡考员
    UserLevelExaminer
};

@interface UserModel : NSObject


/** sessionid */
@property (nonatomic,copy) NSString *sessionid;

/** userid */
@property (nonatomic,copy) NSString *userId;

/** 用户等级 */
@property (nonatomic,assign) NSInteger userlev;

/** 用户等级 */
@property (nonatomic, assign) UserLevel userLevel;

/** 账号 */
@property (nonatomic,copy) NSString *acccount;

/** 用户名 */
@property (nonatomic,copy) NSString *username;

/** 考试任务名称 */
@property (nonatomic,copy) NSString *examtaskname;


/** 考试任务id */
@property (nonatomic,copy) NSString *examtaskid;

/** 登录状态 */
@property (nonatomic, assign) NSInteger state;

/** 登录状态 */
@property (nonatomic, assign) LoginState loginState;

/** 有无巡考任务 0没有 1 有 */
@property (nonatomic, assign) BOOL ispatrol;

/** 失败信息 */
@property (nonatomic, copy) NSString *errorinfo;

@end
