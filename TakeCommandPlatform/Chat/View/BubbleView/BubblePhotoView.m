//
//  BubblePhotoView.m
//  TakeCommandPlatform
//
//  Created by jyd on 2018/3/5.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import "BubblePhotoView.h"
#import "FLAnimatedImage.h"

@interface BubblePhotoView ()

/** imageView */
@property (nonatomic, strong) FLAnimatedImageView *imageView;

@end

@implementation BubblePhotoView

+ (instancetype)bubblePhotoView
{
    BubblePhotoView *bubbleView = [[BubblePhotoView alloc] init];
    return bubbleView;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.imageView = [[FLAnimatedImageView alloc] initWithFrame:self.bounds];
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        self.imageView.layer.cornerRadius = 6;
        self.imageView.clipsToBounds = YES;
        [self addSubview:self.imageView];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setMessage:(ChatMessageModel *)message
{
    _message = message;
    
    if (message.isSender) {
        if (message.isGif) {
            FLAnimatedImage *animatedImage = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfFile:message.localPhotoPath]];
            self.imageView.animatedImage = animatedImage;
        } else {
            self.imageView.image = [UIImage imageWithContentsOfFile:message.localPhotoPath];
        }
        [self setNeedsDisplay];
    } else {
        UIImage *placeHolderImage = kChatImage(@"placeholderImage@2x");
        [self.imageView sd_setImageWithURL:[NSURL URLWithString:message.thumbnailUrl] placeholderImage:placeHolderImage];
        [self setNeedsDisplay];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    if (_message.isGif) {
        self.imageView.frame = self.bounds;
    } else {
        self.imageView.frame = CGRectMake(KMargin, KMargin, self.width-2*KMargin, self.height-2*KMargin);
    }
}

- (void)drawRect:(CGRect)rect
{
    if (_message.isGif) {
        [UIImage drawImage:self.imageView.image rect:rect isSender:_message.isSender];
    }
}

+ (CGSize)bubblePhotoWithMessage:(ChatMessageModel *)message
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
