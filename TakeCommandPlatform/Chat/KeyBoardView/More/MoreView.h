//
//  MoreView.h
//  TakeCommandPlatform
//
//  Created by jyd on 2018/2/7.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MoreViewDelegate <NSObject>

- (void)moreViewClick:(MoreViewType)type;
@end

@interface MoreView : UIView

/** delegate */
@property (nonatomic, weak) id <MoreViewDelegate> delegate;

@end
