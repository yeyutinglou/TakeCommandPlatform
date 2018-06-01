//
//  ExaminationRoomCell.h
//  TakeCommandPlatform
//
//  Created by jyd on 2018/4/12.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExaminationRoomModel.h"
@interface ExaminationRoomCell : UITableViewCell

/** model */
@property (nonatomic, strong) ExamRoom *examRoom;

+ (instancetype)cellWithTableView:(UITableView *)tableView indentifier:(NSString *)indentifier;
@end
