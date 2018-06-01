//
//  VideoPhoneCollectionCell.h
//  TakeCommandPlatform
//
//  Created by jyd on 2018/1/5.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReceiverModel.h"
@interface VideoPhoneCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *calling;

/** 视频用户 */
@property (nonatomic, strong) ReceiverModel *receivermodel;

///是否被标记
- (void)itemChangeSelectedState;

///是否通话中
- (void)itemChangeCallingState:(BOOL)isCalling;
@end
