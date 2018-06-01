//
//  BadgeButton.m
//  TakeCommandPlatform
//
//  Created by jyd on 2017/12/11.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import "BadgeButton.h"

@implementation BadgeButton

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
//        [self setBackgroundImage:[UIImage imageWithColor:[UIColor redColor]] forState:UIControlStateNormal];
        self.hidden = YES;
        self.userInteractionEnabled = NO;
        self.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    
    return self;
}

-(void)setBadgeValue:(NSString *)badgeValue
{

    _badgeValue = [badgeValue copy];
    
    if(badgeValue && ![badgeValue isEqualToString:@"0"]){
        self.hidden=NO;
        //设置文字
        [self setTitle:badgeValue forState:UIControlStateNormal];
       
        //设置frame
        CGRect frame = self.frame;
        CGFloat badgeW = self.currentBackgroundImage.size.width;
//        CGFloat badgeH = self.currentBackgroundImage.size.height;
        
        //如果按钮的长度大于1，则按照字符的长度计算按钮的宽度
        if (self.badgeValue.length > 1)
        {
            //计算文字大小，参数一定要符合相应的字体和大小
            CGSize badgeSize = [self.badgeValue sizeWithAttributes:@{NSFontAttributeName: self.titleLabel.font}];
            badgeW = badgeSize.width + 5;
        }
        
        frame.size.width  = badgeW;
        frame.size.height = badgeW;
        
//        self.frame = frame;
//        self.layer.masksToBounds = YES;
//        self.layer.cornerRadius = badgeW/2;
        
    }else{
        self.hidden=YES;
    }
}


@end
