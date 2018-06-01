//
//  StudentSearchCell.m
//  TakeCommandPlatform
//
//  Created by jyd on 2017/12/25.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import "StudentSearchCell.h"
@interface StudentSearchCell ()
{
    __weak IBOutlet UIImageView *avatar;
    __weak IBOutlet UILabel *name;
    
    __weak IBOutlet UILabel *examRoomNum;
    __weak IBOutlet UILabel *examRegisterNum;
    __weak IBOutlet UILabel *IDNum;
    __weak IBOutlet UILabel *sex;
}
@end
@implementation StudentSearchCell

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
    StudentSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

//- (void)setStudentModel:(StudentSearchModel *)studentModel
//{
//    _studentModel = studentModel;
//    if ([studentModel.sex isEqualToString:@"男"]) {
//        avatar.image = [UIImage imageNamed:@"man"];
//    } else {
//        avatar.image = [UIImage imageNamed:@"woman"];
//    }
//    name.text = [NSString stringWithFormat:@"姓名: %@", studentModel.studentname];
//    examRoomNum.text = [NSString stringWithFormat:@"考场号: %@", studentModel.roomname];
//    examRegisterNum.text = [NSString stringWithFormat:@"准考证: %@", studentModel.ticketnum];
//    IDNum.text = [NSString stringWithFormat:@"身份证: %@", studentModel.id_card];
//    sex.text = [NSString stringWithFormat:@"性别: %@", studentModel.sex];
//
//}


- (IBAction)videoBtnClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(jumpExamRoomVideoVC:)]) {
        [_delegate jumpExamRoomVideoVC:_studentModel];
    }
}
@end
