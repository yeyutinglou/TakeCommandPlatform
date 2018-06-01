//
//  CustomSearchBar.m
//  TakeCommandPlatform
//
//  Created by jyd on 2017/12/15.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import "CustomSearchBar.h"
@interface CustomSearchBar () <UITextFieldDelegate>

// placeholder 和icon 和 间隙的整体宽度
@property (nonatomic, assign) CGFloat placeholderWidth;

@end

// icon宽度
static CGFloat const searchIconW = 20.0;
// icon与placeholder间距
static CGFloat const iconSpacing = 10.0;
// 占位文字的字体大小
static CGFloat const placeHolderFont = 15.0;
@implementation CustomSearchBar


- (void)layoutSubviews {
    [super layoutSubviews];
    // 设置背景图片
    UIImage *backImage = [[UIImage alloc] init];
    [self setBackgroundImage:backImage];
    self.barTintColor = [UIColor whiteColor];

    for (UIView *view in [self.subviews lastObject].subviews) {
        if ([view isKindOfClass:[UITextField class]]) {
            UITextField *field = (UITextField *)view;
            // 重设field的frame
            field.frame = self.bounds;
            [field setBackgroundColor:[UIColor whiteColor]];
           
            field.layer.borderColor = RGB(223, 223, 223).CGColor;
            field.layer.borderWidth = 1;
            
            // 设置占位文字字体颜色
            [field setValue:[UIColor colorWithRed:156/255.0 green:156/255.0 blue:156/255.0 alpha:1] forKeyPath:@"_placeholderLabel.textColor"];
            [field setValue:[UIFont systemFontOfSize:placeHolderFont] forKeyPath:@"_placeholderLabel.font"];
            
            if (@available(iOS 11.0, *)) {
                // 先默认居中placeholder
                [self setPositionAdjustment:UIOffsetMake((field.frame.size.width-self.placeholderWidth)/2, 0) forSearchBarIcon:UISearchBarIconSearch];
            }
        }
    }
}

// 开始编辑的时候重置为靠左
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    // 继续传递代理方法
    if ([self.delegate respondsToSelector:@selector(searchBarShouldBeginEditing:)]) {
        [self.delegate searchBarShouldBeginEditing:self];
    }
    if (@available(iOS 11.0, *)) {
        [self setPositionAdjustment:UIOffsetZero forSearchBarIcon:UISearchBarIconSearch];
    }
    return YES;
}
// 结束编辑的时候设置为居中
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    if ([self.delegate respondsToSelector:@selector(searchBarShouldEndEditing:)]) {
        [self.delegate searchBarShouldEndEditing:self];
    }
    if (@available(iOS 11.0, *)) {
        [self setPositionAdjustment:UIOffsetMake((textField.frame.size.width-self.placeholderWidth)/2, 0) forSearchBarIcon:UISearchBarIconSearch];
    }
    return YES;
}

// 计算placeholder、icon、icon和placeholder间距的总宽度
- (CGFloat)placeholderWidth {
    if (!_placeholderWidth) {
        CGSize size = [self.placeholder boundingRectWithSize:CGSizeMake(MAXFLOAT, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:placeHolderFont]} context:nil].size;
        _placeholderWidth = size.width + iconSpacing + searchIconW;
    }
    return _placeholderWidth;
}


@end
