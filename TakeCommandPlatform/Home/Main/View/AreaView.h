//
//  AreaView.h
//  TakeCommandPlatform
//
//  Created by jyd on 2017/12/13.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AreaDelegate <NSObject>

///业务区域按钮点击
- (void)businessAreaBtnClick:(UIButton *)sender;

@end


@interface AreaView : UIView

/** delegate */
@property (nonatomic,weak) id<AreaDelegate> delegate;

@end
