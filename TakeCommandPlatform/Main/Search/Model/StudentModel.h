//
//  StudentModel.h
//  TakeCommandPlatform
//
//  Created by jyd on 2018/4/11.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StudentModel : NSObject

/** 考生获得奖项 */
@property (nonatomic, copy) NSString *student_prize;

/** 生日 */
@property (nonatomic, copy) NSString *birthday;

/** 性别 */
@property (nonatomic, copy) NSString *sex;

/** 部门编码 */
@property (nonatomic, copy) NSString *treecode;

/** 考点名称 */
@property (nonatomic, copy) NSString *sitename;

/** 邮编 */
@property (nonatomic, copy) NSString *zip_code;

/** 科目类型 */
@property (nonatomic, copy) NSString *subject;

/** 户口代号 */
@property (nonatomic, copy) NSString *account_code;

/** 毕业类型 */
@property (nonatomic, copy) NSString *draduate_type;

/** 毕业学校 */
@property (nonatomic, copy) NSString *draduate_site;

/** 身份证号 */
@property (nonatomic, copy) NSString *id_card;

/** 考生id */
@property (nonatomic, copy) NSString *studentId;

/** 考场名称 */
@property (nonatomic, copy) NSString *roomname;

/** 考生姓名 */
@property (nonatomic, copy) NSString *s_name;

/** 考生号 */
@property (nonatomic, copy) NSString *exam_code;

/** 户口地址 */
@property (nonatomic, copy) NSString *account_address;

/** 座位号 */
@property (nonatomic, copy) NSString *seatnum;

/** 电话 */
@property (nonatomic, copy) NSString *phone;

/** 名族 */
@property (nonatomic, copy) NSString *nation;

/** 特长 */
@property (nonatomic, copy) NSString *student_sp;

/** 政治面貌 */
@property (nonatomic, copy) NSString *status;



@end
