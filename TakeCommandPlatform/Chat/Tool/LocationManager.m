//
//  LocationManager.m
//  TakeCommandPlatform
//
//  Created by jyd on 2018/3/13.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import "LocationManager.h"

@interface LocationManager ()<CLLocationManagerDelegate>
/** locationManager */
@property (nonatomic, strong) CLLocationManager *locationManager;

/** geocoder */
@property (nonatomic, strong) CLGeocoder *geocoder;

/** block */
@property (nonatomic, copy) SystemLocationBlock systemLocationBlock;

@end
@implementation LocationManager

singleton_implementation(LocationManager)

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (status == kCLAuthorizationStatusNotDetermined) {
        NSLog(@"等待用户授权");
    } else if (status == kCLAuthorizationStatusAuthorizedAlways || status == kCLAuthorizationStatusAuthorizedWhenInUse) {
        NSLog(@"授权成功");
    }
}

- (void)startSystemLocationWithRes:(SystemLocationBlock)systemLocationBlock
{
    self.systemLocationBlock = systemLocationBlock;
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if ([UIDevice currentDevice].systemVersion.integerValue >= 8) {
        [self.locationManager requestAlwaysAuthorization];
    }
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *currentLocation = [locations lastObject];
    self.systemLocationBlock(currentLocation, nil);
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    if ([error code]==kCLErrorDenied) {
        NSLog(@"访问被拒绝");
    }
    if ([error code]==kCLErrorLocationUnknown) {
        NSLog(@"无法获取位置信息");
    }
    self.locationManager.delegate = nil;
    [self.locationManager stopUpdatingLocation];
    
    self.systemLocationBlock(nil, error);
}

- (void)address:(CLLocation *)location completion:(void (^)(NSString *, CLLocation *, NSError *))completion
{
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        CLPlacemark *placeMark = [placemarks firstObject];
        NSString *name = placeMark.name;
        if (error) {
            completion? completion(nil, nil, error) : nil;
        } else {
            completion ? completion(name, location, nil) :nil;
        }
    }];
}

#pragma mark — setter & getter
- (CLGeocoder *)geocoder
{
    if (_geocoder == nil) {
        _geocoder = [[CLGeocoder alloc] init];
    }
    return _geocoder;
}

@end
