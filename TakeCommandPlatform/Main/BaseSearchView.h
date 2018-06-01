//
//  BaseSearchView.h
//  TakeCommandPlatform
//
//  Created by jyd on 2018/3/20.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseSearchView : UIView

+ (instancetype)initializeView;


- (void)addTarget:(id)target action:(SEL)action;

@end
