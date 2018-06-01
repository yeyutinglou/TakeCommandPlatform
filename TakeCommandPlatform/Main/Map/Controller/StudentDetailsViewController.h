//
//  StudentDetailsViewController.h
//  TakeCommandPlatform
//
//  Created by jyd on 2017/12/22.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StudentSeatModel.h"
#import "StudentModel.h"
#import "SearchInfoModel.h"
@interface StudentDetailsViewController : UIViewController

/** 考生详情 */
//@property (nonatomic, strong) StudentSeatModel *studentModel;

/** student */
@property (nonatomic, strong) Student *student;

/** staff */
@property (nonatomic, strong) Staff *staff;

/** studentModel */
@property (nonatomic, strong) StudentModel *studentModel;


@end
