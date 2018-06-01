//
//  ServiceConfigViewController.m
//  TakeCommandPlatform
//
//  Created by jyd on 2017/12/11.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import "ServiceConfigViewController.h"

@interface ServiceConfigViewController ()
@property (weak, nonatomic) IBOutlet UITextField *serviceAddress;
@property (weak, nonatomic) IBOutlet UITextField *videophoneAddress;
@property (weak, nonatomic) IBOutlet UITextField *videoConferenceAddress;
@property (weak, nonatomic) IBOutlet UITextField *testAddress;
@property (weak, nonatomic) IBOutlet UITextField *chartsAddress;

@end

@implementation ServiceConfigViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self showAddress];
}

///显示服务地址
- (void)showAddress
{
    _serviceAddress.text = [ServiceConfigManager sharedInstance].serviceAddress;
    _videophoneAddress.text = [ServiceConfigManager sharedInstance].videophoneAddress;
    _videoConferenceAddress.text = [ServiceConfigManager sharedInstance].videoConferenceAddress;
    _testAddress.text = [ServiceConfigManager sharedInstance].testingAddress;
    _chartsAddress.text = [ServiceConfigManager sharedInstance].chartAddress;
    
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self saveAdress];
}

- (void)saveAdress
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSString verifySeverStr:_serviceAddress.text] forKey:@"serviceAddress"];
    [[NSUserDefaults standardUserDefaults] setObject:_videophoneAddress.text forKey:@"videophoneAddress"];
    [[NSUserDefaults standardUserDefaults] setObject:_videoConferenceAddress.text forKey:@"videoConferenceAddress"];
    [[NSUserDefaults standardUserDefaults] setObject:_testAddress.text forKey:@"stestAddress"];
    [[NSUserDefaults standardUserDefaults] setObject:_chartsAddress.text forKey:@"chartsAddress"];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
