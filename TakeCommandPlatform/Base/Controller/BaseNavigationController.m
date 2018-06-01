//
//  BaseNavigationController.m
//  TakeCommandPlatform
//
//  Created by jyd on 2017/12/11.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController
+(void)initialize
{
    UINavigationBar *navBar=[UINavigationBar appearance];
//    [navBar setBackgroundImage:[UIImage imageNamed:@"tabbar_bg"] forBarMetrics:UIBarMetricsDefault];
    [navBar setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forBarMetrics:UIBarMetricsDefault];
    [navBar setTintColor:HEXCOLOR(0x0068B7)];
    [navBar setTitleTextAttributes:@{NSForegroundColorAttributeName:HEXCOLOR(0x0068B7)}];
    navBar.shadowImage=[[UIImage alloc]init];  //隐藏掉导航栏底部的那条线
    //2.设置导航栏barButton上面文字的颜色
    UIBarButtonItem *item=[UIBarButtonItem appearance];
    [item setTintColor:HEXCOLOR(0x0068B7)];
    [item setTitleTextAttributes:@{NSForegroundColorAttributeName:HEXCOLOR(0x0068B7)} forState:UIControlStateNormal];
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}


#pragma mark 当push的时候调用这个方法
-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    if(self.viewControllers.count>0){
//         viewController.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithIcon:@"back" highIcon:@"back" target:self action:@selector(back)];
        UIButton *backButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        //设置UIButton的图像
//        [backButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [backButton setTitle:@"返回" forState: UIControlStateNormal];
        [backButton setTitleColor:HEXCOLOR(0x0068B7) forState:UIControlStateNormal];
        backButton.titleLabel.font = [UIFont systemFontOfSize:15];
//        [backButton setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
        //给UIButton绑定一个方法，在这个方法中进行popViewControllerAnimated
        [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
        //然后通过系统给的自定义BarButtonItem的方法创建BarButtonItem
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
        viewController.navigationItem.leftBarButtonItem = backItem;
        
        
        viewController.hidesBottomBarWhenPushed=YES; //当push 的时候隐藏底部兰
    }
    [super pushViewController:viewController animated:animated];
    
}

- (void)back
{
    [self popViewControllerAnimated:YES];
}
//返回白色的状态栏
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
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
