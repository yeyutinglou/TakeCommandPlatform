//
//  ReceiverView.m
//  TakeCommandPlatform
//
//  Created by jyd on 2017/12/27.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import "ReceiverView.h"
#import "ReceiverModel.h"
#import "ReceiverCell.h"
@interface ReceiverView () <UITableViewDelegate, UITableViewDataSource>
{
    
    __weak IBOutlet UITableView *receiverTableView;
    __weak IBOutlet UIButton *allSelectBtn;
    
    NSArray *dataArray;
    NSMutableArray *selectedArray;
    BOOL isSelect;
    __weak IBOutlet UILabel *topLabel;
    __weak IBOutlet NSLayoutConstraint *tableViewBottom;
    __weak IBOutlet UIView *bottomView;
}
@end
@implementation ReceiverView

- (instancetype)init
{
    ReceiverView *receiver;
    if (!receiver) {
        receiver = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
        
    }
    return receiver;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [allSelectBtn setBackgroundImage:[UIImage imageWithColor:RGB(0, 97, 186)] forState:UIControlStateNormal];
    [allSelectBtn setBackgroundImage:[UIImage imageWithColor:RGB(136, 169, 219)] forState:UIControlStateSelected];
    receiverTableView.dataSource = self;
    receiverTableView.delegate = self;
    receiverTableView.rowHeight = 40;
    selectedArray = [[NSMutableArray alloc] init];
   
    
}

///接收通知的用户信息
- (void)getReciverData
{
    NSString *url = [NSString stringWithFormat:@"%@%@",kServiceAdress, REQUEST_URL_RECEIVERS];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    param[@"userid"] = kUserId;
    param[@"sessionid"] = kUserSessionid;
    [NetworkManager POST:url parameters:param success:^(id responseObject) {
        dataArray = [NSArray yy_modelArrayWithClass:[ReceiverModel class] json:responseObject];
        [receiverTableView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

- (void)setIsDetails:(BOOL)isDetails
{
    _isDetails = isDetails;
    
}

- (void)setDetailsReceiberArray:(NSArray *)detailsReceiberArray
{
    topLabel.backgroundColor = RGB(210, 210, 210);
    bottomView.hidden = YES;
    tableViewBottom.constant = -80;
    _detailsReceiberArray = detailsReceiberArray;
    dataArray = [NSArray arrayWithArray:detailsReceiberArray];
    [receiverTableView reloadData];
}

#pragma mark - UITableViewDataSource  / Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReceiverCell *cell = [ReceiverCell cellWithTableView:tableView indentifier:@"cell"];
    if (_isDetails) {
        cell.detailsReceiver = dataArray[indexPath.row];
        return cell;
    }
    cell.isSelected = isSelect;
    if ([selectedArray containsObject:[dataArray objectAtIndex:indexPath.row]]) {
        cell.isSelected = YES;
    }
    cell.block = ^(BOOL select) {
        if (select) {
            [selectedArray addObject:[dataArray objectAtIndex:indexPath.row]];
        }
        else
        {
            [selectedArray removeObject:[dataArray objectAtIndex:indexPath.row]];
        }
        if (selectedArray.count == dataArray.count) {
            allSelectBtn.selected = YES;
        } else {
            allSelectBtn.selected = NO;
        }
    };
    
    cell.reciver = dataArray[indexPath.row];

    return cell;
}


- (IBAction)allSelectBtnClick:(UIButton *)sender {
    [selectedArray removeAllObjects];
    sender.selected = !sender.selected;
    isSelect = sender.selected;
    if (isSelect) {
        [selectedArray addObjectsFromArray:dataArray];
    } else {
        [selectedArray removeAllObjects];
    }
    [receiverTableView reloadData];
}
- (IBAction)OKBtnClick:(UIButton *)sender {
    self.block(selectedArray);
}

@end
