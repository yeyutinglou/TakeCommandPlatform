//
//  AppDelegate.m
//  TakeCommandPlatform
//
//  Created by jyd on 2017/12/6.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import "AppDelegate.h"
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import "LoginViewController.h"
#import "BaseNavigationController.h"
#import "BaseTabBarController.h"
#import "LoginManager.h"

#import "DDLog.h"
#import "DDTTYLogger.h"

#import "MMDrawerController.h"
#import "LeftViewController.h"
#import "MainViewController.h"

static NSString *BaiduMapKEY = @"s4YhBEeQK8HNB4VfH4Ua71mXNEm3ZrYb";

@interface AppDelegate () <BMKGeneralDelegate>

@property (nonatomic, strong) BMKMapManager * mapManager;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self setupBaiduMapConfig];
    [self setupRootViewController];
   
    return YES;
}

///加载主界面
 - (void)setupRootViewController
{
    if ([LoginManager sharedInstance].isLogin) {
        BaseTabBarController *tab = [[BaseTabBarController alloc] init];
//        [UIApplication sharedApplication].keyWindow.rootViewController = tab;
        self.window.rootViewController = tab;
        [self.window makeKeyAndVisible];
    } else {
        LoginViewController *login = [[LoginViewController alloc] init];
        BaseNavigationController *na = [[BaseNavigationController alloc] initWithRootViewController:login];
        self.window.rootViewController = na;
    }

    
}

/*
 *启动百度地图配置
 */
- (void)setupBaiduMapConfig
{
    self.mapManager = [[BMKMapManager alloc] init];
    /**
     *百度地图SDK所有接口均支持百度坐标（BD09）和国测局坐标（GCJ02），用此方法设置您使用的坐标类型.
     *默认是BD09（BMK_COORDTYPE_BD09LL）坐标.
     *如果需要使用GCJ02坐标，需要设置CoordinateType为：BMK_COORDTYPE_COMMON.
     */
    if ([BMKMapManager setCoordinateTypeUsedInBaiduMapSDK:BMK_COORDTYPE_BD09LL]) {
        NSLog(@"经纬度类型设置成功");
    } else {
        NSLog(@"经纬度类型设置失败");
    }
    BOOL ret = [_mapManager start:BaiduMapKEY generalDelegate:self];
    if (!ret) {
        NSLog(@"manager start failed!");
    }
}

- (void)onGetNetworkState:(int)iError
{
    if (0 == iError) {
        NSLog(@"联网成功");
    }
    else{
        NSLog(@"onGetNetworkState %d",iError);
    }
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        NSLog(@"授权成功");
    }
    else {
        NSLog(@"onGetPermissionState %d",iError);
    }
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    
    if (self.allowRotation) {
        return  UIInterfaceOrientationMaskAllButUpsideDown;
    }
    return UIInterfaceOrientationMaskPortrait;
}


@end
