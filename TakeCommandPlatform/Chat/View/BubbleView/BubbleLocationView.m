//
//  BubbleLocationView.m
//  TakeCommandPlatform
//
//  Created by jyd on 2018/3/6.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import "BubbleLocationView.h"
#define KLocationFont [UIFont boldSystemFontOfSize:15]

@interface BubbleLocationView ()
/** locationLabel */
@property (nonatomic, strong) UILabel *locationLabel;

/** locationImageView */
@property (nonatomic, strong) UIImageView *locationImageView;

@end

@implementation BubbleLocationView

+ (instancetype)bubbleLocationView
{
    BubbleLocationView *bubbleView = [[self alloc] init];
    return bubbleView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.locationImageView = [[UIImageView alloc] init];
        self.locationImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.locationImageView.clipsToBounds = YES;
        [self addSubview:self.locationImageView];
        
        self.locationLabel = [[UILabel alloc] init];
        self.locationLabel.textColor = [UIColor blackColor];
        self.locationLabel.font = kFont(13);
        self.locationLabel.numberOfLines = 0;
        self.locationLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.locationLabel];
    }
    return self;
}


- (void)setMessage:(ChatMessageModel *)message
{
    _message = message;
    
    if (message.localPositionPhotoPath) {
        self.locationImageView.image = [UIImage imageWithContentsOfFile:message.localPositionPhotoPath];
    } else {
        self.locationImageView.image = kChatImage(KBubbleLocationImageDefault);
    }
    self.locationLabel.text = message.address;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.locationImageView.frame = CGRectMake(0, 0, 90, 90);
    CGFloat locationHeight = [self.message.address boundingRectWithSize:CGSizeMake(90, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:KLocationFont} context:nil].size.height;
    
    if (locationHeight > 90 - 10 * 2) {
        locationHeight = 90 - 10* 2;
    }
    self.locationLabel.frame = CGRectMake(self.locationImageView.right + KLeftMargin, KTopMargin, 90, locationHeight);
}

+ (CGSize)bubbleLocationWithMessage:(ChatMessageModel *)message
{
    return CGSizeMake(90 + 90 + KLeftMargin, 90);
}

@end
