//
//  StudentSearchViewController.m
//  TakeCommandPlatform
//
//  Created by jyd on 2017/12/25.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import "StudentSearchViewController.h"
#import "SelectGroupView.h"
#import "StudentSearchModel.h"
#import "StudentSearchCell.h"
#import "StudentDetailsViewController.h"
#import "ExamRoomVideoViewController.h"
@interface StudentSearchViewController ()  <UITextFieldDelegate, SelectGropViewDelegate, UITableViewDataSource, UITableViewDelegate, StudentSearchDelegate>
@property (weak, nonatomic) IBOutlet UIView *typeBg;
@property (weak, nonatomic) IBOutlet UITextField *type;
@property (weak, nonatomic) IBOutlet UITextField *content;
/** 类型选择 */
@property (nonatomic, strong) SelectGroupView *groupView;

/** 类型 */
@property (nonatomic, assign) NSInteger deviceType;

@property (weak, nonatomic) IBOutlet UITableView *searchTableView;

/** 学生数据 */
@property (nonatomic, strong) NSArray *studentArray;

@end

@implementation StudentSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"考生查询";
    
    [self setupSearchView];
    _searchTableView.hidden = YES;
}

- (void)setupSearchView
{
    _content.layer.borderWidth = 1.0;
    _content.layer.borderColor = RGB(161, 161, 161).CGColor;
    
    _typeBg.layer.borderWidth = 1.0;
    _typeBg.layer.borderColor = RGB(161, 161, 161).CGColor;
    
    self.groupView = [[SelectGroupView alloc] init];
    
    [self.view insertSubview:self.groupView aboveSubview:[[self.view subviews] lastObject]];
    self.groupView.hidden = YES;
    self.groupView.delegate = self;
    self.groupView.groupArray =  [NSMutableArray arrayWithObjects:@"姓名", @"准考证号", @"身份证号", @"考生号", nil];
    [self.groupView.groupTableView reloadData];
    [self.groupView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.bottom.equalTo(self.view);
    }];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    if (_type == textField) {
        self.groupView.hidden = NO;
        return NO;
    }
    return YES;
}


#pragma mark - SeletGroupView
- (void)clickOKBtn:(NSInteger)index
{
    _type.text = self.groupView.groupArray[index];
    self.deviceType = index;
    self.groupView.hidden = YES;
}

- (IBAction)searchBtnClick:(UIButton *)sender {
    if ([_type.text length] == 0) {
        [MBProgressHUD showSuccess:@"请选择考生类型"];
        return;
    }
    if ([_content.text length] == 0) {
        [MBProgressHUD showSuccess:@"请输入考生信息"];
        return;
    }
    [self.view endEditing:YES];
    [self searchStudent];
    
}


- (void)searchStudent
{
    NSString *url = [NSString stringWithFormat:@"%@%@",kServiceAdress, REQUEST_URL_STUDENTSEARCH];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    param[@"userid"] = kUserId;
    param[@"sessionid"] = kUserSessionid;
    param[@"messageInfo"] = _content.text;
    param[@"typeInfo"] = [NSString stringWithFormat:@"%ld",(long)self.deviceType];
    [NetworkManager POST:url parameters:param success:^(id responseObject) {
        _searchTableView.hidden = NO;
        _studentArray = [NSArray yy_modelArrayWithClass:[StudentSearchModel class] json:responseObject];
        [_searchTableView reloadData];
    } failure:^(NSError *error) {
        [MBProgressHUD showError:@"查询失败"];
    }];
}

#pragma mark - UITableViewDelegate / DataSource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _studentArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    StudentSearchCell *cell = [StudentSearchCell cellWithTableView:tableView indentifier:@"cell"];
    cell.studentModel = _studentArray[indexPath.row];
    cell.delegate = self;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 134;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    StudentDetailsViewController * details = [[StudentDetailsViewController alloc] init];
    details.studentModel = _studentArray[indexPath.row];
    [self.navigationController pushViewController:details animated:YES];
}

#pragma mark - StudentSearchDelegate
- (void)jumpExamRoomVideoVC:(StudentSearchModel *)studentModel
{
    ExamRoomVideoViewController *video = [[ExamRoomVideoViewController alloc] init];
    video.studentSearchModel = studentModel;
    video.isSearch = YES;
    [self.navigationController pushViewController:video animated:YES];
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
