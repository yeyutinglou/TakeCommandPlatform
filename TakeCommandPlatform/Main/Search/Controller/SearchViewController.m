//
//  SearchViewController.m
//  TakeCommandPlatform
//
//  Created by jyd on 2018/3/23.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import "SearchViewController.h"
#import "ExamAddressCell.h"
#import "ExamineeCell.h"
#import "ExamPlaceCell.h"
#import "ExamManagerCell.h"
#import "MapViewController.h"
#import "StudentDetailsViewController.h"
#import "ExamRoomVideoViewController.h"
#import "SearchInfoModel.h"
#import "ExaminationRoomListViewController.h"
@interface SearchViewController () <UITextFieldDelegate, ExamAdressCellDelegate, ExamineeCellDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
/** 类型 */
@property (weak, nonatomic) IBOutlet UIView *typeView;
/** 考点 */
@property (weak, nonatomic) IBOutlet UIView *examAddressView;
/** 考场 */
@property (weak, nonatomic) IBOutlet UIView *examPlaceView;
/** 考生 */
@property (weak, nonatomic) IBOutlet UIView *examineeView;
/** 考务人员 */
@property (weak, nonatomic) IBOutlet UIView *examManagerView;


@property (weak, nonatomic) IBOutlet UITableView *searchTableView;

/** info */
@property (nonatomic, strong) SearchInfoModel *infoModel;

/** sectionNum */
@property (nonatomic, assign) NSInteger sectionNum;

/** dataArr */
@property (nonatomic, strong) NSMutableArray *dataArr;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
   
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Initial Methods

/** 视图初始化 */
- (void)setupUI {
    
    //输入框
    UIView *rightVeiw = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    UIImageView *rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 18, 16)];
    rightImageView.centerY = rightVeiw.centerY;
    rightImageView.image = [UIImage imageNamed:@"search"];
    [rightVeiw addSubview:rightImageView];
    _textField.rightView = rightVeiw;
    _textField.rightViewMode = UITextFieldViewModeAlways;
    
    //搜索类型
    for (UIView *view in _typeView.subviews) {
        //是否选中, 边框颜色
        if ([view isEqual:_examineeView]) {
            view.layer.borderColor = HEXCOLOR(0x0078B7).CGColor;
        } else {
            view.layer.borderColor = HEXCOLOR(0xBBBBBB).CGColor;
        }
         view.layer.borderWidth = 1.0;
    }
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(selectSearchType:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [_typeView addGestureRecognizer:tap];
    
    if (_isResult) {
        _searchTableView.hidden = NO;
        _typeView.hidden = YES;
        _textField.text = self.text;
        [self loadData];
    } else {
        _searchTableView.hidden = YES;
        _typeView.hidden = NO;
        _searchType = SearchTypeExaminee;
    }
    
}

/** 加载数据 */
- (void)loadData {
    NSString *urlStr = [NSString stringWithFormat:@"%@%@", kServiceAdress, REQUEST_URL_SEARCHINFOS];
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"userid"] = kUserId;
    params[@"str"] = _text;
    [NetworkManager POST:urlStr parameters:params success:^(id responseObject) {
        self.infoModel = [SearchInfoModel yy_modelWithJSON:responseObject];
        if (self.infoModel.state) {
            [self getSectionNum];
        } else {
            [MBProgressHUD showError:self.infoModel.errorinfo];
            _searchTableView.hidden = YES;
        }
        
    } failure:^(NSError *error) {
        
    }];
    _infoModel = [SearchInfoModel yy_modelWithJSON:@{@"sites":@[@{@"sitename":@"辽中中",@"siteid":@"52BB1DC54C734E138B5DB5962DFD2888"}],@"students":@[@{@"sex":@"",@"roomname":@"1考场",@"ticketnum":@"12221721300058",@"sitename":@"辽中二中",@"examcode":@"12221721300058",@"idcard":@"12221721300058",@"studentname":@"马杰1"}],@"errorinfo":@"",@"state":@"1",@"staffs":@[@{@"sex":@"男",@"roomname":@"艾弗森",@"sitename":@"阿斯顿",@"name":@"王雪1",@"idcard":@"322"}],@"rooms":@[@{@"roomid":@"9",@"roomname":@"辽中一中2考场",@"sitename":@"辽中一中"},@{@"roomid":@"8",@"roomname":@"辽中一中1考场",@"sitename":@"辽中一中"}]}
                      ];
     [self getSectionNum];
}
#pragma mark - Setter & Getter

