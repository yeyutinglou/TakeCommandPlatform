//
//  StudentSearchModel.h
//  TakeCommandPlatform
//
//  Created by jyd on 2017/12/25.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import "StudentSeatModel.h"

@interface StudentSearchModel : StudentSeatModel

/** 设备端口 */
@property (nonatomic,copy) NSString *deviceport;

/** 设备类型（tps  海康    tdh 大华    ttfn  同方） */
@property (nonatomic,copy) NSString *devicetype;

/** 服务ip */
@property (nonatomic,copy) NSString *serviceip;

/** 设备url */
@property (nonatomic,copy) NSString *devurl;

/** 通道号 */
@property (nonatomic,copy) NSString *channel;

/** sipip */
@property (nonatomic,copy) NSString *sipip;

/** 是走转发还是走sip  1  sip   0   nosip */
@property (nonatomic,assign) BOOL siptype;

/** 服务port */
@property (nonatomic,copy) NSString *serverport;

@end
