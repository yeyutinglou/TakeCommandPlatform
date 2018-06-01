//
//  NoticeCell.h
//  TakeCommandPlatform
//
//  Created by jyd on 2017/12/18.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeModel.h"
@interface NoticeCell : UITableViewCell



/** 通知 */
@property (nonatomic, strong) NoticeModel *notice;





+ (instancetype)cellWithTableView:(UITableView*)tableView indentifier:(NSString*)indentifier;

- (void)cellSelected:(BOOL)hide;

@end
