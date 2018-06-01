//
//  ServiceConfigManager.m
//  TakeCommandPlatform
//
//  Created by jyd on 2017/12/12.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import "ServiceConfigManager.h"

@implementation ServiceConfigManager

static ServiceConfigManager *manager;
+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ServiceConfigManager alloc] init];
    });
    return manager;
}

- (NSString *)serviceAddress
{
    return [self getObjectForKey:@"serviceAddress"];
}

- (NSString *)videophoneAddress
{
    return [self getObjectForKey:@"videophoneAddress"];
}

- (NSString *)videoConferenceAddress
{
    return [self getObjectForKey:@"videoConferenceAddress"];
}

- (NSString *)testingAddress
{
    return [self getObjectForKey:@"testAddress"];
}

- (NSString *)chartAddress
{
    return [self getObjectForKey:@"chartsAddress"];
}

- (NSString *)getObjectForKey:(NSString *)key
{
    NSString * obj = [[NSUserDefaults standardUserDefaults] objectForKey:key];
//    if (![obj containsString:@"http"] && obj) {
//        obj = [NSString stringWithFormat:@"http://%@",obj];
//    }
    return obj;
}

- (NSString *)getURLWithAddress:(NSString *)address
{
    if (![address hasPrefix:@"http://"] && address) {
        return [NSString stringWithFormat:@"http://%@",address];
    }
    return address;
    
}

@end
