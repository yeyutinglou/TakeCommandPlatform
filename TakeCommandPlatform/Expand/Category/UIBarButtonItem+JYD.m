//
//  UIBarButtonItem+MJ.m
//  ItcastWeibo
//
//  Created by apple on 14-5-6.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "UIBarButtonItem+JYD.h"

@implementation UIBarButtonItem (JYD)
+ (UIBarButtonItem *)itemWithIcon:(NSString *)icon highIcon:(NSString *)highIcon target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:icon] forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:highIcon] forState:UIControlStateHighlighted];
    button.frame = (CGRect){CGPointZero, button.currentBackgroundImage.size};
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    //UIView *tmpView = [[UIView alloc] initWithFrame:button.bounds];
    //UIView *tmpView = [[UIView alloc] initWithFrame:CGRectMake(10, 24, 44, 44)];
    //tmpView.bounds = CGRectOffset(tmpView.bounds, -6, 0);
    //[tmpView addSubview:button];
    
    //return [[UIBarButtonItem alloc] initWithCustomView:tmpView];
    return [[UIBarButtonItem alloc] initWithCustomView:button];
}

+ (UIBarButtonItem *)itemWithTitle:(NSString *)title target:(id)target action:(SEL)action
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:HEXCOLOR(0x0068B7) forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, 40, 40);
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    

    return [[UIBarButtonItem alloc] initWithCustomView:button];
}
@end
