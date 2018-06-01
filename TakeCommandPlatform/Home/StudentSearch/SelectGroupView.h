//
//  SelectGroupView.h
//  student_iphone
//
//  Created by jyd on 2017/11/7.
//  Copyright © 2017年 he chao. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol SelectGropViewDelegate <NSObject>

- (void)clickOKBtn:(NSInteger )index;

@end


@interface SelectGroupView : UIView

@property (nonatomic, strong) UITableView *groupTableView;

@property (nonatomic, strong) NSMutableArray *groupArray;

/** delegate */
@property (nonatomic, strong) id<SelectGropViewDelegate> delegate;
@end
