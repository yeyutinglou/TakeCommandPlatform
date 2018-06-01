//
//  OfflineMapViewController.h
//  TakeCommandPlatform
//
//  Created by jyd on 2018/1/10.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
@interface OfflineMapViewController : UIViewController

@property (nonatomic, assign) int cityId;
@property (nonatomic, strong) BMKOfflineMap* offlineServiceOfMapview;
@end
