//
//  ExamPlaceCell.m
//  TakeCommandPlatform
//
//  Created by jyd on 2018/3/26.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import "ExamPlaceCell.h"

@interface ExamPlaceCell ()
@property (weak, nonatomic) IBOutlet UILabel *siteName;
@property (weak, nonatomic) IBOutlet UILabel *roomName;

@end

@implementation ExamPlaceCell

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
    ExamPlaceCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)setRoom:(Room *)room
{
    _room = room;
    _siteName.text = room.sitename;
    _roomName.text = room.roomname;
}

@end
