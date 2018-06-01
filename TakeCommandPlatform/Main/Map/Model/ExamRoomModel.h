//
//  ExamRoomModel.h
//  TakeCommandPlatform
//
//  Created by jyd on 2017/12/19.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ExamRoomModel : NSObject

/** 考场信息 */
@property (nonatomic, strong) NSArray *roominfo;

/** 考生信息 */
@property (nonatomic, strong) NSArray *seatInfo;

@end


@interface RoomInfo : NSObject
/** 考场id */
@property (nonatomic,copy) NSString *examroomid;

/** 考场名称 */
@property (nonatomic,copy) NSString *examname;

/** 考场代码 */
@property (nonatomic,copy) NSString *roomcode;

/** 转发ip1 */
@property (nonatomic,copy) NSString *forwardip1;

/** 转发端口1 */
@property (nonatomic,copy) NSString *portinfo1;

/** 设备类型（tps  海康    tdh 大华    ttfn  同方） */
@property (nonatomic,copy) NSString *devicetype;

/** sipurl */
@property (nonatomic,copy) NSString *sipurl;

/** osd信息 */
@property (nonatomic,copy) NSString *osd;

/** 设备ip */
@property (nonatomic,copy) NSString *machineip;

/** 通道号 */
@property (nonatomic,copy) NSString *channel;

/** 设备ip1 */
@property (nonatomic,copy) NSString *machineip1;

/** 转发ip */
@property (nonatomic,copy) NSString *forwardip;

/** 是否收藏 */
@property (nonatomic,copy) NSString *iscollection;

/** 转发端口 */
@property (nonatomic,copy) NSString *portinfo;

/** 是走转发还是走sip  1  sip   0   nosip */
@property (nonatomic,assign) BOOL siptype;

/** 设备url */
@property (nonatomic,copy) NSString *devurl;

/** 设备端口 */
@property (nonatomic,copy) NSString *deviceport;

/** sipip */
@property (nonatomic,copy) NSString *sipip;

@end
