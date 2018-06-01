//
//  ExamManagerCell.m
//  TakeCommandPlatform
//
//  Created by jyd on 2018/3/26.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import "ExamManagerCell.h"

@interface  ExamManagerCell ()
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *idCard;
@property (weak, nonatomic) IBOutlet UILabel *school;

@end

@implementation ExamManagerCell

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
    ExamManagerCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)setStaff:(Staff *)staff
{
    _staff = staff;
    _name.text = staff.name;
    _idCard.text = staff.idcard;
    _school.text = staff.sitename;
}

@end
