//
//  EmojiEmoticonsToolBar.m
//  TakeCommandPlatform
//
//  Created by jyd on 2018/2/27.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import "EmojiEmoticonsToolBar.h"

#define emojiNum 8

@interface EmojiEmoticonsToolBar ()

/** scrollView */
@property (nonatomic, strong) UIScrollView *scrollView;

/** 发送按钮 */
@property (nonatomic, strong) UIButton *sendBtn;



@end

@implementation EmojiEmoticonsToolBar

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor lightGrayColor]colorWithAlphaComponent:0.3];
        [self setupUI];
    }
    return self;
}

- (void)setupUI
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width - 80, self.height)];
    [self addSubview:self.scrollView];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    
    CGFloat width = 80;
    CGFloat height = self.height;
    for (NSInteger i = 0; i < emojiNum; i++) {
        
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(i*width, 0, width, height)];
        [btn setTitle:[NSString stringWithFormat:@"表情%ld",i] forState:UIControlStateNormal];
        [self.scrollView addSubview:btn];
        [btn addTarget:self action:@selector(switchEmoijAction:) forControlEvents:UIControlEventTouchUpInside];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        btn.titleLabel.font = [UIFont systemFontOfSize:14];
        btn.tag = i;
        btn.layer.borderColor = [UIColor lightGrayColor].CGColor;
        btn.layer.borderWidth = 0.8;
        
        
    }
    
    self.scrollView.contentSize = CGSizeMake(width*emojiNum, 0);
    
    
    self.sendBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.frame)-80, 0, 80, self.frame.size.height)];
    [self.sendBtn setBackgroundColor:[UIColor blueColor]];
    [self.sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [self.sendBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.sendBtn addTarget:self action:@selector(sendClickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.sendBtn];
}

- (void)switchEmoijAction:(UIButton *)btn
{
    
    if (btn.isSelected) {
        return;
    }
    for (UIView *subView in self.scrollView.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            
            UIButton *btn = (UIButton *)subView;
            btn.selected = NO;
            
        }
    }
    
    btn.selected = YES;
    
    self.switchEmojiBlock ? self.switchEmojiBlock(btn.tag):nil;
    
}

- (void)sendClickAction:(UIButton *)btn
{
    self.sendEmojiBlock ? self.sendEmojiBlock() :nil;
}



//默认选中第一个emoij工具选项
- (void)setBtnIndexSelect:(NSInteger)index
{
    
    for (UIView *subView in self.scrollView.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            
            UIButton *btn = (UIButton *)subView;
            if (btn.tag == index) {
                btn.selected = YES;
            }
            
        }
        
    }
}


@end
