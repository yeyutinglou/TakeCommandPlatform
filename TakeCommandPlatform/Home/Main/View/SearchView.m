//
//  SearchView.m
//  TakeCommandPlatform
//
//  Created by jyd on 2017/12/13.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import "SearchView.h"

@interface SearchView ()

@property (weak, nonatomic) IBOutlet UIButton *searchBtn;

@end

@implementation SearchView

- (instancetype)init
{
    SearchView *searchView;
    if (!searchView) {
        searchView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return searchView;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    _searchBtn.layer.borderColor = RGB(161, 161, 161).CGColor;
    _searchBtn.layer.borderWidth = 1.0f;
}


- (IBAction)studentSearchClick:(UIButton *)sender {
    if (_delegate &&[_delegate respondsToSelector:@selector(jumpStudentSearchVC)]) {
        [_delegate jumpStudentSearchVC];
    }
}


@end
