//
//  ExaminationRoomListViewController.m
//  TakeCommandPlatform
//
//  Created by jyd on 2018/3/28.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import "ExaminationRoomListViewController.h"
#import "ExamRoomVideoViewController.h"
#import "ExaminationRoomModel.h"
#import "ExaminationRoomCell.h"
@interface ExaminationRoomListViewController ()

/** 考场 */
@property (nonatomic, strong) ExaminationRoomModel *model;
@property (weak, nonatomic) IBOutlet UITableView *examRoomTableView;


@end

@implementation ExaminationRoomListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"考场列表";
    [self setupUI];
    [self loadData];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Initial Methods

/** 视图初始化 */
- (void)setupUI {
    
    
}

/** 加载数据 */
- (void)loadData {
    
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", kServiceAdress, REQUEST_URL_FindRoomInfo];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
//    params[@"userid"] = kUserId;
    params[@"siteid "] = _site.siteid;
    [NetworkManager POST:urlStr parameters:params success:^(id responseObject) {
//        _model = [ExaminationRoomModel yy_modelWithJSON:responseObject];
//
//        [_examRoomTableView reloadData];
        
    } failure:^(NSError *error) {
        
    }];
    
    _model = [ExaminationRoomModel yy_modelWithJSON:@{@"examsite_info":@{@"student_num":@33,@"principal":@"孙",@"examroom_num":@2,@"contact_phone":@"333333",@"examarea_name":@"辽中一中",@"contact_address":@"辽宁省辽中县3街道",@"code":@"1001"},@"examroom":@[@{@"roomid":@"8",@"roomname":@"辽中一中1考场"},@{@"roomid":@"9",@"roomname":@"辽中一中2考场"}]}
              ];
    [_examRoomTableView reloadData];
}
#pragma mark - Setter & Getter

#pragma mark - Target Mehtods

#pragma mark - Notification Method

#pragma mark - Private Method

#pragma mark - Public Method

#pragma mark - UITableView Delegate & Datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _model.examroom.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ExaminationRoomCell * cell = [ExaminationRoomCell cellWithTableView:tableView indentifier:@"examinationRoomCell"];
    ExamRoom *room = _model.examroom[indexPath.row];
    cell.examRoom = room;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ExamRoomVideoViewController *video = [[ExamRoomVideoViewController alloc] init];
    ExamRoom *room = _model.examroom[indexPath.row];
    video.examRoom = room;
    [self.navigationController pushViewController:video animated:YES];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 0, kWidth, 40);
    label.textColor = RGB(0, 104, 183);
    label.textAlignment = NSTextAlignmentCenter;
    label.text = _model.examsite_info.examarea_name;
    return label;
}



#pragma mark - Other Delegate


@end
