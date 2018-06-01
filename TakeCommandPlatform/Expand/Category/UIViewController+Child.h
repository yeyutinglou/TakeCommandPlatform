//
//  UIViewController+Child.h
//  Vocational
//
//  Created by jyd on 16/5/16.
//  Copyright © 2016年 jyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Child)


-(void)displayViewController:(UIViewController *)viewController view:(UIView *)view;


-(void)showBackBtn;

-(void)back;
@end
