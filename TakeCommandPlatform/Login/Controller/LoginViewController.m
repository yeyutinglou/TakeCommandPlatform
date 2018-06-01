//
//  LoginViewController.m
//  TakeCommandPlatform
//
//  Created by jyd on 2017/12/11.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import "LoginViewController.h"
#import "ServiceConfigViewController.h"
#import "LoginManager.h"
#import "AppDelegate.h"
#import "BaseTabBarController.h"

@interface LoginViewController ()
@property (weak, nonatomic) IBOutlet UITextField *account;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIButton *remPassword;
@property (weak, nonatomic) IBOutlet UIButton *autoLogin;

/** 是否记住密码 */
@property (nonatomic, assign) BOOL isPassword;

/** 是否自动登录 */
@property (nonatomic, assign) BOOL isLogin;

/** IP */
@property (nonatomic,copy) NSString *IP;


@end

@implementation LoginViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self getLoginConfig];
    [self getIP];
}


///登录配置
- (void)getLoginConfig
{
    _account.text = [LoginManager sharedInstance].account;
    _password.text = [LoginManager sharedInstance].password;
    _isPassword = [LoginManager sharedInstance].isPassword;
    _isLogin = [LoginManager sharedInstance].isLogin;
    if (!_isPassword) {
        _password.text = nil;
    }
    _remPassword.selected = _isPassword;
    _autoLogin.selected = _isLogin;
}

///获取ip
- (void)getIP
{
    [IPDetector getLANIPAddressWithCompletion:^(NSString *IPAddress) {
        _IP = IPAddress;
    }];
}

//服务器配置
- (IBAction)serviceConfigBtnClick:(UIButton *)sender {
    ServiceConfigViewController *config = [[ServiceConfigViewController alloc] init];
    [self.navigationController pushViewController:config animated:YES];
}

//记住密码
- (IBAction)isPasswordBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    _isPassword = !_isPassword;
    [[NSUserDefaults standardUserDefaults] setBool:_isPassword forKey:@"isPassword"];
}

//自动登录
- (IBAction)isLoginBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    _isLogin = !_isLogin;
    [[NSUserDefaults standardUserDefaults] setBool:_isLogin forKey:@"isLogin"];
}




//登录
- (IBAction)loginBtnClick:(UIButton *)sender {
    [self.view endEditing:YES];
    [MBProgressHUD showMessage:@"正在登录"];
    [[NSUserDefaults standardUserDefaults] setObject:_account.text forKey:@"account"];
    [[NSUserDefaults standardUserDefaults] setObject:_password.text forKey:@"password"];
    NSString *url = [NSString stringWithFormat:@"%@%@",kServiceAdress,REQUEST_URL_LOGIN];
    
    NSMutableDictionary *param = [NSMutableDictionary new];
    param[@"user"] = _account.text;
    param[@"password"] = [_password.text md532BitLower];
    param[@"ipadress"] = _IP;
    [NetworkManager POST:url parameters:param success:^(id responseObject) {
        [MBProgressHUD hideHUD];
        NSMutableDictionary *newResult = [NSMutableDictionary dictionary];
        [responseObject enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([obj isEqual:[NSNull null]]) {
                [newResult setObject:@"" forKey:key];
            }else {
                [newResult setObject:obj forKey:key];
            }
        }];
       [[NSUserDefaults standardUserDefaults] setObject:newResult forKey:kUserKey];
        if ([LoginManager sharedInstance].user.loginState == LoginStateSuccess) {
            
            BaseTabBarController *tab = [[BaseTabBarController alloc] init];
            AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
            app.window.rootViewController = tab;
            [app.window makeKeyAndVisible];
//             [UIApplication sharedApplication].keyWindow.rootViewController = tab;
        } else {
            [MBProgressHUD showError:[LoginManager sharedInstance].user.errorinfo];
        }
        
    } failure:^(NSError *error) {
         [MBProgressHUD hideHUD];
        [MBProgressHUD showError:@"登录失败"];
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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
