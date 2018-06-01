//
//  ReceiverView.h
//  TakeCommandPlatform
//
//  Created by jyd on 2017/12/27.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ReviverViewBlock)(NSArray *arr);
@interface ReceiverView : UIView

/** block */
@property (nonatomic,copy) ReviverViewBlock block;

///接收通知的用户信息 (新建通知)
- (void)getReciverData;


/** 详情界面 */
@property (nonatomic, assign) BOOL isDetails;

/** 详情接收者 */
@property (nonatomic, strong) NSArray *detailsReceiberArray;


@end
