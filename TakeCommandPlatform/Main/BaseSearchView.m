//
//  BaseSearchView.m
//  TakeCommandPlatform
//
//  Created by jyd on 2018/3/20.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import "BaseSearchView.h"

@interface BaseSearchView ()

/** target */
@property (nonatomic, weak) id target;

/** sel */
@property (nonatomic) SEL action;

@end

@implementation BaseSearchView

+ (instancetype)initializeView
{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouch:)];
    tap.numberOfTapsRequired = 1;
    tap.numberOfTouchesRequired = 1;
    [self addGestureRecognizer:tap];
}

- (void)didTouch:(UITapGestureRecognizer *)tap
{
    IMP _imp = [self.target methodForSelector:self.action];
    BOOL (*func)(id, SEL) = (void *)_imp;
    BOOL result = func(self.target, self.action);
    if (!result) {
        return;
    }
}

- (void)addTarget:(id)target action:(SEL)action
{
    self.target = target;
    self.action = action;
}

@end
