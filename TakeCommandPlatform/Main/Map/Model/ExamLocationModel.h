//
//  ExamLocationModel.h
//  TakeCommandPlatform
//
//  Created by jyd on 2017/12/19.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExamLocationModel : NSObject

/** 考点id */
@property (nonatomic,copy) NSString *examLocationId;

/** 考区代码 */
@property (nonatomic, copy) NSString *areacode;

/** 考生总数（本考点） */
@property (nonatomic, assign) NSInteger studentscounts;

/** 考点代码 */
@property (nonatomic, copy) NSString *sitecode;

/** 考场总数 */
@property (nonatomic, assign) NSInteger examroomcounts;

/** 坐标值x */
@property (nonatomic,copy) NSString *x;

/** 坐标值y */
@property (nonatomic,copy) NSString *y;

/** 文史考场数 */
@property (nonatomic,assign) NSInteger wsroomsnum;

/** 考点位置 */
@property (nonatomic,copy) NSString *sitelocation;

/** 负责人电话 */
@property (nonatomic,copy) NSString *siteresponphone;

/** 是否显示（Y  显示    N 不显示） */
@property (nonatomic,copy) NSString *flag;

/** 理工考场数 */
@property (nonatomic, assign) NSInteger lgroomsnum;

/** 考试类型（高考、统考等） */
@property (nonatomic,copy) NSString *examtype;

/** 单招高职考场 */
@property (nonatomic, assign) NSInteger gzroomsnum;

/** 考区名称 */
@property (nonatomic,copy) NSString *areaname;

/** 考点名称 */
@property (nonatomic,copy) NSString *sitename;

/** 考点负责人 */
@property (nonatomic,copy) NSString *siteresponsible;

@end
