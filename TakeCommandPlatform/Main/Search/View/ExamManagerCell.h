//
//  ExamManagerCell.h
//  TakeCommandPlatform
//
//  Created by jyd on 2018/3/26.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchInfoModel.h"

@interface ExamManagerCell : UITableViewCell

/** 巡考员 */
@property (nonatomic, strong) Staff *staff;


+ (instancetype)cellWithTableView:(UITableView *)tableView indentifier:(NSString *)indentifier;
@end
