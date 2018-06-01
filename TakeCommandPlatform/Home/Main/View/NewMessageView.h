//
//  NewMessageView.h
//  TakeCommandPlatform
//
//  Created by jyd on 2017/12/14.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NewMessageDelegate <NSObject>


- (void)didSelectRowFromModel:(id)model;

- (void)lookAllNotice:(NSArray *)arr;


@end

@interface NewMessageView : UIView

/** delegate */
@property (nonatomic,weak) id<NewMessageDelegate> delegate;


- (void)getNewMessageData;
@end
