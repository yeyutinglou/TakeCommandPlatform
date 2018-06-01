//
//  UIViewController+Child.m
//  Vocational
//
//  Created by jyd on 16/5/16.
//  Copyright © 2016年 jyd. All rights reserved.
//

#import "UIViewController+Child.h"

@implementation UIViewController (Child)


-(void)displayViewController:(UIViewController *)viewController view:(UIView *)view
{
    [self addChildViewController:viewController];
    viewController.view.frame = view.bounds;
    [view addSubview:viewController.view];
    [viewController didMoveToParentViewController:self];
}

-(void)showBackBtn
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    btn.size = btn.currentImage.size;
    [btn addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btn];
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
