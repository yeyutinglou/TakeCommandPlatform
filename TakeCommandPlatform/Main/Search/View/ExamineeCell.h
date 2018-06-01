//
//  ExamineeCell.h
//  TakeCommandPlatform
//
//  Created by jyd on 2018/3/26.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchInfoModel.h"

@protocol ExamineeCellDelegate <NSObject>

- (void)examVideoAction;

@end


@interface ExamineeCell : UITableViewCell

/** delegate */
@property (nonatomic, weak) id <ExamineeCellDelegate> delegate;

/** model */
@property (nonatomic, strong) Student *student;


+ (instancetype)cellWithTableView:(UITableView *)tableView indentifier:(NSString *)indentifier;

@end
