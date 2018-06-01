//
//  StudentSeatCollectionCell.h
//  TakeCommandPlatform
//
//  Created by jyd on 2017/12/22.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudentSeatModel.h"
#import "StudentSearchModel.h"

#import "StudentModel.h"
@interface StudentSeatCollectionCell : UICollectionViewCell

///** 考生信息 */
//@property (nonatomic, strong) StudentSeatModel *studentSeatModel;
//
//** 搜索的考生信息 */
//@property (nonatomic, strong) StudentSearchModel *studentSearchModel;

/** studentModel */
@property (nonatomic, strong) StudentModel *studentModel;

@end
