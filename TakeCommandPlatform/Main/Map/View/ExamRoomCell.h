//
//  ExamRoomCell.h
//  TakeCommandPlatform
//
//  Created by jyd on 2017/12/19.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExamRoomModel.h"
@interface ExamRoomCell : UITableViewCell

/** 考场信息 */
@property (nonatomic, strong) RoomInfo *roomInfo;


+ (instancetype)cellWithTableView:(UITableView*)tableView indentifier:(NSString*)indentifier;

@end
