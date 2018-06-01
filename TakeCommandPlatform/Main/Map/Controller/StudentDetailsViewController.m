//
//  StudentDetailsViewController.m
//  TakeCommandPlatform
//
//  Created by jyd on 2017/12/22.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import "StudentDetailsViewController.h"
#import "StudentModel.h"
#import "ExamRoomVideoViewController.h"
#import "StaffModel.h"
@interface StudentDetailsViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *sex;
@property (weak, nonatomic) IBOutlet UILabel *birDay;
@property (weak, nonatomic) IBOutlet UILabel *native;
@property (weak, nonatomic) IBOutlet UILabel *school;

//>>>>>>>>>考试信息
@property (weak, nonatomic) IBOutlet UIView *studentExamInfoView;
@property (weak, nonatomic) IBOutlet UILabel *examLocation;
@property (weak, nonatomic) IBOutlet UILabel *registerNum;
@property (weak, nonatomic) IBOutlet UILabel *examRoomNum;
@property (weak, nonatomic) IBOutlet UILabel *seatNum;
@property (weak, nonatomic) IBOutlet UILabel *examRegisterNum;
@property (weak, nonatomic) IBOutlet UILabel *stream;
@property (weak, nonatomic) IBOutlet UILabel *IDNum;

//>>>>>>>>s身份信息
@property (weak, nonatomic) IBOutlet UIView *studentIdentityInfoView;

@property (weak, nonatomic) IBOutlet UILabel *registerCompany;
@property (weak, nonatomic) IBOutlet UILabel *speciality;
@property (weak, nonatomic) IBOutlet UILabel *politicalStatus;
@property (weak, nonatomic) IBOutlet UILabel *award;
@property (weak, nonatomic) IBOutlet UILabel *homeAddress;
@property (weak, nonatomic) IBOutlet UILabel *phone;

@property (weak, nonatomic) IBOutlet UIButton *examVideoBtn;

//>>>>>>>考务人员信息
@property (weak, nonatomic) IBOutlet UIView *staffExamInfoView;
@property (weak, nonatomic) IBOutlet UILabel *positionLabel;
@property (weak, nonatomic) IBOutlet UILabel *taskSchoolLabel;


@end

@implementation StudentDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    if (self.student) {
          self.title = @"考生详情";
        [self loadStudentData];
    }
    if (self.studentModel) {
          self.title = @"考生详情";
        [self showStudentInfoWithModel:_studentModel];
    }
    if (self.staff) {
        self.title = @"考务人员详情";
        [self loadStaffData];
    }
  
    
    _examVideoBtn.layer.borderColor = RGB(0, 118, 255).CGColor;
    _examVideoBtn.layer.borderWidth = 1.0f;
    _examVideoBtn.layer.masksToBounds = YES;
    _examVideoBtn.layer.cornerRadius = 5;
}

#pragma mark — Student
/** 加载学生数据 */
- (void)loadStudentData
{
    NSString *url = [NSString stringWithFormat:@"%@%@",kServiceAdress,REQUEST_URL_FindStudentDetails];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"userid"] = kUserId;
    params[@"info"] = _student.idcard;
    [NetworkManager POST:url parameters:params success:^(id responseObject) {
        StudentModel *model = [StudentModel yy_modelWithJSON:responseObject];
        [self showStudentInfoWithModel:model];
    } failure:^(NSError *error) {
        
    }];
}
///显示考生信息
- (void)showStudentInfoWithModel:(StudentModel *)model
{
    if ([_studentModel.sex isEqualToString:@"男"]) {
        _avatar.image = [UIImage imageNamed:@"man"];
    } else {
        _avatar.image = [UIImage imageNamed:@"woman"];
    }
    _name.text = [NSString stringWithFormat:@"姓名:%@",model.s_name];
     _sex.text = [NSString stringWithFormat:@"性别:%@",model.sex];
    _birDay.text = [NSString stringWithFormat:@"出生:%@", [NSString verifySeverStr:model.birthday]];
   
     _native.text = [NSString stringWithFormat:@"名族:%@",_studentModel.nation];
     _school.text = [NSString stringWithFormat:@"学校:%@",model.draduate_site];
    
    //考试信息
    _examLocation.text = [NSString stringWithFormat:@"考点信息:%@",model.sitename];
    _registerNum.text = [NSString stringWithFormat:@"报名号:%@",model.exam_code];
    _examRoomNum.text = [NSString stringWithFormat:@"考场号:%@",model.roomname];
    _seatNum.text = [NSString stringWithFormat:@"座位号:%@",model.seatnum];
    _examRegisterNum.text = [NSString stringWithFormat:@"准考证号:%@",model.exam_code];
    _stream.text = [NSString stringWithFormat:@"科类:%@",model.subject];
    _IDNum.text = [NSString stringWithFormat:@"身份证号:%@",model.id_card];
    
    
    ///身份信息
    _registerCompany.text = [NSString stringWithFormat:@"报名单位:%@",@""];
    _speciality.text = [NSString stringWithFormat:@"考生特长:%@",[NSString verifySeverStr:_studentModel.student_sp]];
    _politicalStatus.text = [NSString stringWithFormat:@"政治面貌:%@",_studentModel.status];
    _award.text = [NSString stringWithFormat:@"考生获得奖项:%@",[NSString verifySeverStr:model.student_prize]];
    _homeAddress.text = [NSString stringWithFormat:@"家庭住址:%@",[NSString verifySeverStr:model.account_address]];
    _phone.text = [NSString stringWithFormat:@"联系电话:%@",[NSString verifySeverStr:model.phone]];
    
    _staffExamInfoView.hidden = YES;
}
- (IBAction)examVideoBtnClick:(UIButton *)sender {
    ExamRoomVideoViewController *video = [[ExamRoomVideoViewController alloc] init];
    [self.navigationController pushViewController:video animated:YES];
}

#pragma mark — Staff
/** 获取巡考员信息 */
- (void)loadStaffData
{
    NSString *url = [NSString stringWithFormat:@"%@%@",kServiceAdress,REQUEST_URL_FindStaffDetails];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    params[@"userid"] = kUserId;
    params[@"idcard"] = _staff.idcard;
    [NetworkManager POST:url parameters:params success:^(id responseObject) {
        StaffModel *model = [StaffModel yy_modelWithJSON:responseObject];
        [self showStaffInfoWithModel:model];
    } failure:^(NSError *error) {
        
    }];
}

- (void)showStaffInfoWithModel:(StaffModel *)model
{
    if ([model.sex isEqualToString:@"男"]) {
        _avatar.image = [UIImage imageNamed:@"man"];
    } else {
        _avatar.image = [UIImage imageNamed:@"woman"];
    }
    _name.text = [NSString stringWithFormat:@"姓名:%@",model.name];
    _sex.text = [NSString stringWithFormat:@"性别:%@",model.sex];
    _birDay.text = [NSString stringWithFormat:@"出生:%@", @""];
    
    _native.text = [NSString stringWithFormat:@"名族:%@",@""];
    _school.text = [NSString stringWithFormat:@"学校:%@",model.roomname];
    
    
    
    _positionLabel.text = [NSString stringWithFormat:@"职务:%@",@"巡考员"];
    _school.text = [NSString stringWithFormat:@"任务学校:%@",model.roomname];
    
    _studentExamInfoView.hidden = YES;
    _studentIdentityInfoView.hidden = YES;
    
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
