//
//  ReceiverCell.m
//  TakeCommandPlatform
//
//  Created by jyd on 2018/1/3.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import "ReceiverCell.h"
@interface ReceiverCell ()
{
    __weak IBOutlet UILabel *name;
    __weak IBOutlet UIButton *selctBtn;
    __weak IBOutlet UILabel *readState;
    
}
@end
@implementation ReceiverCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView indentifier:(NSString *)indentifier
{
    ReceiverCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return cell;
}

- (void)setReciver:(ReceiverModel *)reciver
{
    _reciver = reciver;
    name.text = reciver.username;
    selctBtn.selected = self.isSelected;
    readState.hidden = YES;
}

- (IBAction)selectBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    self.block(sender.selected);
}


- (void)setDetailsReceiver:(Receiver *)detailsReceiver
{
    _detailsReceiver = detailsReceiver;
    name.text = detailsReceiver.username;
    if (detailsReceiver.state) {
        readState.text = @"已读";
        readState.textColor = RGB(0, 153, 88);
    } else {
        readState.text = @"未读";
        readState.textColor = RGB(51, 51, 51);
    }
    selctBtn.hidden = YES;
    
}

@end
