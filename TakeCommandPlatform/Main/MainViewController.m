//
//  MainViewController.m
//  TakeCommandPlatform
//
//  Created by jyd on 2018/3/19.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import "MainViewController.h"
#import "BaseSearchView.h"
#import "PageAreaView.h"
#import "WorkingArrangementCell.h"
#import "SearchViewController.h"
#import "MapViewController.h"
#import "NoticeViewController.h"
#import "WorkingArrangementViewController.h"

@interface MainViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *bgView;

/** 搜索界面 */
@property (nonatomic, strong) BaseSearchView *searchView;


@property (weak, nonatomic) IBOutlet UIView *bgAreaView;

/** 业务 */
@property (nonatomic, strong) PageAreaView *areaView;

@property (weak, nonatomic) IBOutlet UITableView *workTableView;
@property (weak, nonatomic) IBOutlet UIView *allShowAndExamView;
/** 总览 */
@property (weak, nonatomic) IBOutlet UIView *allShowView;
/** 考试 */
@property (weak, nonatomic) IBOutlet UIView *examView;
/** 考前 */
@property (weak, nonatomic) IBOutlet UILabel *beforeExam;
/** 考中 */
@property (weak, nonatomic) IBOutlet UILabel *examing;
/** 考后 */
@property (weak, nonatomic) IBOutlet UILabel *afterExam;

/** 考试界面选中 */
@property (nonatomic, assign) BOOL isExamViewSelected;

@end

@implementation MainViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
    [self loadData];
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
    
    [_bgView addSubview:self.searchView];
    [self.searchView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
    }];
    
    
    [self.bgAreaView addSubview:self.areaView];
    [self.areaView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.left.right.mas_equalTo(0);
    }];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(switchAllShowOrExamState:)];
    tap.numberOfTapsRequired = 1;
    [_allShowAndExamView addGestureRecognizer:tap];
    
    _isExamViewSelected = YES;
    
    //考试状态
    _beforeExam.textColor = HEXCOLOR(0x006887);

}

/** 加载数据 */
- (void)loadData {
    
    
}
#pragma mark - Setter & Getter
- (BaseSearchView *)searchView
{
    if (!_searchView) {
        _searchView = [BaseSearchView initializeView];
        [_searchView addTarget:self action:@selector(didSearch)];
    }
    return _searchView;
}

- (PageAreaView *)areaView
{
    if (!_areaView) {
        _areaView = [[PageAreaView alloc] init];
        [_areaView addTarget:self action:@selector(areaBtnClicked:)];
    }
    return _areaView;
}


#pragma mark - Target Mehtods
- (void)areaBtnClicked:(NSInteger)tag
{
    switch (tag) {
        case 0:
        {
            MapViewController *map = [[MapViewController alloc] init];
            [self.navigationController pushViewController:map animated:YES];
        }
            break;
        case 1:
        {
            NoticeViewController *notice = [[NoticeViewController alloc] init];
            [self.navigationController pushViewController:notice animated:YES];
        }
            break;
        case 2:
        {
            WorkingArrangementViewController *workingArrangement = [[WorkingArrangementViewController alloc] init];
            [self.navigationController pushViewController:workingArrangement animated:YES];
        }
            
        default:
            break;
    }
}


#pragma mark - Notification Method

#pragma mark - Private Method
/** 切换总览和考试状态 */
- (void)switchAllShowOrExamState:(UITapGestureRecognizer *)tap
{
    CGPoint point = [tap locationInView:_allShowAndExamView];
    if (_isExamViewSelected) {
        if (CGRectContainsPoint(_allShowView.frame, point)) {
            _allShowView.backgroundColor = RGB(237, 238, 239);
            _examView.backgroundColor = [UIColor whiteColor];
            _isExamViewSelected = NO;
        }
    } else {
        if (CGRectContainsPoint(_examView.frame, point)) {
            _examView.backgroundColor = RGB(237, 238, 239);
            _allShowView.backgroundColor = [UIColor whiteColor];
            _isExamViewSelected = YES;
        }
    }
}

/** 搜索界面 */
- (void)didSearch
{
    SearchViewController *search = [[SearchViewController alloc] init];
    search.isResult = NO;
    [self.navigationController pushViewController:search animated:YES];
}

#pragma mark - Public Method

#pragma mark - UITableView Delegate & Datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WorkingArrangementCell * cell = [WorkingArrangementCell cellWithTableView:tableView indentifier:@"cell"];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark - Other Delegate





@end
