//
//  KeyBoardView.m
//  TakeCommandPlatform
//
//  Created by jyd on 2018/2/5.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import "KeyBoardView.h"
#import "VoiceRecordBtn.h"
#import "BottomActivityView.h"

#define KeyBoardSystemMargin 3

@interface KeyBoardView () <VoiceRecordingDelegate,KeyBoardToolBarDelegate,MoreViewDelegate,EmojiEmoticonsViewDelegate>

@property(nonatomic,strong) KeyBoardToolBar *toolBarView;
@property(nonatomic,strong) BottomActivityView *bottomActivityView;

@property(nonatomic,strong) MoreView *bottomMoreView;
@property(nonatomic,strong) BottomEmojiView *bottomEmojiView;

@property(nonatomic,assign) CGFloat keyBoardHeight;

@end

@implementation KeyBoardView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.frame = CGRectMake(0, SCREEN_HEIGHT-KeyToolBarHeight, SCREEN_WIDTH, KeyToolBarHeight);
        [self setupUI];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textViewHeightChange:) name:KTextViewHeightChangeNotification object:nil];
        
        
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyBoardFrameChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    }
    return self;
}


- (void)keyBoardFrameChange:(NSNotification *)notify
{
    CGRect keyBoradRect = [notify.userInfo[UIKeyboardWillChangeFrameNotification] CGRectValue];
    
    self.keyBoardHeight = CGRectGetHeight(keyBoradRect);
}


- (void)setupUI
{
    self.toolBarView = [[KeyBoardToolBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, KeyToolBarHeight)];
    self.toolBarView.voiceRecordingDelegate = self;
    
    self.toolBarView.keyBoardToolBarDelegate = self;
    
    [self addSubview:self.toolBarView];
    
    
    
    //自定义键盘高度变化事件：
    
    __weak typeof(self) weakSelf = self;
    [self.toolBarView setKeyBoardFrameChange:^(NSInteger index,BOOL isInput) {
        
        __block  CGRect rect = weakSelf.frame;
        
        
        
        if (index == KeyBoardTypeSystem) {
            
            
            rect.origin.y = SCREEN_HEIGHT-KeyToolBarHeight-self.keyBoardHeight-KeyBoardSystemMargin;
            
            
        }
        
        else
        {
//            [weakSelf.bottomActivityView.subviews makeObjectsPerformSelector:@selector( removeFromSuperview)];
            switch (index) {
                    
                case 0:
                    weakSelf.height = KeyToolBarHeight;
                    rect = self.frame;
                    isInput ?(rect.origin.y = SCREEN_HEIGHT-KeyToolBarHeight-self.keyBoardHeight-KeyBoardSystemMargin):(rect.origin.y = SCREEN_HEIGHT-KeyToolBarHeight);
                    
                    break;
                case 1:
                    
                    //改变键盘高度:250
                    weakSelf.height = 250;
                    
                    //用作键盘弹上动画
                    rect = self.frame;
                    //改变底部activityView的尺寸:在layoutsubview中写就不用重复设置
                    weakSelf.bottomActivityView.height = 250-KeyToolBarHeight;
                    
                    isInput ? (rect.origin.y = SCREEN_HEIGHT-KeyToolBarHeight-self.keyBoardHeight-KeyBoardSystemMargin):(rect.origin.y = SCREEN_HEIGHT-250);
                    [weakSelf.bottomActivityView addSubview:weakSelf.bottomEmojiView];
                    
                    break;
                    
                case 2:
                    //改变键盘高度:280
                    weakSelf.height = 280;
                    rect = self.frame;
                    weakSelf.bottomActivityView.height = 280-KeyToolBarHeight;
                    
                    
                    isInput ? (rect.origin.y = SCREEN_HEIGHT-KeyToolBarHeight-self.keyBoardHeight-KeyBoardSystemMargin):(rect.origin.y = SCREEN_HEIGHT-280);
                    
                    
                    [weakSelf.bottomActivityView addSubview:weakSelf.bottomMoreView];
                    
                    break;
                    
                    
                default:
                    break;
            }
        }
        
        
        
        weakSelf.keyBoardDetalChange =  SCREEN_HEIGHT - CGRectGetMinY(rect);
        
        [UIView animateWithDuration:0.3 animations:^{
            
            weakSelf.frame = rect;
            
        }];
        
    }];
    
    
    
    
    
    
    self.bottomActivityView = [[BottomActivityView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.toolBarView.frame), SCREEN_WIDTH, self.height-CGRectGetHeight(self.toolBarView.frame))];
    [self addSubview:self.bottomActivityView];

    
    
    
}



//从外界触发键盘的隐藏
- (void)setHideKeyBoard:(BOOL)hideKeyBoard
{
    _hideKeyBoard = hideKeyBoard;
    [self endEditing:YES];
    
    if (self.toolBarView.switchBtn.selected) {
        return;
    }
    self.toolBarView.switchBtn.selected = NO;
    self.toolBarView.emojiBtn.selected = NO;
    self.toolBarView.moreBtn.selected = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        
        self.top = SCREEN_HEIGHT-KeyToolBarHeight;
    }];
}




#pragma mark --- moreViewDelegate
- (void)moreViewClick:(MoreViewType)type
{
    if (_moreViewDelegate && [_moreViewDelegate respondsToSelector:@selector(moreViewClick:)]) {
        
        [_moreViewDelegate moreViewClick:type];
    }
}

#pragma mark --- emoijViewDelegate
- (void)addEmoij:(NSString *)emoij isDeleteLastEmoij:(BOOL)isDeleteLastEmoij
{
    
    if (isDeleteLastEmoij) {
        NSMutableString *text = [self.toolBarView.textView.text mutableCopy];
        
        //无输入，不删除
        if (!text.length) {
            return;
        }
        
        if (text.length>=2) {
            [text deleteCharactersInRange:NSMakeRange(text.length-2, 2)];
        }
        self.toolBarView.textView.text = text;
        
        //无emoij了，置空，显示placeHolder
        if (self.toolBarView.textView.text.length == 0) {
            self.toolBarView.textView.text = nil;
        }
    }
    else
    {
        self.toolBarView.textView.text = [self.toolBarView.textView.text stringByAppendingString:emoij];
    }
    
    
#pragma mark --- 这里编码转化出来的emoij非字符串，不会实现textView代理方法，需要手动调用
    [self.toolBarView textViewDidChange:(UITextView *)self.toolBarView.textView];
    
}

- (void)sendEmoijMessage:(NSString *)text
{
    
    
    if (!self.toolBarView.textView.text.length) {
        return;
    }
    
    if (_emojiEmoticonsViewDelegate && [_emojiEmoticonsViewDelegate respondsToSelector:@selector(sendEmoijMessage:)]) {
        [_emojiEmoticonsViewDelegate sendEmoijMessage:self.toolBarView.textView.text];
    }
    
    [self.toolBarView setToolBarToNormalState];
}



//发送非emoij图片
- (void)sendEmotionImage:(NSString *)localPath emotionType:(EmotionType)emotionType
{
    if (_emojiEmoticonsViewDelegate && [_emojiEmoticonsViewDelegate respondsToSelector:@selector(sendEmotionImage:emotionType:)])
    {
        
        [_emojiEmoticonsViewDelegate sendEmotionImage:localPath emotionType:emotionType];;
    }
}





#pragma mark --- voiceRecoderDelegate


//录音，正向传值
- (void)setPeakPower:(float)peakPower
{
    _peakPower = peakPower;
    self.toolBarView.peakPower = peakPower;
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
