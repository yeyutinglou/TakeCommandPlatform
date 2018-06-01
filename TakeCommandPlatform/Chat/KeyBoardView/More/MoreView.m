//
//  MoreView.m
//  TakeCommandPlatform
//
//  Created by jyd on 2018/2/7.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import "MoreView.h"
#import "MoreViewBtn.h"

#define  KMargin 10

#define  KColumNum 4

#define  KRowNum 2

@interface MoreView () <UIScrollViewDelegate>

/** ScrollView */
@property (nonatomic, strong) UIScrollView *scrollView;

/** pageControl */
@property (nonatomic, strong) UIPageControl *pageControl;



@end

@implementation MoreView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        [self setupUI];
        self.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.1];
        
        
        
    }
    return self;
}

- (void)setupUI
{
    NSArray *normalImageArray = @[
                                  @"chatBar_colorMore_photo@2x",
                                  @"chatBar_colorMore_location@2x",
                                  @"chatBar_colorMore_camera@2x",
                                  @"chatBar_colorMore_audioCall@2x",
                                  @"chatBar_colorMore_videoCall@2x",
                                  
                                  ];
    NSArray *hightImageArray = @[
                                 @"chatBar_colorMore_photoSelected@2x",
                                 @"chatBar_colorMore_locationSelected@2x",
                                 @"chatBar_colorMore_cameraSelected@2x",
                                 @"chatBar_colorMore_audioCallSelected@2x",
                                 @"chatBar_colorMore_videoCallSelected@2x",
                                 
                                 
                                 ];
    
    NSArray *titleArray = @[
                            @"照片",
                            @"位置",
                            @"拍照",
                            @"语音电话",
                            @"视频通话",
                            
                            ];
    
    self.scrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
    self.scrollView.contentSize = CGSizeMake(self.width*2, 0);
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    self.scrollView.pagingEnabled = YES;
    [self addSubview:self.scrollView];
    
    
    
    CGFloat width = (self.width - KMargin*(KColumNum+1))/KColumNum;
    CGFloat height = 85;
    for (int i = 0; i < titleArray.count; i++) {
        NSInteger page = i/(KRowNum*KColumNum);
        MoreViewBtn *btn = [[MoreViewBtn alloc] init];
        btn.frame = [self getFrameWithColumesOfPerRow:KColumNum rowsOfPerColumn:KRowNum itemWidth:width itemHeight:height marginX:KMargin maginY:KMargin atIndex:i atPage:page scrollView:self.scrollView];
        [btn setImage:kChatImage(normalImageArray[i])  forState:UIControlStateNormal];
        [btn setImage:kChatImage(hightImageArray[i]) forState:UIControlStateHighlighted];
        [btn setTitle:titleArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(btnClickAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:btn];
        btn.tag = i;
    }
    
    
    
    
    self.pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(self.width/2, self.height-15, 10, 10)];
    self.pageControl.numberOfPages = self.scrollView.contentSize.width/self.width;
    self.pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
    self.pageControl.pageIndicatorTintColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.6];
    [self addSubview:self.pageControl];
    
}

#pragma mark — UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger page = scrollView.contentOffset.x/self.width;
    self.pageControl.currentPage = page;
}

/**
 *  @brief 格式布局
 *
 *  @param columesOfPerRow 多少列
 *  @param rowsOfPerColumn 多少行
 *  @param itemWidth       格宽
 *  @param itemHeight      格高
 *  @param marginX         格子间左右间隙
 *  @param marginY         格子间上下间隙
 *  @param index           格子所在索引
 *  @param page            格子所在页码
 *  @param scrollView      格子所在scrollview
 *
 *  @return <#return value description#>
 */
- (CGRect)getFrameWithColumesOfPerRow:(NSInteger)columesOfPerRow
                      rowsOfPerColumn:(NSInteger)rowsOfPerColumn
                            itemWidth:(CGFloat)itemWidth
                           itemHeight:(NSInteger)itemHeight
                              marginX:(CGFloat)marginX
                               maginY:(CGFloat)marginY
                              atIndex:(NSInteger)index
                               atPage:(NSInteger)page
                           scrollView:(UIScrollView *)scrollView
{
    CGRect itemFrame = CGRectMake((index % columesOfPerRow) * (itemWidth + marginX) + marginX + (page * CGRectGetWidth(scrollView.bounds)), ((index / columesOfPerRow) - rowsOfPerColumn * page) * (itemHeight + marginY) + marginY, itemWidth, itemHeight);
    return itemFrame;
}



- (void)btnClickAction:(UIButton *)sender
{
    if (_delegate && [_delegate respondsToSelector:@selector(moreViewClick:)]) {
        [_delegate moreViewClick:sender.tag];
    }
}

@end