#pragma mark - Target Mehtods

#pragma mark - Notification Method

#pragma mark - Private Method
/** 选择搜索类型 添加边框 */
- (void)selectSearchType:(UITapGestureRecognizer *)tap
{
    CGPoint point = [tap locationInView:_typeView];
    for (UIView *view in _typeView.subviews) {
        if (CGRectContainsPoint(view.frame, point)) {
            view.layer.borderColor = HEXCOLOR(0x0078B7).CGColor;
            if ([view isEqual:_examAddressView]) {
                _searchType = SearchTypeExamAddress;
            } else if ([view isEqual:_examineeView]) {
                _searchType = SearchTypeExaminee;
            } else if ([view isEqual:_examPlaceView]) {
                _searchType = SearchTypeExamPlace;
            } else {
                _searchType = SearchTypeExamManager;
            }
        } else {
            view.layer.borderColor = HEXCOLOR(0xBBBBBB).CGColor;
        }
    }
    
    if ([NSString verifySeverStr:_textField.text ].length > 0) {
        [self searchText:_textField.text];
    }
}

/** 搜索内容 */
- (void)searchText:(NSString *)text
{
   
    switch (_searchType) {
        case SearchTypeExamAddress:
            {
            }
            break;
        case SearchTypeExaminee:
        {
        }
            break;
        case SearchTypeExamPlace:
        {
        }
            break;
        case SearchTypeExamManager:
        {
        }
            break;
            
        default:
            break;
    }
    
    
    if (_isResult) {
        self.text = text;
        [self loadData];
    } else {
        SearchViewController *search = [[SearchViewController alloc] init];
        search.isResult = YES;
        search.text = text;
        search.searchType = _searchType;
        [self.navigationController pushViewController:search animated:YES];
    }
    
}




/** 获取section的个数 */
- (void)getSectionNum
{
    _dataArr = [NSMutableArray arrayWithCapacity:4];
    [self arrCount:_infoModel.students];
    [self arrCount:_infoModel.staffs];
    [self arrCount:_infoModel.rooms];
    [self arrCount:_infoModel.sites];
    if (_dataArr.count > 0) {
        _searchTableView.hidden = NO;
        [_searchTableView reloadData];
    }
    
}

- (void)arrCount:(NSArray *)arr
{
    if (arr.count > 0) {
        [_dataArr addObject:arr];
    }
}

- (IBAction)didBack:(UIButton *)sender {
    [self.navigationController  popViewControllerAnimated:YES];
}
#pragma mark - Public Method

#pragma mark - UITableView Delegate & Datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *arr = _dataArr[section];
    return arr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    NSArray *arr = _dataArr[indexPath.section];
    id model = arr[indexPath.row];
    if ([model isKindOfClass:[Site class]]) {
        cell = [ExamAddressCell cellWithTableView:tableView indentifier:@"examAddressCell"];
        ((ExamAddressCell *)cell).delegate = self;
        ((ExamAddressCell *)cell).site = model;
    } else if ([model isKindOfClass:[Student class]]) {
        cell = [ExamineeCell cellWithTableView:tableView indentifier:@"examineeCell"];
        ((ExamineeCell *)cell).delegate = self;
        ((ExamineeCell *)cell).student = model;
    } else if ([model isKindOfClass:[Room class]]) {
        cell = [ExamPlaceCell cellWithTableView:tableView indentifier:@"examPlaceCell"];
        ((ExamPlaceCell *)cell).room = model;
    } else {
        cell = [ExamManagerCell cellWithTableView:tableView indentifier:@"examManagerCell"];
        ((ExamManagerCell *)cell).staff = model;
    }
    
