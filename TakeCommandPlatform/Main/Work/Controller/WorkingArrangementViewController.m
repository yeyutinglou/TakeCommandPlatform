//
//  WorkingArrangementViewController.m
//  TakeCommandPlatform
//
//  Created by jyd on 2018/4/10.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import "WorkingArrangementViewController.h"

@interface WorkingArrangementViewController ()<FSCalendarDelegate, FSCalendarDataSource>
@property (weak, nonatomic) IBOutlet UIView *calendarView;
@property (weak, nonatomic) IBOutlet UITableView *arrangementTableView;

@end

@implementation WorkingArrangementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"工作安排";
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
- (void)setupUI
{
    
    FSCalendar *calendar = [[FSCalendar alloc] initWithFrame:_calendarView.bounds];
    calendar.dataSource = self;
    calendar.delegate = self;
    [_calendarView addSubview:calendar];
   
}

/** 加载数据 */
- (void)loadData
{
    
    
}
#pragma mark - Setter & Getter

#pragma mark - Target Mehtods

#pragma mark - Notification Method

#pragma mark - Private Method

- (IBAction)newTaskBtnClick:(UIButton *)sender {
}
#pragma mark - Public Method

#pragma mark - UITableView Delegate & Datasource

#pragma mark — FSCalendar Delegate & DataSource


#pragma mark - Other Delegate
@end
