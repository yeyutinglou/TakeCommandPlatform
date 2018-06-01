//
//  MBProgressHUD+MJ.m
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD+MJ.h"

@implementation MBProgressHUD (MJ)

+ (UIWindow *)lastWindow
{
    NSArray *windows = [UIApplication sharedApplication].windows;
    for(UIWindow *window in [windows reverseObjectEnumerator]) {
        
        if ([window isKindOfClass:[UIWindow class]] && !window.hidden &&
            CGRectEqualToRect(window.bounds, [UIScreen mainScreen].bounds))
            
            return window;
    }
    
    return [UIApplication sharedApplication].keyWindow;
}


#pragma mark 显示信息
+ (void)show:(NSString *)text icon:(NSString *)icon view:(UIView *)view
{
    if (view == nil) view = [self lastWindow];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = text;
    // 设置图片
//    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:[NSString stringWithFormat:@"MBProgressHUD.bundle/%@", icon]]];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    
    // 1秒之后再消失
    [hud hide:YES afterDelay:1.0];
}

#pragma mark 显示错误信息
+ (void)showError:(NSString *)error toView:(UIView *)view{
    [self show:error icon:@"error.png" view:view];
}

+ (void)showSuccess:(NSString *)success toView:(UIView *)view
{
    [self show:success icon:@"success.png" view:view];
}

#pragma mark 显示一些信息
+ (MBProgressHUD *)showMessage:(NSString *)message toView:(UIView *)view {
    if (view == nil) view = [self lastWindow];
    // 快速显示一个提示信息
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = message;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // YES代表需要蒙版效果
    hud.dimBackground = NO;
    return hud;
}

+ (void)showSuccess:(NSString *)success
{
    [self showSuccess:success toView:nil];
}

+ (void)showError:(NSString *)error
{
    [self showError:error toView:nil];
}

+ (MBProgressHUD *)showMessage:(NSString *)message
{
    return [self showMessage:message toView:nil];
}

+ (void)hideHUDForView:(UIView *)view
{
    if (view == nil) view = [self lastWindow];
    [self hideHUDForView:view animated:YES];
}

+ (void)hideHUD
{
    [self hideHUDForView:nil];
}

+ (void)showMomentAlertWithMessage:(NSString *)message
{
    UIView *view = [self lastWindow];
    MBProgressHUD *_progressHUD = [[MBProgressHUD alloc] initWithView:view];
    _progressHUD.alpha = 0.5;
    [view addSubview:_progressHUD];
    
    // The sample image is based on the work by http://www.pixelpressicons.com, http://creativecommons.org/licenses/by/2.5/ca/
    // Make the customViews 37 by 37 pixels for best results (those are the bounds of the build-in progress indicators)
    _progressHUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"37x-Checkmark"]];
    
    // Set custom view mode
    _progressHUD.mode = MBProgressHUDModeCustomView;
    
    _progressHUD.labelText = message;
    
    [_progressHUD show:YES];
    [_progressHUD hide:YES afterDelay:1];
}
@end
