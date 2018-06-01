//
//  NoticeViewController.m
//  TakeCommandPlatform
//
//  Created by jyd on 2017/12/18.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import "NoticeViewController.h"
#import "NoticeCell.h"
#import "NoticeDetailsViewController.h"
#import "NewNoticeViewController.h"
@interface NoticeViewController () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *controlView;
@property (weak, nonatomic) IBOutlet UITableView *noticeTableView;
@property (weak, nonatomic) IBOutlet UIView *deleteView;
@property (weak, nonatomic) IBOutlet UIButton *allSelectBtn;

/** 通知数据 */
@property (nonatomic, strong) NSMutableArray *noticeArray;

/** 是否删除 */
@property (nonatomic, assign) BOOL isDelete;

/** 选中的通知集合 */
@property (nonatomic, strong) NSMutableArray *selectedArray;

/** index */
@property (nonatomic, assign) NSInteger index;

@end

@implementation NoticeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"通知公告";
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"新建" target:self action:@selector(newNoticeBtnClick)];
    self.deleteView.hidden = YES;
    _noticeArray = [[NSMutableArray alloc] init];
    _selectedArray = [[NSMutableArray alloc] init];
    [_allSelectBtn setBackgroundImage:[UIImage imageWithColor:RGB(0, 97, 186)] forState:UIControlStateNormal];
    [_allSelectBtn setBackgroundImage:[UIImage imageWithColor:RGB(136, 169, 219)] forState:UIControlStateSelected];
    
    HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"已发通知", @"已收通知"]];
//    segmentedControl.backgroundImage = [UIImage imageNamed:@"selectingBg"];
    segmentedControl.frame = CGRectMake(0, 0, kWidth, 40);
    segmentedControl.segmentEdgeInset = UIEdgeInsetsMake(0, 10, 0, 10);
    segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
    segmentedControl.verticalDividerEnabled = YES;
    segmentedControl.verticalDividerColor = RGB(249, 249, 249);
    segmentedControl.titleTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:13],NSForegroundColorAttributeName : RGB(61, 61, 61)};
    segmentedControl.selectedTitleTextAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:13],NSForegroundColorAttributeName : RGB(0, 118, 255) };
    segmentedControl.verticalDividerWidth = 1.0f;
    [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [_controlView addSubview:segmentedControl];
    segmentedControl.selectedSegmentIndex = 0;
    [self segmentedControlChangedValue:segmentedControl];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self getNewMessageData];
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)control
{
    
    _index = control.selectedSegmentIndex;
    [self getNewMessageData];
}

///获取通知数据
- (void)getNewMessageData
{
    
    if (_noticeArray.count > 0) {
        [_noticeArray removeAllObjects];
    }

    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"userid"] = kUserId;
    params[@"type"] = [NSString stringWithFormat:@"%ld",(long)_index];
    NSString *url = [NSString stringWithFormat:@"%@%@",kServiceAdress,REQUEST_URL_SCHOOLNOTICES];
    [NetworkManager POST:url parameters:params success:^(id responseObject) {
        NSArray *arr = [NSArray yy_modelArrayWithClass:[NoticeModel class] json:responseObject];
        [_noticeArray addObjectsFromArray:arr];
        [_noticeTableView reloadData];
    } failure:^(NSError *error) {
        
    }];
//    [NetworkManager setResponseSerializer:YWResponseSerializerJSON];
    

}

#pragma mark - UITableViewDataSource  / Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _noticeArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NoticeCell *cell = [NoticeCell cellWithTableView:tableView indentifier:@"cell"];
    cell.notice = _noticeArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    UILongPressGestureRecognizer * longPressGesture =[[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(cellLongPress:)];
    
    longPressGesture.minimumPressDuration=1.5f;//设置长按 时间
    [cell addGestureRecognizer:longPressGesture];
    if (_isDelete) {
        if (_selectedArray.count == 0) {
             [cell cellSelected:YES];
        } else {
            [cell cellSelected:NO];
        }
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NoticeModel *model = _noticeArray[indexPath.row];
    if (!_isDelete) {
        NoticeDetailsViewController *deatils = [[NoticeDetailsViewController alloc] init];
        deatils.model = model;
        [self.navigationController pushViewController:deatils animated:YES];
    } else {
        NoticeCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if ([_selectedArray containsObject:model]) {
            [cell cellSelected:YES];
            [_selectedArray removeObject:model];
        } else {
            [cell cellSelected:NO];
            [_selectedArray addObject:model];
        }
        [self allBtnIsSelected];
    }
    
}

#pragma mark - newNotice
- (void)newNoticeBtnClick
{
    NewNoticeViewController *newNotice = [[NewNoticeViewController alloc] init];
    [self.navigationController pushViewController:newNotice animated:YES];
}

#pragma mark - LongPress
- (void)cellLongPress:(UILongPressGestureRecognizer *)longRecognizer{
    
    
    if (longRecognizer.state==UIGestureRecognizerStateBegan) {
        //成为第一响应者，需重写该方法
        [self becomeFirstResponder];
        [_selectedArray removeAllObjects];
        CGPoint location = [longRecognizer locationInView:_noticeTableView];
        NSIndexPath * indexPath = [_noticeTableView indexPathForRowAtPoint:location];
        self.deleteView.hidden = NO;
        _isDelete = YES;
        NoticeCell *cell = [_noticeTableView cellForRowAtIndexPath:indexPath];
        [cell cellSelected:NO];
        [_selectedArray addObject:_noticeArray[indexPath.row]];
        [self allBtnIsSelected];
    }
    
    
}
- (void)allBtnIsSelected
{
    if (_selectedArray.count == _noticeArray.count) {
        _allSelectBtn.selected = YES;
    } else {
        _allSelectBtn.selected = NO;
    }
}
- (IBAction)allSelectedBtnClick:(UIButton *)sender {
    [_selectedArray removeAllObjects];
    sender.selected = !sender.selected;
    if (sender.selected) {
        [_selectedArray addObjectsFromArray:_noticeArray];
    } else {
        [_selectedArray removeAllObjects];
    }
    [_noticeTableView reloadData];
}
- (IBAction)cancelBtnClick:(UIButton *)sender {
    [self clearDeleteState];
    [_noticeTableView reloadData];
}
- (IBAction)deleteBtnClick:(UIButton *)sender {
    [self clearDeleteState];
    [self deleteNotices];
}

///删除状态
- (void)clearDeleteState
{
    _deleteView.hidden = YES;
    _isDelete = NO;
}


///删除通知
- (void)deleteNotices
{
    if (_selectedArray.count == 0) {
        [MBProgressHUD showError:@"未选择通知"];
        return;
    }
    NSMutableString *idStr = [[NSMutableString alloc] init];
    for (NoticeModel *model in _selectedArray) {
        [idStr appendString:model.notice_id];
        if (![model isEqual:[_selectedArray lastObject]]) {
            [idStr appendString:@","];
        }
    }
    NSString *url = [NSString stringWithFormat:@"%@%@",kServiceAdress, REQUEST_URL_DELETENOTICES];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    param[@"userid"] = kUserId;
    param[@"noticeid"] = idStr;
    [NetworkManager setResponseSerializer:YWResponseSerializerHTTP];
    [NetworkManager POST:url parameters:param success:^(id responseObject) {
        [self getNewMessageData];
    } failure:^(NSError *error) {
        
    }];
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
