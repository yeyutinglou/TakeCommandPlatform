//
//  PageAreaView.m
//  TakeCommandPlatform
//
//  Created by jyd on 2018/3/21.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import "PageAreaView.h"
#import "AreaView.h"
#import "AreaBtn.h"
@interface PageAreaView ()<UIScrollViewDelegate>

/** scrollView */
@property (nonatomic, strong) UIScrollView *scrollView;

/** pageControl */
@property (nonatomic, strong) UIPageControl *pageControl;

/** target */
@property (nonatomic, weak) id target;

@property(nonatomic) SEL action;

@end

@implementation PageAreaView


- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];

    }
    return self;
}




-(void)layoutSubviews
{
    self.scrollView.frame = CGRectMake(0, 20, self.width, self.height - 30);
    [self addSubview:self.scrollView];
    
    float btnW = 60;
    float btnH = 80;
    float left = 20;
    float margin = (self.width - 5 * btnW - 2 * left) /4;
    NSArray *nameArr = @[@"电子地图", @"通知公告", @"工作安排", @"巡考分析", @"资料库"];
    NSArray *imageArr = @[@"map", @"info", @"job", @"patrol", @"material"];
    for (int i = 0; i < nameArr.count; i++) {
        AreaBtn *area = [[AreaBtn alloc] init];
        area.frame = CGRectMake(left + i * (btnW + margin), 0, btnW, btnH);
        area.tag = i;
        [area setTitle:nameArr[i] forState:UIControlStateNormal];
        [area setImage:[UIImage imageNamed:imageArr[i]] forState:UIControlStateNormal];
        [area addTarget:self action:@selector(didTouch:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:area];
    }
    [self.scrollView setContentSize:CGSizeMake(2 * self.width, 0)];
    
    self.pageControl.frame = CGRectMake(self.width /2, self.height - 20, 10, 10);
    [self addSubview:self.pageControl];
}

#pragma mark — UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    NSInteger page = scrollView.contentOffset.x/self.width;
    self.pageControl.currentPage = page;
    
}

#pragma mark — Touch
- (void)didTouch:(UIButton *)sender
{
    IMP _imp = [self.target methodForSelector:self.action];
    BOOL (*func)(id, SEL, NSInteger) = (void *)_imp;
    BOOL result = func(self.target, self.action, sender.tag);
    if (!result) {
        return;
    }
}

- (void)addTarget:(id)target action:(SEL)action
{
    self.target = target;
    self.action = action;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.currentPageIndicatorTintColor = [UIColor grayColor];
        _pageControl.pageIndicatorTintColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.6];
        _pageControl.numberOfPages = 2;
        _pageControl.currentPage = 0;
    }
    return _pageControl;
    
}

@end
