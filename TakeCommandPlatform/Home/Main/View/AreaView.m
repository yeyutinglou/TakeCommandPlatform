//
//  AreaView.m
//  TakeCommandPlatform
//
//  Created by jyd on 2017/12/13.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import "AreaView.h"

@implementation AreaView

- (instancetype)init
{
    AreaView *areaView;
    if (!areaView) {
        areaView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return areaView;
}
- (IBAction)btnClick:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(businessAreaBtnClick:)]) {
        [_delegate businessAreaBtnClick:sender];
    }
}

@end
