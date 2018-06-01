//
//  BubbleTextView.h
//  TakeCommandPlatform
//
//  Created by jyd on 2018/3/5.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MLEmojiLabel.h"
#import "ChatMessageModel.h"

@protocol BubbleTextViewDelegate <NSObject>

- (void)didSelectLink:(NSString *)link withType:(MLEmojiLabelLinkType)type;

@end

@interface BubbleTextView : UIView


/** messageModel */
@property (nonatomic, strong) ChatMessageModel *message;

/** delegate */
@property (nonatomic, weak) id <BubbleTextViewDelegate> delegate;

+ (instancetype)bubbleTextView;

+ (CGSize)bubbleTextViewSize:(ChatMessageModel *)message;
@end
