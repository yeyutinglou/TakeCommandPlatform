//
//  ExamRoomVideoViewController.h
//  TakeCommandPlatform
//
//  Created by jyd on 2017/12/19.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExamRoomModel.h"
#import "ExamLocationModel.h"
#import "StudentSearchModel.h"
#import "ExaminationRoomModel.h"
@interface ExamRoomVideoViewController : UIViewController

/** 学校名称 */
@property (nonatomic, strong) NSString *sitechoolname;


/** 房间数据 */
//@property (nonatomic, strong) RoomInfo *roomInfo;

/** examRoom */
@property (nonatomic, strong) ExamRoom *examRoom;


//>>>>>>>搜索界面进入
/** 是否搜索界面 */
@property (nonatomic, assign) BOOL isSearch;
/** 学生信息 */
@property (nonatomic, strong) StudentSearchModel *studentSearchModel;

@end
