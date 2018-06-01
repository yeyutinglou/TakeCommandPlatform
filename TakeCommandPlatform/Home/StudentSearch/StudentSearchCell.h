//
//  StudentSearchCell.h
//  TakeCommandPlatform
//
//  Created by jyd on 2017/12/25.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudentSearchModel.h"
@protocol StudentSearchDelegate <NSObject>

- (void)jumpExamRoomVideoVC:(StudentSearchModel *)studentModel;

@end

@interface StudentSearchCell : UITableViewCell

/** 考生信息 */
@property (nonatomic, strong) StudentSearchModel *studentModel;

/** delegate */
@property (nonatomic,weak) id<StudentSearchDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView indentifier:(NSString *)indentifier;

@end
