//
//  ExaminationRoomModel.h
//  TakeCommandPlatform
//
//  Created by jyd on 2018/4/12.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ExamSite;
@class ExamRoom;
@interface ExaminationRoomModel : NSObject

/** 考点 */
@property (nonatomic, strong) ExamSite *examsite_info;


/** 考场 */
@property (nonatomic, strong) NSArray *examroom;

@end

@interface ExamSite : NSObject

/** 考生数 */
@property (nonatomic, assign) NSInteger student_num;

/** 考点负责人 */
@property (nonatomic, copy) NSString *principal;

/** examroom_num */
@property (nonatomic, assign) NSInteger examroom_num;

/** 联系电话 */
@property (nonatomic, copy) NSString *contact_phone;

/** 区域名称 */
@property (nonatomic, copy) NSString *examarea_name;

/** 联系地址 */
@property (nonatomic, copy) NSString *contact_address;


@end



@interface ExamRoom : NSObject

/** 考场id */
@property (nonatomic, copy) NSString *roomid;

/** 考场名称 */
@property (nonatomic, copy) NSString *roomname;

@end
