//
//  BubbleVideoView.h
//  TakeCommandPlatform
//
//  Created by jyd on 2018/3/5.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BubblePhotoView.h"
@interface BubbleVideoView : UIView

/** messageModel */
@property (nonatomic, strong) ChatMessageModel *message;

+ (instancetype)bubbleVideoView;

+ (CGSize)bubbleVideoWithMessage:(ChatMessageModel *)message;

@end
