//
//  MapLocationViewController.h
//  TakeCommandPlatform
//
//  Created by jyd on 2018/3/12.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MapType) {
    ///定位
    MapTypeLocation,
    ///位置
    MapTypePosition
};

@interface MapLocationViewController : UIViewController

/** block */
@property (nonatomic, copy) void(^completion)(NSString *address, CLLocation *location, UIImage *image, NSError *error);

/** mapType */
@property (nonatomic, assign) MapType mapType;

/** location */
@property (nonatomic, strong) CLLocation *location;


@end
