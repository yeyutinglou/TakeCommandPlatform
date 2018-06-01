//
//  ExamAddressCell.m
//  TakeCommandPlatform
//
//  Created by jyd on 2018/3/26.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import "ExamAddressCell.h"

@interface ExamAddressCell ()
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *code;
@property (weak, nonatomic) IBOutlet UIButton *examListBtn;

@end

@implementation ExamAddressCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _examListBtn.layer.borderColor = RGB(0, 104, 183).CGColor;
    _examListBtn.layer.borderWidth = 1.0f;
    _examListBtn.layer.masksToBounds = YES;
    _examListBtn.layer.cornerRadius = 5;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView indentifier:(NSString *)indentifier
{
    ExamAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (IBAction)locationBtnClicked:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(examAddressLocationAction)]) {
        [_delegate examAddressLocationAction];
    }
}

- (IBAction)examListBtnClicked:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(examPlaceListAction)]) {
        [_delegate examPlaceListAction];
    }
}

- (void)setSite:(Site *)site
{
    _site = site;
    _name.text = site.sitename;
    _code.text = site.siteid;
}
@end
