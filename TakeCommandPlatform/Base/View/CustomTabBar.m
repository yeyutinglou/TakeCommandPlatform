//
//  CustomTabBar.m
//  TakeCommandPlatform
//
//  Created by jyd on 2017/12/12.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import "CustomTabBar.h"

@implementation CustomTabBar

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
//        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"tabbar_bg"]];
    }
    return self;
}

/**
 *为自定义TabBar添加自定义按钮
 */
-(void)addTabBarButtonWithItem:(UITabBarItem *)item
{
    TabBarButton *button = [[TabBarButton alloc] init];
    button.item = item;
    
    [self addSubview:button];
    
    //默认选中第一个按钮
    if (self.subviews.count == 1) {
        [self btnClick:button];
    }
    
    //添加监听事件
    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
}

-(void)btnClick:(TabBarButton *) button
{
    self.selectedButton.selected = NO;
    button.selected = YES;
    self.selectedButton = button;

    //通知代理
    //切换导航控制器
    if ([self.delegete respondsToSelector:@selector(tabBar:didSelectedButtonFrom:to:)])
    {
        [self.delegete tabBar:self didSelectedButtonFrom:button.tag to:self.selectedButton.tag];
    }
    
    
}

/**
 *为添加的子按钮进行布局
 */
-(void)layoutSubviews
{
    //子控件数目
    NSInteger counts = self.subviews.count;
    CGFloat buttonW = self.frame.size.width / counts;
    CGFloat buttonH = self.frame.size.height;
    CGFloat buttonY = 0;
    
    for (int i=0; i<counts; i++)
    {
        //1.取出按钮
        TabBarButton *button = [self.subviews objectAtIndex:i];
        //2.设置位置
        CGFloat buttonX = buttonW * (i);
        //3.设置大小
        button.frame = CGRectMake(buttonX, buttonY, buttonW, buttonH);
        //4.设置tag
        button.tag = i;
    }
}


@end