//    switch (_searchType) {
//        case SearchTypeExamAddress:
//            {
//                cell = [ExamAddressCell cellWithTableView:tableView indentifier:@"examAddressCell"];
//                ((ExamAddressCell *)cell).delegate = self;
//
//            }
//            break;
//        case SearchTypeExaminee:
//        {
//            cell = [ExamineeCell cellWithTableView:tableView indentifier:@"examineeCell"];
//
//        }
//            break;
//        case SearchTypeExamPlace:
//        {
//            cell = [ExamPlaceCell cellWithTableView:tableView indentifier:@"examPlaceCell"];
//
//        }
//            break;
//        case SearchTypeExamManager:
//        {
//            cell = [ExamManagerCell cellWithTableView:tableView indentifier:@"examManagerCell"];
//
//        }
//            break;
//
//        default:
//            break;
//    }
    return cell;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(20, 0, 100, 40);
    label.textColor = RGB(0, 182, 255);
    NSArray *arr = _dataArr[section];
    id model = arr[0];
    if ([model isKindOfClass:[Site class]]) {
        label.text = @"考点";
        
    } else if ([model isKindOfClass:[Student class]]) {
        label.text = @"考生";
    } else if ([model isKindOfClass:[Room class]]) {
        label.text = @"考场";
    } else {
        label.text = @"巡考员";
    }
    return label;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
//    switch (_searchType) {
//        case SearchTypeExamAddress:
//        {
//
//        }
//            break;
//        case SearchTypeExaminee:
//        {
//            StudentDetailsViewController *details = [[StudentDetailsViewController alloc] init];
//            [self.navigationController pushViewController:details animated:YES];
//
//        }
//            break;
//        case SearchTypeExamPlace:
//        {
//            ExamRoomVideoViewController *video = [[ExamRoomVideoViewController alloc] init];
//            [self.navigationController pushViewController:video animated:YES];
//
//        }
//            break;
//        case SearchTypeExamManager:
//        {
//
//
//        }
//            break;
//
//        default:
//            break;
//    }
    
    
    NSArray *arr = _dataArr[indexPath.section];
    id model = arr[indexPath.row];
    if ([model isKindOfClass:[Site class]]) {
        
    } else if ([model isKindOfClass:[Student class]]) {
        StudentDetailsViewController *details = [[StudentDetailsViewController alloc] init];
        [self.navigationController pushViewController:details animated:YES];
    } else if ([model isKindOfClass:[Room class]]) {
        ExamRoomVideoViewController *video = [[ExamRoomVideoViewController alloc] init];
        [self.navigationController pushViewController:video animated:YES];
    } else {
        StudentDetailsViewController *details = [[StudentDetailsViewController alloc] init];
        [self.navigationController pushViewController:details animated:YES];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 123;
}

#pragma mark - UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length ==0) {
        [MBProgressHUD showError:@"请输入查询内容"];
        return NO;
    }
    [self searchText:textField.text];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark — ExamAddressCellDelegate
- (void)examAddressLocationAction
{
    MapViewController *map = [[MapViewController alloc] init];
    [self.navigationController pushViewController:map animated:YES];
}

- (void)examPlaceListAction
{
    ExaminationRoomListViewController *list = [[ExaminationRoomListViewController alloc] init];
    [self.navigationController pushViewController:list animated:YES];
}

#pragma mark — ExamineeCellDelegate
- (void)examVideoAction
{
    ExamRoomVideoViewController *video = [[ExamRoomVideoViewController alloc] init];
    [self.navigationController pushViewController:video animated:YES];
}

@end
