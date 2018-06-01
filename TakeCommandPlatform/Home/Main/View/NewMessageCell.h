//
//  NewMessageCell.h
//  TakeCommandPlatform
//
//  Created by jyd on 2017/12/14.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoticeModel.h"
@interface NewMessageCell : UITableViewCell

/** 市级通知 */
@property (nonatomic, strong) NoticeModel *notice;




+ (instancetype)cellWithTableView:(UITableView*)tableView indentifier:(NSString*)indentifier;

@end
