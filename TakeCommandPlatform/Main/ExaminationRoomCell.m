//
//  ExaminationRoomCell.m
//  TakeCommandPlatform
//
//  Created by jyd on 2018/4/12.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import "ExaminationRoomCell.h"

@interface ExaminationRoomCell ()
@property (weak, nonatomic) IBOutlet UILabel *name;

@end

@implementation ExaminationRoomCell

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
    ExaminationRoomCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)setExamRoom:(ExamRoom *)examRoom
{
    _examRoom = examRoom;
    _name.text = examRoom.roomname;
}

@end
