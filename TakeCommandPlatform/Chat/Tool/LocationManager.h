//
//  LocationManager.h
//  TakeCommandPlatform
//
//  Created by jyd on 2018/3/13.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void (^SystemLocationBlock)(CLLocation *location, NSError *error);
@interface LocationManager : NSObject

singleton_interface(LocationManager)

/**
 启动系统动物

 @param systemLocationBlock <#systemLocationBlock description#>
 */
- (void)startSystemLocationWithRes:(SystemLocationBlock)systemLocationBlock;


/**
 获取定位地址

 @param location 地点
 @param completion <#completion description#>
 */
- (void)address:(CLLocation *)location completion:(void(^)(NSString *,CLLocation *, NSError *))completion;
@end
