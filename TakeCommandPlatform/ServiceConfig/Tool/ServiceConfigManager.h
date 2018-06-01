//
//  ServiceConfigManager.h
//  TakeCommandPlatform
//
//  Created by jyd on 2017/12/12.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServiceConfigManager : NSObject

/** 服务器地址 */
@property (nonatomic,copy) NSString *serviceAddress;

/** 可视电话地址 */
@property (nonatomic,copy) NSString *videophoneAddress;

/** 视频会议地址 */
@property (nonatomic,copy) NSString *videoConferenceAddress;

/** 培训测试地址 */
@property (nonatomic,copy) NSString *testingAddress;

/** 图表地址 */
@property (nonatomic,copy) NSString *chartAddress;



+ (instancetype)sharedInstance;

- (NSString *)getURLWithAddress:(NSString *)address;

@end
