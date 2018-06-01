//
//  UserViewController.m
//  TakeCommandPlatform
//
//  Created by jyd on 2017/12/12.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import "UserViewController.h"
#import "LoginViewController.h"
#import "AppDelegate.h"
#import "BaseSearchView.h"
#import "SearchViewController.h"
@interface UserViewController ()

/** 搜索界面 */
@property (nonatomic, strong) BaseSearchView *search;

@property (weak, nonatomic) IBOutlet UIView *searchView;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *level;
@property (weak, nonatomic) IBOutlet UITableView *userTableView;

/** dataArr */
@property (nonatomic, strong) NSArray *dataArr;

@end

@implementation UserViewController

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
    self.title = @"个人信息";
    
    [self.searchView addSubview:self.search];
    [self.search mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    
    _name.text = [NSString stringWithFormat:@"%@",kUser.username];
    
    NSString *levelStr;
    switch (kUserLevel) {
        case UserLevelCountry:
            levelStr = @"国家级";
            break;
        case UserLevelProvince:
            levelStr = @"省级";
            break;
        case UserLevelCity:
            levelStr = @"市级";
            break;
        case UserLevelCounty:
            levelStr = @"县级";
            break;
        case UserLevelExamSite:
            levelStr = @"校级";
            break;
        case UserLevelExaminer:
            levelStr = @"巡考员";
            break;
            
        default:
            break;
    }
    _level.text = [NSString stringWithFormat:@"%@",levelStr];
    
    _dataArr = @[@"关注考场", @"考试任务", @"个人资料", @"意见反馈", @"版本信息"];
    
}

#pragma mark — UITableView Delegate & DataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = _dataArr[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:@"pin"];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}


- (IBAction)logoutBtnClick:(UIButton *)sender {
    
    [[LoginManager sharedInstance] clearLoginState];
    LoginViewController *login = [[LoginViewController alloc] init];
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    app.window.rootViewController = login;
    
}


/** 搜索界面 */
- (void)didSearch
{
    SearchViewController *search = [[SearchViewController alloc] init];
    search.isResult = NO;
    [self.navigationController pushViewController:search animated:YES];
}


#pragma mark - Setter & Getter
- (BaseSearchView *)search
{
    if (!_search) {
        _search = [BaseSearchView initializeView];
        [_search addTarget:self action:@selector(didSearch)];
    }
    return _search;
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
