//
//  BubbleVoiceView.m
//  TakeCommandPlatform
//
//  Created by jyd on 2018/3/5.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import "BubbleVoiceView.h"

@interface BubbleVoiceView ()

/** voiceImageView */
@property (nonatomic, strong) UIImageView *voiceImageView;

/** timeDurationLabel */
@property (nonatomic, strong) UILabel *timeDurationLabel;

/** readView */
@property (nonatomic, strong) UIView *readDotView;


/** sendVoiceArray */
@property (nonatomic, strong) NSMutableArray *sendVoiceAnimationArray;

/** receiveArray */
@property (nonatomic, strong) NSMutableArray *receiveVoiceAnimationArray;


@end

@implementation BubbleVoiceView

+ (instancetype)bubbleVocieView
{
    BubbleVoiceView *bubbleView = [[self alloc] init];
    return bubbleView;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.voiceImageView = [[UIImageView alloc] init];
        self.voiceImageView.clipsToBounds = YES;
        [self addSubview:self.voiceImageView];
        
        self.timeDurationLabel = [[UILabel alloc]init];
        self.timeDurationLabel.textColor = [UIColor blackColor];
        self.timeDurationLabel.font = kFont(13);
        self.timeDurationLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.timeDurationLabel];
        
        
        self.readDotView = [[UIView alloc]init];
        self.readDotView.backgroundColor = [UIColor redColor];
        self.readDotView.layer.cornerRadius = 4;
        [self addSubview:self.readDotView];
    }
    return self;
}

- (void)setMessage:(ChatMessageModel *)message
{
    _message = message;
    
    if (_message.isSender) {
        self.voiceImageView.image = kChatImage(KSendVoiceImageDefault);
        self.voiceImageView.animationImages = self.sendVoiceAnimationArray;
    } else {
        self.voiceImageView.image = kChatImage(KReceiveVoiceImageDefault);
        self.voiceImageView.animationImages = self.receiveVoiceAnimationArray;
    }
  
    self.readDotView.hidden = message.isRead;
    
    self.voiceImageView.animationDuration = 2;
    if (message.isPlaying) {
        [self.voiceImageView startAnimating];
    } else {
        [self.voiceImageView stopAnimating];
    }
    
    CGFloat totalTime = [message.voiceDuration floatValue];
    NSInteger min = totalTime/60;
    NSInteger sec = totalTime- 60*min;
    if (min<=0) {
        self.timeDurationLabel.text = [NSString stringWithFormat:@"%ld\''",(NSInteger)totalTime];
    }else{
        
        NSString *duration = [[NSString stringWithFormat:@"%ld\'",min]stringByAppendingString:[NSString stringWithFormat:@"%ld\''",sec]];
        self.timeDurationLabel.text = duration;
    }
}

- (void)startPlay
{
    [self.voiceImageView startAnimating];
}

- (void)stopPlay
{
    [self.voiceImageView stopAnimating];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_message.isSender) {
        self.voiceImageView.frame = CGRectMake(self.width - 20, 5, 15, 20);
        self.timeDurationLabel.frame = CGRectMake(self.voiceImageView.left - 35 - KLeftMargin, 0, 35, 30);
        self.readDotView.frame = CGRectMake(self.right - 8 - 8, 0, 8, 8);
    } else {
        
        self.voiceImageView.frame = CGRectMake(0, 5, 15, 20);
        self.timeDurationLabel.frame = CGRectMake(CGRectGetMaxX(self.voiceImageView.frame)+KLeftMargin, 0, 35, 30);
        
        self.readDotView.frame = CGRectMake(CGRectGetMaxX(self.frame)-8-4, 0, 8, 8);
    }
}

+ (CGSize)bubbleVoiceWithMessage:(ChatMessageModel *)message
{
    CGFloat bubbleWidth = ([message.voiceDuration floatValue]/kVoiceRecorderTotalTime)*(KBubbleVoiceMaxWidth-20-KLeftMargin);
    if (bubbleWidth<=35) {
        bubbleWidth = 35;
    }
    
    return CGSizeMake(bubbleWidth+20, 30);
}

- (NSMutableArray *)sendVoiceAnimationArray
{
    if (_sendVoiceAnimationArray == nil) {
        _sendVoiceAnimationArray = [[NSMutableArray alloc] initWithCapacity:KSendVoiceAnimationArray.count];
        for (int i = 0; i < KSendVoiceAnimationArray.count; i++) {
            [_sendVoiceAnimationArray addObject:kChatImage(KSendVoiceAnimationArray[i])];
        }
    }
    return _sendVoiceAnimationArray;
}

- (NSMutableArray *)receiveVoiceAnimationArray
{
    if (_receiveVoiceAnimationArray == nil) {
        _receiveVoiceAnimationArray = [[NSMutableArray alloc] initWithCapacity:KReceiveVoiceAnimationArray.count];
        for (int i = 0; i < KReceiveVoiceAnimationArray.count; i++) {
            [_receiveVoiceAnimationArray addObject:kChatImage(KReceiveVoiceAnimationArray[i])];
        }
    }
    return _receiveVoiceAnimationArray;
}

@end
