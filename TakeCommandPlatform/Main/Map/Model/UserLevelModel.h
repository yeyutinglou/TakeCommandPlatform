//
//  UserLevelModel.h
//  TakeCommandPlatform
//
//  Created by jyd on 2018/3/28.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BaseInfo;
@class UserInfo;
@class ParentInfo;
@class SchoolSite;
@class ProvinceSite;
@class CitySite;
@class CountySite;
@class SchoolSites;
@interface UserLevelModel : NSObject

/** 本级用户 */
@property (nonatomic, strong) UserInfo *info;

/** 上级用户 */
@property (nonatomic, strong) ParentInfo *parentInfo;

/** 巡考员 */
@property (nonatomic, strong) NSArray *patrolAccount;

/** 下级用户 */
@property (nonatomic, strong) NSArray *subInfos;

/** 校级考点用户 */
@property (nonatomic, strong) SchoolSite *schoolSite;


@end


//基础用户信息
@interface BaseInfo : NSObject

/** 考点数 */
@property (nonatomic, assign) NSInteger sitenum;

/** 用户等级 */
@property (nonatomic, assign) NSInteger lev;

/** 本级名称 */
@property (nonatomic, copy) NSString *orgname;

/** 考生总数 */
@property (nonatomic, assign) NSInteger studentnum;

/** 考场总数 */
@property (nonatomic, assign) NSInteger roomnum;

/** 行政id */
@property (nonatomic, copy) NSString *orgid;

/** 纬度 */
@property (nonatomic, assign) double latitude;

/** 经度 */
@property (nonatomic, assign) double longitude;

/** 缩放等级 */
@property (nonatomic, assign) float zoomlevel;

/** 账号 */
@property (nonatomic, strong) NSArray *accounts;

@end

//本级用户信息
@interface UserInfo  : BaseInfo



@end

//上级用户信息
@interface ParentInfo : BaseInfo


@end



//账号信息
@interface AccountInfo : NSObject

/** userid */
@property (nonatomic, copy) NSString *userid;

/** 账号 */
@property (nonatomic, copy) NSString *account;

@end

//巡考员
@interface PatrolInfo : NSObject

/** 账号 */
@property (nonatomic, copy) NSString *account;

/** id */
@property (nonatomic, copy) NSString *userid;

/** 用户名 */
@property (nonatomic, copy) NSString *username;
@end


///学校
@interface SchoolSite : NSObject

/** wsroomsnum */
@property (nonatomic, assign) NSInteger wsroomsnum;

/** 位置 */
@property (nonatomic, copy) NSString *sitelocation;

/** gzroomsnum */
@property (nonatomic, assign) NSInteger gzroomsnum;

/** 等级 */
@property (nonatomic, assign) NSInteger lev;

/** areaname */
@property (nonatomic, copy) NSString *areaname;

/** sitename */
@property (nonatomic, copy) NSString *sitename;

/** examroomcounts */
@property (nonatomic, assign) NSInteger examroomcounts;

/** userid */
@property (nonatomic, copy) NSString *userid;

/** areacode */
@property (nonatomic, copy) NSString *areacode;

/** studentscounts */
@property (nonatomic, assign) NSInteger studentscounts;

/** zoomlevel */
@property (nonatomic, assign) double zoomlevel;

/** examtype */
@property (nonatomic, copy) NSString *examtype;

/** sitecode */
@property (nonatomic, copy) NSString *sitecode;

/** siteresponphone */
@property (nonatomic, copy) NSString *siteresponphone;

/** lgroomsnum */
@property (nonatomic, assign) NSInteger lgroomsnum;

/** 账号 */
@property (nonatomic, copy) NSString *account;

/** siteid */
@property (nonatomic, copy) NSString *siteid;

/** siteresponsible */
@property (nonatomic, copy) NSString *siteresponsible;

/** y  */
@property (nonatomic, assign) double y;

/** x */
@property (nonatomic, assign) double x;

@end

//省级
@interface ProvinceSite : NSObject

/** 市级 */
@property (nonatomic, strong) NSArray *citySites;

/** info */
@property (nonatomic, strong) UserInfo *info;

@end

//市级
@interface CitySite : NSObject

/** 县级 */
@property (nonatomic, strong) NSArray *countrySites;

/** info */
@property (nonatomic, strong) UserInfo *info;



@end

//县级
@interface CountySite : NSObject

/** 校级 */
@property (nonatomic, strong) NSArray *schoolSites;

/** info */
@property (nonatomic, strong) UserInfo *info;
@end



