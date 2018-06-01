//
//  ChatMessageCell.m
//  TakeCommandPlatform
//
//  Created by jyd on 2018/3/6.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import "ChatMessageCell.h"
#import "BubbleTextView.h"
#import "BubblePhotoView.h"
#import "BubbleVoiceView.h"
#import "BubbleLocationView.h"
#import "BubbleVideoView.h"
#import "BubbleView.h"

@interface ChatMessageCell () <BubbleTextViewDelegate>
/** avatar */
@property (nonatomic, strong) UIImageView *avatarImageView;

/** name */
@property (nonatomic, strong) UILabel *nameLabel;

/** bgView */
@property (nonatomic, strong) BubbleView *bubbleView;


/** messageState */
@property (nonatomic, strong) UIView *messageSendStateView;

@end

@implementation ChatMessageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (instancetype)cellWithTableView:(UITableView *)tableView indentifier:(NSString *)indentifier
{
    ChatMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (!cell) {
        cell = [[ChatMessageCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:indentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [cell setupUI];
    }
    return cell;
}

- (void)setupUI
{
    self.avatarImageView = [[UIImageView alloc]init];
    self.avatarImageView.image = self.message.avatar;
    self.avatarImageView.layer.cornerRadius = 45.0/2;
    self.avatarImageView.clipsToBounds = YES;
 
    self.avatarImageView.userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(avaterTapAction:)];
    [self.avatarImageView addGestureRecognizer:tapGesture];
    
    
    
    self.bubbleView = [[BubbleView alloc]init];
    self.bubbleView.backgroundColor = [UIColor clearColor];
    
    
    self.messageSendStateView = [[UIView alloc]init];
    
    
    
    
    
    [self.contentView addSubview:self.avatarImageView];
    [self.contentView addSubview:self.bubbleView];
    [self.contentView addSubview:self.messageSendStateView];
}

- (void)setMessage:(ChatMessageModel *)message
{
    _message = message;
    
    [self.avatarImageView sd_setImageWithURL:[NSURL URLWithString:message.avatarUrl] placeholderImage:nil];
    
    if (message.isSender) {
        self.avatarImageView.frame = CGRectMake(self.width - 45 - KLeftMargin, KTopMargin, 45, 45);
        [self.bubbleView setBubbleImage:[UIImage imageWithColor:[UIColor blueColor]] isSender:YES];
    } else {
        self.avatarImageView.frame = CGRectMake(KLeftMargin, KTopMargin, 45, 45);
        [self.bubbleView setBubbleImage:[UIImage imageWithColor:[UIColor orangeColor]] isSender:NO];
    }
    
    [self.bubbleView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    
    switch (message.bubbleMessageBodyType) {
        case MessageBodyTypeText:
        {
            BubbleTextView *textView = [BubbleTextView bubbleTextView];
            textView.delegate = self;
            textView.message = message;
            [self.bubbleView addSubview:textView];
            
            CGSize size = [BubbleTextView bubbleTextViewSize:message];
            if (message.isSender) {
                self.bubbleView.frame = CGRectMake(CGRectGetMinX(self.avatarImageView.frame)-(size.width+2*KLeftMargin),KTopMargin,size.width+2*KLeftMargin,size.height+2*KTopMargin);
                
            }else{
                self.bubbleView.frame = CGRectMake(CGRectGetMaxX(self.avatarImageView.frame),KTopMargin,size.width+2*KLeftMargin,size.height+2*KTopMargin);
            }
            textView.frame = CGRectMake(KTopMargin, KLeftMargin, size.width, size.height);
            
        }
            break;
        case MessageBodyTypeVoice:
        {
            BubbleVoiceView *voiceView = [BubbleVoiceView bubbleVocieView];
            voiceView.message = message;
            [self.bubbleView addSubview:voiceView];
            
            CGSize size = [BubbleVoiceView bubbleVoiceWithMessage:message];
            if (_message.isSender) {
                self.bubbleView.frame = CGRectMake(CGRectGetMinX(self.avatarImageView.frame)-(size.width+2*KLeftMargin),KTopMargin,size.width+2*KLeftMargin,size.height+2*KTopMargin);
                
            }else{
                self.bubbleView.frame = CGRectMake(CGRectGetMaxX(self.avatarImageView.frame),KTopMargin,size.width+2*KLeftMargin,size.height+2*KTopMargin);
            }
            voiceView.frame = CGRectMake(KLeftMargin, KTopMargin, size.width, size.height);
        }
            break;
        case MessageBodyTypePhoto:
        {
            BubblePhotoView *photoView = [BubblePhotoView bubblePhotoView];
            photoView.message = message;
            [self.bubbleView addSubview:photoView];
            
            CGSize size = [BubblePhotoView bubblePhotoWithMessage:message];
            if (_message.isSender) {
                self.bubbleView.frame = CGRectMake(CGRectGetMinX(self.avatarImageView.frame)-(size.width+KSenderLeftBubbleImageMargin+KSenderRightBubbleImageMargin),KTopBubbleImageMargin,size.width+KSenderLeftBubbleImageMargin+KSenderRightBubbleImageMargin,size.height+2*KTopBubbleImageMargin);
                photoView.frame = CGRectMake(KSenderLeftBubbleImageMargin,KTopBubbleImageMargin, size.width, size.height);
            }else{
                self.bubbleView.frame = CGRectMake(CGRectGetMaxX(self.avatarImageView.frame),KTopBubbleImageMargin,size.width+KReceiverLeftBubbleImageMargin+KReceiverRightBubbleImageMargin,size.height+2*KTopBubbleImageMargin);
                 photoView.frame = CGRectMake(KReceiverLeftBubbleImageMargin,KTopBubbleImageMargin, size.width, size.height);
            }
           
            self.bubbleView.bubbleImage = nil;
            
        }
            break;
        case MessageBodyTypeVideo:
        {
            BubbleVideoView *videoView = [BubbleVideoView bubbleVideoView];
            videoView.message = message;
            [self.bubbleView addSubview:videoView];
            
            CGSize size = [BubbleVideoView bubbleVideoWithMessage:message];
            if (_message.isSender) {
                self.bubbleView.frame = CGRectMake(CGRectGetMinX(self.avatarImageView.frame)-(size.width+KSenderLeftBubbleImageMargin+KSenderRightBubbleImageMargin),KTopBubbleImageMargin,size.width+KSenderLeftBubbleImageMargin+KSenderRightBubbleImageMargin,size.height+2*KTopBubbleImageMargin);
                videoView.frame = CGRectMake(KSenderLeftBubbleImageMargin,KTopBubbleImageMargin, size.width, size.height);
            }else{
                self.bubbleView.frame = CGRectMake(CGRectGetMaxX(self.avatarImageView.frame),KTopBubbleImageMargin,size.width+KReceiverLeftBubbleImageMargin+KReceiverRightBubbleImageMargin,size.height+2*KTopBubbleImageMargin);
                videoView.frame = CGRectMake(KReceiverLeftBubbleImageMargin,KTopBubbleImageMargin, size.width, size.height);
            }
            
            //隐藏外部气泡图形
            // self.bubbleImageV.image = nil;
            //change
            self.bubbleView.bubbleImage = nil;

        }
            break;
        case MessageBodyTypeLocation:
        {
            BubbleLocationView *locationView = [BubbleLocationView bubbleLocationView];
            locationView.message = message;
            [self.bubbleView addSubview:locationView];
            
            CGSize size = [BubbleLocationView bubbleLocationWithMessage:message];
            if (message.isSender) {
                self.bubbleView.frame = CGRectMake(CGRectGetMinX(self.avatarImageView.frame)-(size.width+2*KLeftMargin),KTopMargin,size.width+2*KLeftMargin,size.height+2*KTopMargin);
                
            }else{
                self.bubbleView.frame = CGRectMake(CGRectGetMaxX(self.avatarImageView.frame),KTopMargin,size.width+2*KLeftMargin,size.height+2*KTopMargin);
            }
            
            locationView.frame = CGRectMake(KLeftMargin, KTopMargin, size.width, size.height);
            
        }
            break;
            
        default:
            break;
    }
    
    //左侧状态显示
    if (_message.isSender) {
        
        self.messageSendStateView.hidden = NO;
        
        
        self.messageSendStateView.frame = CGRectMake(CGRectGetMinX(self.bubbleView.frame)-20-KLeftMargin/2, CGRectGetHeight(self.bubbleView.frame)/2, 20, 20);
        [self.messageSendStateView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        switch (_message.deliveryState) {
            case MessageDeliveryStateDelivering: {
                
                UIActivityIndicatorView *activityView = [[UIActivityIndicatorView alloc]initWithFrame:self.messageSendStateView.bounds];
                [self.messageSendStateView addSubview:activityView];
                [activityView startAnimating];
                
                
                break;
            }
            case MessageDeliveryStateDelivered: {
                
                
                
                break;
            }
            case MessageDeliveryStateFailure: {
                
                
                UIButton *failureImageBtn = [[UIButton alloc]initWithFrame:self.messageSendStateView.bounds];
                [self.messageSendStateView addSubview:failureImageBtn];
                [failureImageBtn addTarget:self action:@selector(resendMessageAction:) forControlEvents:UIControlEventTouchUpInside];
                [failureImageBtn setImage:kChatImage(@"messageSendFail@2x")  forState:UIControlStateNormal];
                
                
                break;
            }
        }
        
    }
    
    else
    {
        self.messageSendStateView.hidden = YES;
    }
    
    
    
    //事件监听
    self.bubbleView.userInteractionEnabled = YES;
    
    if (_message.bubbleMessageBodyType == MessageBodyTypeText)
    {
        
        //手势也被复用了，进行移除
        for (UIGestureRecognizer *gesture in self.bubbleView.gestureRecognizers)
        {
            [self.bubbleView removeGestureRecognizer:gesture];
        }
        
        
        UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapAction:)];
        doubleTapGesture.numberOfTapsRequired = 2;
        [self.bubbleView addGestureRecognizer:doubleTapGesture];
        
    }
    
    
    else
    {
        
        //手势也被复用了，进行移除
        for (UIGestureRecognizer *gesture in self.bubbleView.gestureRecognizers)
        {
            
            [self.bubbleView removeGestureRecognizer:gesture];
        }
        
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        
        [self.bubbleView addGestureRecognizer:tapGesture];
    }
    
}


- (void)doubleTapAction:(UITapGestureRecognizer *)tapGeture
{
    if (_delegate && [_delegate respondsToSelector:@selector(textBubbleDidSelectedOnMessage:)]) {
        [_delegate textBubbleDidSelectedOnMessage:_message];
    }
}


- (void)tapAction:(UITapGestureRecognizer *)tapGeture
{
    switch (_message.bubbleMessageBodyType) {
            
        case MessageBodyTypeText:
            break;
            
        case MessageBodyTypePhoto: {
            if (_delegate && [_delegate respondsToSelector:@selector(photoBubbleDidSelectedOnMessage:photo:)]) {
                
                //传imageView:留存足够接口给第三方
                BubblePhotoView *bubleView = self.bubbleView.subviews.lastObject;
                
                [_delegate photoBubbleDidSelectedOnMessage:_message photo:bubleView.subviews.lastObject];
            }
            break;
        }
        case MessageBodyTypeVideo: {
            if (_delegate && [_delegate respondsToSelector:@selector(videoBubbleDidSelectedOnMessage:)]) {
                [_delegate videoBubbleDidSelectedOnMessage:_message];
            }
            break;
        }
        case MessageBodyTypeVoice: {
            if (_delegate && [_delegate respondsToSelector:@selector(audioRecoderBubbleDidSelectedOnMessage:)]) {
                [_delegate audioRecoderBubbleDidSelectedOnMessage:_message];
            }
            break;
        }
        case MessageBodyTypeLocation: {
            if (_delegate && [_delegate respondsToSelector:@selector(locationBubbleDidSelectedOnMessage:)]) {
                [_delegate locationBubbleDidSelectedOnMessage:_message];
            }
            break;
        }
    }
}


- (void)resendMessageAction:(UIButton *)btn
{
    if (_delegate && [_delegate respondsToSelector:@selector(resendMessage:)]) {
        [_delegate resendMessage:_message];
    }
}

- (void)didSelectLink:(NSString *)link withType:(MLEmojiLabelLinkType)type
{
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectLink:withType:)]) {
        
        [_delegate didSelectLink:link withType:type];
    }
}



