//
//  BubbleVideoView.m
//  TakeCommandPlatform
//
//  Created by jyd on 2018/3/5.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import "BubbleVideoView.h"

@interface BubbleVideoView ()

/** imageView */
@property (nonatomic, strong) UIImageView *imageView;


@end

@implementation BubbleVideoView

+ (instancetype)bubbleVideoView
{
    BubbleVideoView *bubbleView = [[self alloc] init];
    return bubbleView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.imageView = [[UIImageView alloc]initWithFrame:self.bounds];
        self.imageView.contentMode = UIViewContentModeCenter;
        self.imageView.clipsToBounds = YES;
        self.imageView.layer.cornerRadius = 6;
        [self addSubview:self.imageView];
        
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setMessage:(ChatMessageModel *)message
{
    _message = message;
    
    if (message.isSender) {
        self.imageView.image = [UIImage imageWithContentsOfFile:message.videoThumbPhoto];
    } else {
        UIImage *placeHolderImage = kChatImage(@"placeholderImage@2x");
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:message.videoThumbUrl] placeholderImage:placeHolderImage];
    }
}

- (void)drawRect:(CGRect)rect
{
    if (!_message.isGif) {
        
        [UIImage drawImage:self.imageView.image rect:rect isSender:_message.isSender];
    }
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    
    //一旦开启image绘图，不能执行这句，而gif图不需要渲染气泡
    if (_message.isGif) {
        self.imageView.frame = self.bounds;
    }
    
    
}

+ (CGSize)bubbleVideoWithMessage:(ChatMessageModel *)message
{
    CGSize imageSize = message.size;
    
    //未返回尺寸
    if (imageSize.width == 0 || imageSize.height == 0) {
        if (message.localPhotoPath) {
            UIImage *photo = [UIImage imageWithContentsOfFile:message.localPhotoPath];
            imageSize = photo.size;
            [self getConstrainImageSize:imageSize];
        } else {
            imageSize.width = KBubbleImageMaxWidth;
            imageSize.height = KBubbleImageMaxHeight;
        }
    } else {
        [self getConstrainImageSize:imageSize];
    }
    return imageSize;
}

//改变图片处理方式：微信方式：长>宽  ，图片长为固定最大长度，宽按比例缩放，长<宽，图片宽为最大宽度，长按比例缩放
+ (void)getConstrainImageSize:(CGSize)imageSize
{
    if (imageSize.width>imageSize.height)
    {
        imageSize.height *= KBubbleImageMaxWidth/imageSize.width;
        imageSize.width = KBubbleImageMaxWidth;
    }else{
        
        imageSize.width *= KBubbleImageMaxHeight/imageSize.height;
        imageSize.height = KBubbleImageMaxHeight;
    }
}

@end
