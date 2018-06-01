//
//  ExamineeCell.m
//  TakeCommandPlatform
//
//  Created by jyd on 2018/3/26.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import "ExamineeCell.h"

@interface ExamineeCell ()
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *tickNum;
@property (weak, nonatomic) IBOutlet UILabel *idCard;
@property (weak, nonatomic) IBOutlet UIButton *videoBtn;

@end

@implementation ExamineeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _videoBtn.layer.borderColor = RGB(0, 104, 183).CGColor;
    _videoBtn.layer.borderWidth = 1.0f;
    _videoBtn.layer.masksToBounds = YES;
    _videoBtn.layer.cornerRadius = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView indentifier:(NSString *)indentifier
{
    ExamineeCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)setStudent:(Student *)student
{
    _student = student;
    _name.text = student.studentname;
    _tickNum.text = student.ticketnum;
    _idCard.text = student.idcard;
}
- (IBAction)videoBtnClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(examVideoAction)]) {
        [_delegate examVideoAction];
    }
}

@end
