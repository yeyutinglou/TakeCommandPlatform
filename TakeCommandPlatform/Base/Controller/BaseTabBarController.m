//
//  BaseTabBarController.m
//  TakeCommandPlatform
//
//  Created by jyd on 2017/12/11.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import "BaseTabBarController.h"

#import "BaseNavigationController.h"
#import "HomeViewController.h"
#import "MessageListViewController.h"
#import "UserViewController.h"
#import "MainViewController.h"
#import "ContactViewController.h"
@interface BaseTabBarController () <CustomTabBarDelegete>

@property (nonatomic,weak) CustomTabBar *customTabBar;

@end

@implementation BaseTabBarController


-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    [self removeTabBarButton];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    [self removeTabBarButton];
    
}

-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];

    [self removeTabBarButton];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupTabBar];
    [self setupAllChildViewControllers];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeTabBarButton)
                                                 name:@"tabbarItemChange" object:nil];
}


/**
 *初始化TabBar
 */
-(void)setupTabBar
{
    //第一种方法
    CustomTabBar *customTabBar = [[CustomTabBar alloc]init];
    customTabBar.frame = self.tabBar.bounds;
    //设置代理
    customTabBar.delegete = self;
    [self.tabBar addSubview:customTabBar];
    [self.tabBar bringSubviewToFront:customTabBar];
    self.customTabBar = customTabBar;
}

/**
 *  初始化所有子控制器
 */
-(void)setupAllChildViewControllers
{
    
    MainViewController *home = [[MainViewController alloc] init];
    [self setupChildViewController:home VCtitle:@"" imageName:@"home" selectedImageName:@"home_on" title:@""];

    
    MessageListViewController *chat = [[MessageListViewController alloc] init];
    [self setupChildViewController:chat VCtitle:@"消息" imageName:@"chat" selectedImageName:@"chat_on" title:@""];
//    if (@available(iOS 10.0, *)) {
//        chat.tabBarItem.badgeColor = (__bridge UIColor * _Nullable)([UIColor redColor].CGColor);
//    } else {
//        // Fallback on earlier versions
//    }
//    chat.tabBarItem.badgeValue = @"99";
    ContactViewController *contact = [[ContactViewController alloc] init];
    [self setupChildViewController:contact VCtitle:@"通讯录" imageName:@"contact" selectedImageName:@"contact_on" title:@""];
    

    
    UserViewController *user = [[UserViewController alloc]init];
    [self setupChildViewController:user VCtitle:@"我的" imageName:@"mine" selectedImageName:@"mine_on" title:@""];

}


/**
 *  添加子控制器
 *
 *  @param childVc           子控制器名称
 *  @param title             title
 *  @param imageName         图片名称
 *  @param selectedImageName 选中时候图片名称
 */
-(void)setupChildViewController:(UIViewController *) childVc VCtitle:(NSString *) VCtitle imageName:(NSString *) imageName selectedImageName:(NSString *) selectedImageName title:(NSString *)title
{
    //1.设置控制器属性
    childVc.title = VCtitle;
    //2.设置图片
    childVc.tabBarItem.image = [UIImage imageNamed:imageName];
    //3.设置选中后图片
    childVc.tabBarItem.selectedImage = [UIImage imageNamed:selectedImageName];
    childVc.tabBarItem.title = title;
    //4.添加导航控制器
    BaseNavigationController *navi = [[BaseNavigationController alloc]initWithRootViewController:childVc];
    [self addChildViewController:navi];
    //5.添加自定义TabBar按钮、设置按钮属性
    [self.customTabBar addTabBarButtonWithItem:childVc.tabBarItem];
    
}

-(void)tabBar:(CustomTabBar *)tabBar didSelectedButtonFrom:(NSInteger)from to:(NSInteger)to
{
    //切换导航控制器
    self.selectedIndex = to;
    
    
    
}

/** 删除系统自动生成的UITabBarButton */
- (void)removeTabBarButton {
    // 删除系统自动生成的UITabBarButton
    for (UIView *child in self.tabBar.subviews) {
        if (![child isKindOfClass:[CustomTabBar class]]) {
//            child.hidden = YES;
//            child.userInteractionEnabled = NO;
            [child removeFromSuperview];
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
