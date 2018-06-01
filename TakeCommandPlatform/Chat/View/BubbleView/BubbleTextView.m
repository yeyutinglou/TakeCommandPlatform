//
//  BubbleTextView.m
//  TakeCommandPlatform
//
//  Created by jyd on 2018/3/5.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import "BubbleTextView.h"

#define kLabelFont kFont(14)

@interface BubbleTextView ()<MLEmojiLabelDelegate>

/** emojiLabel */
@property (nonatomic, strong) MLEmojiLabel *emojiLabel;

@end

@implementation BubbleTextView

+ (instancetype)bubbleTextView
{
    BubbleTextView *bubbleView = [[self alloc] init];
    return bubbleView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.emojiLabel = [[MLEmojiLabel alloc]initWithFrame:self.bounds];
        self.emojiLabel.disableEmoji = NO;
        self.emojiLabel.userInteractionEnabled = YES;
        self.emojiLabel.delegate = self;
        self.emojiLabel.font = kLabelFont;
        self.emojiLabel.numberOfLines = 0;
        self.emojiLabel.lineBreakMode = NSLineBreakByCharWrapping;
        [self addSubview:self.emojiLabel];
    }
    return self;
}

- (void)setMessage:(ChatMessageModel *)message
{
    _message = message;
    self.emojiLabel.text = _message.text;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.emojiLabel.frame = self.bounds;
}

+ (CGSize)bubbleTextViewSize:(ChatMessageModel *)message
{
    CGFloat width = [message.text boundingRectWithSize:CGSizeMake(MAXFLOAT, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kLabelFont} context:nil].size.width;
    
    if (width<=KMaxWidth) {
        
        return CGSizeMake(width, 30);
        
    }else{
        CGFloat height = [message.text boundingRectWithSize:CGSizeMake(KMaxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kLabelFont} context:nil].size.height;
        return CGSizeMake(KMaxWidth, height+25);
    }
    return CGSizeZero ;
}


- (void)mlEmojiLabel:(MLEmojiLabel *)emojiLabel didSelectLink:(NSString *)link withType:(MLEmojiLabelLinkType)type
{
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectLink:withType:)]) {
        [_delegate didSelectLink:link withType:type];
    }
}
@end
