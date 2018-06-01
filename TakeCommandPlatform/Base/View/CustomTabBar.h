//
//  CustomTabBar.h
//  TakeCommandPlatform
//
//  Created by jyd on 2017/12/12.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TabBarButton.h"

@class CustomTabBar;

@protocol CustomTabBarDelegete <NSObject>

@optional
-(void)tabBar:(CustomTabBar *) tabBar didSelectedButtonFrom:(NSInteger)from  to:(NSInteger)to;


@end
@interface CustomTabBar : UIView

- (void)addTabBarButtonWithItem:(UITabBarItem *) item;

//自定义协议，用于Button点击的时候导航之间的相互切换
@property (nonatomic, weak) id<CustomTabBarDelegete> delegete;

@property (nonatomic, strong) TabBarButton *selectedButton;

- (void)btnClick:(TabBarButton *) button;

@end
