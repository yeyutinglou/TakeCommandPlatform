//
//  ExamAddressCell.h
//  TakeCommandPlatform
//
//  Created by jyd on 2018/3/26.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchInfoModel.h"
@protocol ExamAdressCellDelegate <NSObject>

/** 考点位置 */
- (void)examAddressLocationAction;

/** 考场列表 */
- (void)examPlaceListAction;

@end

@interface ExamAddressCell : UITableViewCell

/** delegate */
@property (nonatomic, weak) id <ExamAdressCellDelegate> delegate;

/** model */
@property (nonatomic, strong) Site *site;


+ (instancetype)cellWithTableView:(UITableView *)tableView indentifier:(NSString *)indentifier;
@end
