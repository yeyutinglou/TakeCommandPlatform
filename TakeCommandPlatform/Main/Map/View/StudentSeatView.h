//
//  StudentSeatView.h
//  TakeCommandPlatform
//
//  Created by jyd on 2017/12/22.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExamRoomModel.h"
#import "StudentSeatModel.h"
#import "StudentSearchModel.h"
@protocol StudentSeatDelegate <NSObject>

- (void)didSelectItemWithModel:(StudentSeatModel *)model;

@end

@interface StudentSeatView : UIView

///** 房间信息 */
//@property (nonatomic, strong) RoomInfo *roomInfo;

/** 学生信息 */
//@property (nonatomic, strong) StudentSearchModel *studentSearchModel;

/** arr */
@property (nonatomic, strong) NSArray *studentArry;



/** delegate */
@property (nonatomic,weak) id<StudentSeatDelegate> delegate;

@end
