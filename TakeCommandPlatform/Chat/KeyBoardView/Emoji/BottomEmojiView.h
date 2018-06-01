//
//  BottomEmojiView.h
//  TakeCommandPlatform
//
//  Created by jyd on 2018/2/27.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EmojiEmoticonsViewDelegate.h"

@interface BottomEmojiView : UIView

/** delegate */
@property (nonatomic, weak) id <EmojiEmoticonsViewDelegate> delegate;
@end
