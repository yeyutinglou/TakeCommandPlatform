//
//  ExamLocationDetailsViewController.m
//  TakeCommandPlatform
//
//  Created by jyd on 2017/12/19.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import "ExamLocationDetailsViewController.h"
#import "ExamRoomModel.h"
#import "ExamRoomCell.h"
#import "ExamRoomVideoViewController.h"
@interface ExamLocationDetailsViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UILabel *ExamLocationName;
@property (weak, nonatomic) IBOutlet UILabel *areaName;
@property (weak, nonatomic) IBOutlet UILabel *areaNum;
@property (weak, nonatomic) IBOutlet UILabel *wsAreanUM;
@property (weak, nonatomic) IBOutlet UILabel *siteresponsible;
@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UILabel *location;


@property (weak, nonatomic) IBOutlet UITableView *roomTableView;

/** 考场信息 */
@property (nonatomic, strong) ExamRoomModel *examRoomModel;

@end

@implementation ExamLocationDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"考点详情";
    [self showDetails];
    
    [self getExamRoomList];
}

///显示考点详情
- (void)showDetails
{
    _ExamLocationName.text = _model.sitename;
    _areaName.text = [NSString stringWithFormat:@"考区名称:%@   考区代码:%@   考点编号:%@",_model.areaname, _model.areacode, _model.sitecode];
    _areaNum.text = [NSString stringWithFormat:@"考场数:%ld   考生数:%ld   考试类型:%@",_model.examroomcounts, _model.studentscounts, _model.examtype];
    _wsAreanUM.text = [NSString stringWithFormat:@"文史考场数:%ld   理工考场数:%ld   专升本考场数:%d",_model.wsroomsnum, _model.lgroomsnum, 0];
    _siteresponsible.text = [NSString stringWithFormat:@"考点负责人:%@   联系方式:%@",_model.siteresponsible, _model.siteresponphone];
    _phone.text = [NSString stringWithFormat:@"固话:%@     E-mail:%@",@"", @""];
    _location.text = _model.sitelocation;
}


///获取考场列表数据
- (void)getExamRoomList
{
    NSString *url = [NSString stringWithFormat:@"%@%@",kServiceAdress, REQUEST_URL_EXAMROOMLIST];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    param[@"userid"] = kUserId;
    param[@"sessionid"] = kUserSessionid;
    param[@"id"] = _model.examLocationId;
    [NetworkManager POST:url parameters:param success:^(id responseObject) {
        _examRoomModel = [ExamRoomModel yy_modelWithJSON:responseObject];
        [_roomTableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - UITableViewDelegate / DataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _examRoomModel.roominfo.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExamRoomCell *cell = [ExamRoomCell cellWithTableView:tableView indentifier:@"cell"];
    cell.roomInfo = _examRoomModel.roominfo[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExamRoomVideoViewController *video = [[ExamRoomVideoViewController alloc] init];
//    video.roomInfo = _examRoomModel.roominfo[indexPath.row];
    video.sitechoolname = _model.sitename;
    [self.navigationController pushViewController:video animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
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
