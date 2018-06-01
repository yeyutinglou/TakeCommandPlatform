//
//  NewMessageCell.m
//  TakeCommandPlatform
//
//  Created by jyd on 2017/12/14.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import "NewMessageCell.h"
@interface NewMessageCell ()
@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *creatTime;
@property (weak, nonatomic) IBOutlet UIImageView *noRead;
@property (weak, nonatomic) IBOutlet UILabel *read;

@end


@implementation NewMessageCell

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
    NewMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    return cell;
}

//- (void)setSchoolNotice:(SchoolNoticeModel *)schoolNotice
//{
//    _schoolNotice = schoolNotice;
//    _title.text = schoolNotice.title;
//    _creatTime.text = schoolNotice.createtime;
//    if (schoolNotice.state) {
//        _noRead.hidden = YES;
//        _read.text = @"已读";
//    } else {
//       _read.hidden = YES;
//    }
//}
//
//- (void)setNotice:(NoticeModel *)notice
//{
//    _notice = notice;
//    _title.text = notice.notice.title;
//    _creatTime.text = notice.notice.createtime;
//    _noRead.hidden = YES;
//    _read.text = [NSString stringWithFormat:@"已读%d",notice.notice.read];
//}

@end