- (void)avaterTapAction:(UITapGestureRecognizer *)tapGesture
{
    if (_delegate && [_delegate respondsToSelector:@selector(avaterDidSelectedOnMessage:)]) {
        
        [_delegate avaterDidSelectedOnMessage:_message];
    }
}


+ (CGFloat)cellHeight:(ChatMessageModel *)message
{
    CGFloat avaterImageHeight = 45;
    
    
    CGFloat bubbleViewHeight = 0;
    switch (message.bubbleMessageBodyType) {
        case MessageBodyTypeText: {
            bubbleViewHeight = [BubbleTextView bubbleTextViewSize:message].height;
            bubbleViewHeight += KTopMargin*2;
            break;
        }
        case MessageBodyTypePhoto: {
            bubbleViewHeight = [BubblePhotoView bubblePhotoWithMessage:message].height;
            bubbleViewHeight += KTopMargin*2;
            break;
        }
        case MessageBodyTypeVideo: {
            bubbleViewHeight = [BubbleVideoView bubbleVideoWithMessage:message].height;
            bubbleViewHeight += KTopMargin*2;
            break;
        }
        case MessageBodyTypeVoice: {
            bubbleViewHeight = [BubbleVoiceView bubbleVoiceWithMessage:message].height;
            bubbleViewHeight += KTopMargin*2;
            break;
        }
            
        case MessageBodyTypeLocation: {
            bubbleViewHeight = [BubbleLocationView bubbleLocationWithMessage:message].height;
            bubbleViewHeight += KTopMargin*2;
            
            break;
        }
    }
    
    
    if (bubbleViewHeight<avaterImageHeight) {
        bubbleViewHeight = avaterImageHeight;
    }
    
    return KTopMargin+bubbleViewHeight+KTopMargin;
}
@end
