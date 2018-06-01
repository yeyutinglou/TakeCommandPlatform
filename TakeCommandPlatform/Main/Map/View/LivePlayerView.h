//
//  LivePlayerView.h
//  TakeCommandPlatform
//
//  Created by jyd on 2017/12/20.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExamRoomModel.h"
#import "StudentSearchModel.h"
@interface LivePlayerView : UIView

/** 考场信息 */
@property (nonatomic, strong) RoomInfo *roomInfo;

/** 学生信息 */
@property (nonatomic, strong) StudentSearchModel *studentSearchModel;


- (void)destoryPlayView;
@end
