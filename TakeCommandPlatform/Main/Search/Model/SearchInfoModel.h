//
//  SearchInfoModel.h
//  TakeCommandPlatform
//
//  Created by jyd on 2018/4/10.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Student;
@class Staff;
@class Room;
@class Site;
@interface SearchInfoModel : NSObject

/** 考生 */
@property (nonatomic, strong) NSArray *students;

/** 监考员 */
@property (nonatomic, strong) NSArray *staffs;

/** 考场 */
@property (nonatomic, strong) NSArray *rooms;

/** 考点 */
@property (nonatomic, strong) NSArray *sites;

/** state */
@property (nonatomic, assign) BOOL state;

/** error */
@property (nonatomic, copy) NSString *errorinfo;

@end

@interface Student : NSObject

/** 性别 */
@property (nonatomic, copy) NSString *sex;

/** 考场名称 */
@property (nonatomic, copy) NSString *roomname;

/** 准考证号 */
@property (nonatomic, copy) NSString *ticketnum;

/** 考点名称 */
@property (nonatomic, copy) NSString *sitename;

/** 考试编码 */
@property (nonatomic, copy) NSString *examcode;

/** 身份证号 */
@property (nonatomic, copy) NSString *idcard;

/** 学生姓名 */
@property (nonatomic, copy) NSString *studentname;

@end

@interface Staff : NSObject

/** 性别 */
@property (nonatomic, copy) NSString *sex;

/** 考场名称 */
@property (nonatomic, copy) NSString *roomname;

/** 考点名称 */
@property (nonatomic, copy) NSString *sitename;

/** 姓名 */
@property (nonatomic, copy) NSString *name;

/** 身份证号 */
@property (nonatomic, copy) NSString *idcard;

@end


@interface Room : NSObject

/** 考场id */
@property (nonatomic, copy) NSString *roomid;

/** 考场名称 */
@property (nonatomic, copy) NSString *roomname;

/** 考点名称 */
@property (nonatomic, copy) NSString *sitename;

@end


@interface Site : NSObject

/** 考点名称 */
@property (nonatomic, copy) NSString *sitename;

/** 考点id */
@property (nonatomic, copy) NSString *siteid;

@end
