//
//  KeyBoardToolBar.m
//  TakeCommandPlatform
//
//  Created by jyd on 2018/2/27.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import "KeyBoardToolBar.h"

@interface KeyBoardToolBar () <VoiceRecordingDelegate, HPGrowingTextViewDelegate>

/** textHeight */
@property (nonatomic, assign) float textHeight;

/** selectBtnIndex */
@property (nonatomic, assign) NSInteger selectBtnIndex;
@end

@implementation KeyBoardToolBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.textHeight = KTextHeight;
        [self setupUI];
    }
    return self;
}


- (void)setupUI
{
    //语音文本输入切换按钮
    self.switchBtn = [[UIButton alloc]init];
    self.switchBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [self.switchBtn setImage:kChatImage(@"chatBar_record@2x") forState:UIControlStateNormal];
    [self.switchBtn setImage:kChatImage(@"chatBar_keyboard@2x") forState:UIControlStateSelected];
    [self.switchBtn addTarget:self action:@selector(switchBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.switchBtn];
    
    
    //输入框
    self.textView = [[HPGrowingTextView alloc] init];
    self.textView.backgroundColor = [UIColor whiteColor];
    self.textView.placeholder = @"输入消息";
    self.textView.isScrollable = NO;
    self.textView.contentInset = UIEdgeInsetsMake(0, 5, 0, 5);
    self.textView.minNumberOfLines = 1;
    self.textView.maxNumberOfLines = 6;
    self.textView.returnKeyType = UIReturnKeySend;
    self.textView.font = kFont(15);
    self.textView.delegate = self;
    self.textView.internalTextView.scrollIndicatorInsets = UIEdgeInsetsMake(5, 0, 5, 0);
    [self addSubview:self.textView];
    
    
    //录音
    self.recordBtn = [[VoiceRecordBtn alloc] init];
    //  self.recordBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [self.recordBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.recordBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    [self.recordBtn setBackgroundImage:[kChatImage(@"chatBar_recordBg@2x") stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateNormal];
    [self.recordBtn setBackgroundImage:[kChatImage(@"chatBar_recordSelectedBg@2x") stretchableImageWithLeftCapWidth:10 topCapHeight:10] forState:UIControlStateHighlighted];
    self.recordBtn.hidden = YES;
    self.recordBtn.clipsToBounds = YES;
    self.recordBtn.layer.cornerRadius = 6.0f;
    self.recordBtn.delegate = self;
    [self addSubview:self.recordBtn];
    
    
    //emoji按钮
    self.emojiBtn = [[UIButton alloc] init];
    self.emojiBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    
    [self.emojiBtn setImage:kChatImage(@"chatBar_face@2x") forState:UIControlStateNormal];
    [self.emojiBtn setImage:kChatImage(@"chatBar_faceSelected@2x") forState:UIControlStateHighlighted];
    [self.emojiBtn setImage:[NSBundle imageWithBundle:@"chatUiResource" imageName:@"chatBar_keyboard@2x"] forState:UIControlStateSelected];
    [self.emojiBtn addTarget:self action:@selector(emojiBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.emojiBtn];
    
    
    //moreBtn
    self.moreBtn = [[UIButton alloc]init];
    self.moreBtn.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin;
    [self.moreBtn setImage:kChatImage(@"chatBar_more@2x") forState:UIControlStateNormal];
    [self.moreBtn setImage:kChatImage(@"chatBar_moreSelected@2x") forState:UIControlStateHighlighted];
    [self.moreBtn setImage:kChatImage(@"chatBar_keyboard@2x") forState:UIControlStateSelected];
    [self.moreBtn addTarget:self action:@selector(moreBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.moreBtn];
    
    
    self.switchBtn.frame = CGRectMake(kHorizontalPadding, self.height-kVerticalPadding-KTextHeight, KTextHeight, KTextHeight);
    
    self.moreBtn.frame = CGRectMake(CGRectGetWidth(self.bounds)-kHorizontalPadding-KTextHeight, self.height-kVerticalPadding-KTextHeight, KTextHeight, KTextHeight);
    
    self.emojiBtn.frame = CGRectMake(CGRectGetMinX(self.moreBtn.frame)-kHorizontalPadding-KTextHeight, self.height-kVerticalPadding-KTextHeight, KTextHeight, KTextHeight);
    
    
    
    self.recordBtn.frame = CGRectMake(CGRectGetMaxX(self.switchBtn.frame)+kHorizontalPadding, self.height-kVerticalPadding-KTextHeight, CGRectGetMinX(self.emojiBtn.frame)-CGRectGetMaxX(self.switchBtn.frame)-2*kHorizontalPadding, self.height-2*kVerticalPadding);
    
    
    self.textView.frame = CGRectMake(self.switchBtn.right+kHorizontalPadding, self.height-kVerticalPadding-KTextHeight, CGRectGetMinX(self.emojiBtn.frame)-CGRectGetMaxX(self.switchBtn.frame)-2*kHorizontalPadding, self.height-2*kVerticalPadding);
    
    self.recordBtn.hidden = YES;
}
- (void)btnAction:(UIButton *)btn
{
    for (UIView *view in self.subviews) {
        
        if ([view isKindOfClass:[UIButton class]]) {
            
            
            UIButton *otherBtn = (UIButton *)view;
            if (btn == otherBtn) {
                continue;
            }
            otherBtn.selected = NO;
            
        }
    }
    
    NSInteger index = btn.tag;
    btn.selected ^= 1;
    switch (index) {
            
        case KeyBoardTypeVoiceRecoder:
            
            [self setToolBarToNormalState];
            
            break;
        case KeyBoardTypeEmoij:
            
            break;
        case KeyBoardTypeMore:
            
            break;
            
        default:
            break;
    }
    
    _selectBtnIndex = index;
    
    self.recordBtn.hidden = !self.switchBtn.selected;
    
    !btn.selected ? [self.textView becomeFirstResponder] :[self.textView resignFirstResponder];
    
    //toolBar切换，回调外部键盘frame变化
    self.keyBoardFrameChange ? self.keyBoardFrameChange(index,!btn.selected):nil;
    
    
}




#pragma mark --  GrowingTextViewDelegate
- (BOOL)growingTextView:(HPGrowingTextView *)growingTextView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        
        [self sendMessage];
        
        
        return NO;
    }
    
    return YES;
}

- (BOOL)growingTextViewShouldReturn:(HPGrowingTextView *)growingTextView
{
    [self sendMessage];
    return YES;
}

- (void)growingTextView:(HPGrowingTextView *)growingTextView didChangeHeight:(float)height
{
    self.textHeight = height;
    [self updateFrame:self.textHeight];
    if (self.textHeight>KTextHeight) {
        [[NSNotificationCenter defaultCenter]postNotificationName:KTextViewHeightChangeNotification object:@(self.textHeight-KTextHeight)];
    }
}

- (void)sendMessage
{
    if (_keyBoardToolBarDelegate && [_keyBoardToolBarDelegate respondsToSelector:@selector(sendTextAction:)]) {
        
        [_keyBoardToolBarDelegate sendTextAction:self.textView.text];
    }
    
    [self setToolBarToNormalState];
}


//只改变了toolBar的高度，键盘其实高度未变（假象一个）
- (void)updateFrame:(CGFloat)textHeight
{
    self.textHeight = textHeight;
    
    
    //一行高度：默认高度
    if (self.textHeight <  KTextHeight) {
        self.top = 0;
        self.height = KeyToolBarHeight;
    }else{
        //多行高度，通过行高度变化增量，改变toolBar的顶点坐标以及高度
        //顶部坐标增量
        self.top = KTextHeight - self.textHeight;
        
        //键盘增量
        self.height = KeyToolBarHeight+ (textHeight -KTextHeight);
    }
}

//public:emoij消息发送也需要
- (void)setToolBarToNormalState
{
    self.textView.text = nil;
    
    self.textHeight = KTextHeight;
    self.top = 0;
    self.height = KeyToolBarHeight;
}


#pragma mark -- voice recoder delegate
- (void)setPeakPower:(float)peakPower
{
    _peakPower = peakPower;
    self.recordBtn.peakPower = peakPower;
}



- (void)prepareRecordingVoiceAction
{
    if (_voiceRecordingDelegate && [_voiceRecordingDelegate respondsToSelector:@selector(prepareRecordingVoiceAction)]) {
        [_voiceRecordingDelegate prepareRecordingVoiceAction];
    }
}

- (void)startRecordingVoiceAction
{
    if (_voiceRecordingDelegate && [_voiceRecordingDelegate respondsToSelector:@selector(startRecordingVoiceAction)]) {
        [_voiceRecordingDelegate startRecordingVoiceAction];
    }
}

- (void)cancelRecordingVoiceAction
{
    if (_voiceRecordingDelegate && [_voiceRecordingDelegate respondsToSelector:@selector(cancelRecordingVoiceAction)])
    {
        [_voiceRecordingDelegate cancelRecordingVoiceAction];
    }
}

- (void)finishRecordingVoiceAction
{
    if (_voiceRecordingDelegate && [_voiceRecordingDelegate respondsToSelector:@selector(finishRecordingVoiceAction)])
    {
        [_voiceRecordingDelegate finishRecordingVoiceAction];
    }
}



- (void)dragOutsideAction
{
    
    if ([_voiceRecordingDelegate respondsToSelector:@selector(dragOutsideAction)])
    {
        [_voiceRecordingDelegate dragOutsideAction];
    }
}

- (void)dragInsideAction
{
    
    if ([_voiceRecordingDelegate respondsToSelector:@selector(dragInsideAction)])
    {
        [_voiceRecordingDelegate dragInsideAction];
    }
}

@end
