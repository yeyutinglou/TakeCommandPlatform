//
//  BottomEmojiView.m
//  TakeCommandPlatform
//
//  Created by jyd on 2018/2/27.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import "BottomEmojiView.h"
#import "EmojiEmoticonsToolBar.h"
#import "EmojiEmoticonsView.h"

#define  KMargin 4

#define  KColumNum 7
#define  KRowNum 3

@interface BottomEmojiView () <UIScrollViewDelegate, EmojiEmoticonsViewDelegate>

/** scrollView */
@property (nonatomic, strong) UIScrollView *scrollView;

/** pageControl */
@property (nonatomic, strong) UIPageControl *pageControl;

/** toolBar */
@property (nonatomic, strong) EmojiEmoticonsToolBar *toolBar;

/** EmoticonsView */
@property (nonatomic, strong) EmojiEmoticonsView *emoticonsView;


@end


@implementation BottomEmojiView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
     self.backgroundColor = [UIColor whiteColor];
        [self setupUI];
    }
    return self;
}


- (void)setupUI
{
    //scrollView:装emoij面板
    self.scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.pagingEnabled = YES;
    self.scrollView.delegate = self;
    [self addSubview:self.scrollView];
    
    //pageControl
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(self.width/2, self.height-70, 10, 10)];
    self.pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
    self.pageControl.pageIndicatorTintColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.6];
    [self addSubview:self.pageControl];
    
    //底部toolBar
    self.toolBar = [[EmojiEmoticonsToolBar alloc]initWithFrame:CGRectMake(0, self.height-38, self.width, 38)];
    
    __weak typeof(self) weakSelf = self;
    [self.toolBar setSendEmojiBlock:^{
        
        if (_delegate && [_delegate respondsToSelector:@selector(sendEmoijMessage:)]) {
            
            [weakSelf.delegate sendEmoijMessage:nil];
        }
        
    }];
    
    [weakSelf.toolBar setSwitchEmojiBlock:^(NSInteger index) {
        
        
        [weakSelf switchEmoijType:index];
    }];
    
    [weakSelf addSubview:self.toolBar];
    
    
    
    //emoij面板：默认切换第一个emoij面板
    [self switchEmoijType:0];
    [self.toolBar setBtnIndexSelect:0];
}


- (void)switchEmoijType:(NSInteger)type
{
    NSLog(@"切换表情类型：%ld",type);
    
    
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.scrollView setContentOffset:CGPointZero];
    
    
    self.emoticonsView = [EmojiEmoticonsView emojiEmoticonsView:type scrollView:self.scrollView frame:self.scrollView.bounds];
    
    self.emoticonsView.delegate = self;
    [self.scrollView addSubview:self.emoticonsView];
    
    self.pageControl.currentPage = 0;
    self.pageControl.numberOfPages = self.emoticonsView.page;
    
    
    self.emoticonsView.width = self.emoticonsView.page * self.scrollView.width;
    
    
    self.scrollView.contentSize = CGSizeMake(self.scrollView.bounds.size.width*(self.emoticonsView.page), 0);
    
}



#pragma mark — UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    NSInteger page = scrollView.contentOffset.x/self.width;
    self.pageControl.currentPage = page;
    
}

#pragma mark — EmojiEmticonsViewDelegate

//添加emoij
- (void)addEmoij:(NSString *)emoij isDeleteLastEmoij:(BOOL)isDeleteLastEmoij
{
    if (_delegate && [_delegate respondsToSelector:@selector(addEmoij:isDeleteLastEmoij:)]) {
        
        [_delegate addEmoij:emoij isDeleteLastEmoij:isDeleteLastEmoij];
    }
}



//发送非emoij图片
- (void)sendEmotionImage:(NSString *)localPath emotionType:(EmotionType)emotionType
{
    if (_delegate && [_delegate respondsToSelector:@selector(sendEmotionImage:emotionType:)]) {
        
        [_delegate sendEmotionImage:localPath emotionType:emotionType];;
    }
}


@end
