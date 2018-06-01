//
//  ExamPlaceCell.h
//  TakeCommandPlatform
//
//  Created by jyd on 2018/3/26.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchInfoModel.h"
@interface ExamPlaceCell : UITableViewCell


/** model */
@property (nonatomic, strong) Room *room;


+ (instancetype)cellWithTableView:(UITableView *)tableView indentifier:(NSString *)indentifier;
@end
