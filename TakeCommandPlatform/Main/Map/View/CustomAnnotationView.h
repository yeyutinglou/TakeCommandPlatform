//
//  CustomAnnotationView.h
//  TakeCommandPlatform
//
//  Created by jyd on 2017/12/25.
//  Copyright © 2017年 jyd. All rights reserved.
//
#import <BaiduMapAPI_Map/BMKMapComponent.h>
//#import <BaiduMapAPI_Map/BMKAnnotationView.h>
//#import <BaiduMapAPI_Map/BaiduMapAPI_Map.h>
#import "UserLevelModel.h"

@interface CustomAnnotationView : BMKAnnotationView




/** 图片 */
@property (nonatomic, strong) UIImage *img;

/** 地点 */
@property (nonatomic, copy) NSString *address;


/** 本级名称 */
@property (nonatomic, copy) NSString *orgName;

/** 考试人数 */
@property (nonatomic, assign) NSInteger stuNum;

/** 考场数 */
@property (nonatomic, assign) NSInteger examRoomNum;

/** 考点数 */
@property (nonatomic, assign) NSInteger siteNum;

/** 是否选中 */
@property (nonatomic, assign) BOOL isSelect;

/** userLevelModel */
@property (nonatomic, strong) UserLevelModel *userLevelModel;



- (void)addTarget:(id)target action:(SEL)action;



@end
