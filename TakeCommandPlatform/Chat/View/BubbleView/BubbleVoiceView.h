//
//  BubbleVoiceView.h
//  TakeCommandPlatform
//
//  Created by jyd on 2018/3/5.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatMessageModel.h"
@interface BubbleVoiceView : UIView

/** messageModel */
@property (nonatomic, strong) ChatMessageModel *message;

+ (instancetype)bubbleVocieView;

+ (CGSize)bubbleVoiceWithMessage:(ChatMessageModel *)message;

- (void)startPlay;

- (void)stopPlay;


@end
