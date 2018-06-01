//
//  BaseAreaView.m
//  TakeCommandPlatform
//
//  Created by jyd on 2018/3/21.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import "BaseAreaView.h"

@interface BaseAreaView ()

/** imageView */
@property (nonatomic, strong) UIImageView *imageView;

/** label */
@property (nonatomic, strong) UILabel *label;


@end

@implementation BaseAreaView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    
}
@end
