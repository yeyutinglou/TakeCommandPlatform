//
//  StudentSeatModel.h
//  TakeCommandPlatform
//
//  Created by jyd on 2017/12/21.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StudentModel.h"
@class Device;
@interface StudentSeatModel : NSObject

///** 政治面貌 */
//@property (nonatomic,copy) NSString *status;
//
///** 出生日期 */
//@property (nonatomic, copy) NSString *datebir;
//
///** 考生号 */
//@property (nonatomic,copy) NSString *exam_code;
//
///** 考点号 */
//@property (nonatomic,copy) NSString *sitecode;
//
///** 考生id */
//@property (nonatomic,copy) NSString *studentid;
//
///** 座位号 */
//@property (nonatomic, copy) NSString *seatnum;
//
//
//
///** 科目 */
//@property (nonatomic,copy) NSString *subject;
//
///** bak */
//@property (nonatomic,copy) NSString *bak;
//
///** 性别 */
//@property (nonatomic,copy) NSString *sex;
//
///** 电话 */
//@property (nonatomic,copy) NSString *phone;
//
///** zip_code */
//@property (nonatomic,copy) NSString *zip_code;
//
///** 报名号 */
//@property (nonatomic,copy) NSString *ticketnum;
//
///** 邮箱 */
//@property (nonatomic,copy) NSString *email;
//
///** 种族 */
//@property (nonatomic,copy) NSString *nation;
//
///** student_sp */
//@property (nonatomic,copy) NSString *student_sp;
//
///** student_prize */
//@property (nonatomic,copy) NSString *student_prize;
//
///** 房间号 */
//@property (nonatomic,copy) NSString *roomcode;
//
///** 地址 */
//@property (nonatomic,copy) NSString *address;
//
///** 头像 */
//@property (nonatomic,copy) NSString *photo_url;
//
///** account_code */
//@property (nonatomic,copy) NSString *account_code;
//
///** 身份证号 */
//@property (nonatomic,copy) NSString *id_card;
//
///** 考生类别 */
//@property (nonatomic,copy) NSString *student_type;
//
///** 考试房间 */
//@property (nonatomic,copy) NSString *roomname;
//
///** 学校 */
//@property (nonatomic,copy) NSString *school;
//
///** 语音 */
//@property (nonatomic,copy) NSString *language;
//
///** 姓名 */
//@property (nonatomic,copy) NSString *studentname;
//
///** 学校 */
//@property (nonatomic,copy) NSString *sitechoolname;
//
///** draduate_site */
//@property (nonatomic,copy) NSString *draduate_site;
//
///** nplace */
//@property (nonatomic,copy) NSString *nplace;
//
///** draduate_type */
//@property (nonatomic,copy) NSString *draduate_type;
//
///** ip */
//@property (nonatomic,copy) NSString *ip;



/** 考试类型 */
@property (nonatomic,copy) NSString *examtype;

/** 考生 */
@property (nonatomic, strong) NSArray *students;

/** device */
@property (nonatomic, strong) Device *device;


/** 考生总数 */
@property (nonatomic, assign) NSInteger studentnum;


/** 列数(暂定写死) */
@property (nonatomic, assign) NSInteger column;

@end


@interface Device : NSObject

/** 摄像头位置 0左上1中左2左下3右上4中右5右下 */
@property (nonatomic, assign) NSInteger position;

/** sip地址 */
@property (nonatomic, copy) NSString *sipurl;

/** 是走转发还是走sip */
@property (nonatomic, copy) NSString *siptype;

/** 设备类型 */
@property (nonatomic, copy) NSString *device_type;

/** sip的ip */
@property (nonatomic, copy) NSString *sipip;

/** 设备id */
@property (nonatomic, copy) NSString *device_id;

/** 设备端口号 */
@property (nonatomic, copy) NSString *device_port;

/** 设备url */
@property (nonatomic, copy) NSString *device_url;

/** 通道号 */
@property (nonatomic, copy) NSString *channel;

/** 转发端口号 */
@property (nonatomic, copy) NSString *zf_port;

/** 转发ip */
@property (nonatomic, copy) NSString *zf_ip;

/** 设备ip */
@property (nonatomic, copy) NSString *device_ip;

@end
