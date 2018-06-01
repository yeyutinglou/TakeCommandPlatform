//
//  NoticeCell.m
//  TakeCommandPlatform
//
//  Created by jyd on 2017/12/18.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import "NoticeCell.h"

@interface NoticeCell ()
@property (weak, nonatomic) IBOutlet UIImageView *noticeImageView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *creatTime;
@property (weak, nonatomic) IBOutlet UILabel *sender;
@property (weak, nonatomic) IBOutlet UILabel *sendNum;
@property (weak, nonatomic) IBOutlet UILabel *readNum;
@property (weak, nonatomic) IBOutlet UIImageView *selectedImage;

@end

@implementation NoticeCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _selectedImage.hidden = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


+ (instancetype)cellWithTableView:(UITableView *)tableView indentifier:(NSString *)indentifier
{
    NoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}



- (void)setNotice:(NoticeModel *)notice
{
    _notice = notice;
    _title.text = notice.title;
    _creatTime.text = notice.send_time;
    _sender.hidden = YES;
    _sendNum.hidden = NO;
    _readNum.hidden = NO;
    _sendNum.text = [NSString stringWithFormat:@"已发送:%d", notice.reader_count];
    _readNum.text = [NSString stringWithFormat:@"已阅读:%d", notice.readernum];
}


- (void)cellSelected:(BOOL)hide
{
    self.selectedImage.hidden = hide;
}

@end
