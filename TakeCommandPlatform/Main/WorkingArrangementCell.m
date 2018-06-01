//
//  WorkingArrangementCell.m
//  TakeCommandPlatform
//
//  Created by jyd on 2018/3/22.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import "WorkingArrangementCell.h"

@implementation WorkingArrangementCell

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
    WorkingArrangementCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

@end
