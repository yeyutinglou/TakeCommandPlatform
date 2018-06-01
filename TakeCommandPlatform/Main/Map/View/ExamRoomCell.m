//
//  ExamRoomCell.m
//  TakeCommandPlatform
//
//  Created by jyd on 2017/12/19.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import "ExamRoomCell.h"
@interface ExamRoomCell ()
@property (weak, nonatomic) IBOutlet UILabel *examRoomName;

@end
@implementation ExamRoomCell

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
    ExamRoomCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

- (void)setRoomInfo:(RoomInfo *)roomInfo
{
    _roomInfo = roomInfo;
    _examRoomName.text = roomInfo.examname;
}

@end
