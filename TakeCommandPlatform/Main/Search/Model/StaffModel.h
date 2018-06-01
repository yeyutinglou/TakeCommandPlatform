//
//  StaffModel.h
//  TakeCommandPlatform
//
//  Created by jyd on 2018/4/12.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StaffModel : NSObject

/** 考场id */
@property (nonatomic, copy) NSString *roomid;

/** 监考员id */
@property (nonatomic, copy) NSString *staffId;

/** 监考员性别 */
@property (nonatomic, copy) NSString *sex;

/** 考场名称 */
@property (nonatomic, copy) NSString *roomname;

/** 考点名称 */
@property (nonatomic, copy) NSString *sitename;

/** 监考员姓名 */
@property (nonatomic, copy) NSString *name;

/** 监考员身份证号 */
@property (nonatomic, copy) NSString *idcards;

/** 考点id */
@property (nonatomic, copy) NSString *siteid;
@end
