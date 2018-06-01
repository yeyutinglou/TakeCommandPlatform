//
//  BubbleLocationView.h
//  TakeCommandPlatform
//
//  Created by jyd on 2018/3/6.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatMessageModel.h"
@interface BubbleLocationView : UIView

/** messageModel */
@property (nonatomic, strong) ChatMessageModel *message;


+ (instancetype)bubbleLocationView;

+ (CGSize)bubbleLocationWithMessage:(ChatMessageModel *)message;

@end
