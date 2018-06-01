//
//  SelectGroupView.m
//  student_iphone
//
//  Created by jyd on 2017/11/7.
//  Copyright © 2017年 he chao. All rights reserved.
//

#import "SelectGroupView.h"
//#import "ControlInfoModel.h"

@interface SelectGroupView () <UITableViewDelegate, UITableViewDataSource>

@end

@implementation SelectGroupView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];;
        
        [self addTableView];
    
    }
    return self;
}

- (void)addTableView
{
    UITableView *tableView = [[UITableView alloc] init];
    tableView.layer.borderWidth = 0.5;
    tableView.layer.cornerRadius = 8;
    tableView.dataSource = self;
    tableView.delegate = self;
    [self addSubview:tableView];
    self.groupTableView = tableView;
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(80);
        make.top.mas_equalTo(45);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(120);
    }];
    
    
}

#pragma mark - UITableViewDelegate / DataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.groupArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *ID = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
//    ControlInfoModel *model = self.groupArray[indexPath.row];
    cell.textLabel.text = self.groupArray[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//     ControlInfoModel *model = self.groupArray[indexPath.row];
    if (_delegate && [_delegate respondsToSelector:@selector(clickOKBtn:)]) {
        [_delegate clickOKBtn:indexPath.row];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 30;
}

@end
