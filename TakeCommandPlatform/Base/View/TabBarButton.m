//
//  TabBarButton.m
//  TakeCommandPlatform
//
//  Created by jyd on 2017/12/11.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import "TabBarButton.h"
#import "BadgeButton.h"
#define tabbarButtonImageRatio 0.65

@interface TabBarButton ()

@property (nonatomic,weak) BadgeButton *badgeButton;  //提醒数字按钮

@end

@implementation TabBarButton

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        //设置一些初始化状态
        self.imageView.contentMode    = UIViewContentModeCenter;
//        self.titleLabel.contentMode = UIViewContentModeBottom;
//        self.titleLabel.textAlignment = NSTextAlignmentCenter;
//        self.titleLabel.font = [UIFont systemFontOfSize:13];
//        [self setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//        [self setTitleColor:[UIColor colorWithRed:0/255.0 green:127/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateSelected];
        
        
        
        //添加自定义的badgeButton
        [self setupBadgeButton];
    }
    
    return self;
}

//添加提醒文字
-(void)setupBadgeButton
{
    BadgeButton *badgeButton = [[BadgeButton alloc]init];
    badgeButton.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin;
    self.badgeButton = badgeButton;
    [self addSubview:badgeButton];
}

-(void)setHighlighted:(BOOL)highlighted
{
    
}

/**
 *  设定自定义的按钮的图片尺寸、位置
 */
-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    CGFloat imageX = 0;
    CGFloat imageY = 0;
    CGFloat imageW = contentRect.size.width;
    CGFloat imageH = contentRect.size.height ;
    
    return CGRectMake(imageX, imageY, imageW, imageH);
}


/**
 *  设定自定义的按钮的title的尺寸、位置
 */
//-(CGRect)titleRectForContentRect:(CGRect)contentRect
//{
//    CGFloat titleX = 0;
//    CGFloat titleY = contentRect.size.height/2; //contentRect.size.height * ZJImageRatio;
//    CGFloat titleW = contentRect.size.width;
//    CGFloat titleH = contentRect.size.height - titleY;
//
//    return CGRectMake(titleX, titleY, titleW, titleH);
//}

-(void)setItem:(UITabBarItem *)item
{
    _item = item;
    
    //KVO事件监听
    [item addObserver:self forKeyPath:@"badgeValue" options:0 context:nil];
    [item addObserver:self forKeyPath:@"imageName" options:0 context:nil];
    [item addObserver:self forKeyPath:@"selectedImageName" options:0 context:nil];
    [item addObserver:self forKeyPath:@"title" options:0 context:nil];
    
    //初始化调用,为添加的自定义按钮设置属性
    [self observeValueForKeyPath:nil ofObject:nil change:nil context:nil];
    
}

-(void)dealloc
{
    [self.item removeObserver:self forKeyPath:@"badgeValue"];
    [self.item removeObserver:self forKeyPath:@"imageName"];
    [self.item removeObserver:self forKeyPath:@"selectedImageName"];
    [self.item removeObserver:self forKeyPath:@"title"];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"tabbarItemChange" object:nil];
    //1.设置文字
//    [self setTitle:self.item.title forState:UIControlStateNormal];
//    [self setTitle:self.item.title forState:UIControlStateSelected];
    //2.设置图片
    [self setImage:self.item.image forState:UIControlStateNormal];
    [self setImage:self.item.selectedImage forState:UIControlStateSelected];
    //3.设置提醒数字
    NSString *badgeValue;
    if (self.item.badgeValue.length >= 3) {
        badgeValue = @"···";
    } else {
        badgeValue = self.item.badgeValue;
    }
    self.badgeButton.badgeValue = badgeValue;
    //4.设置位置和尺寸
    CGFloat badgeY = 5;
    CGFloat badgeX = self.frame.size.width - self.badgeButton.frame.size.width - 30;
    
    CGRect badgeFrame = self.badgeButton.frame;
    badgeFrame.origin.x = badgeX;
    badgeFrame.origin.y = badgeY;
    self.badgeButton.frame = badgeFrame;
    
    
}

@end
