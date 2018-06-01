//
//  ReceiverCell.h
//  TakeCommandPlatform
//
//  Created by jyd on 2018/1/3.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReceiverModel.h"
#import "NoticeModel.h"
typedef void(^ReceiverSelectedBlock)(BOOL select);

@interface ReceiverCell : UITableViewCell

/** 接收者 */
@property (nonatomic, strong) ReceiverModel *reciver;


/** 是否选中 */
@property (nonatomic, assign) BOOL isSelected;

/** block */
@property (nonatomic, copy) ReceiverSelectedBlock block;


/** 通知详情接收者 */
@property (nonatomic, strong) Receiver *detailsReceiver;


+ (instancetype)cellWithTableView:(UITableView*)tableView indentifier:(NSString*)indentifier;

@end
