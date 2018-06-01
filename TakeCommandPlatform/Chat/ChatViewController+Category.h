//
//  ChatViewController+Category.h
//  TakeCommandPlatform
//
//  Created by jyd on 2018/3/6.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import "ChatViewController.h"
#import "PhotoManager.h"
@interface ChatViewController (Category)

///相册选择
- (void)pickerPhotoCompletion:(DidFinishTakeMediaCompletionBlock)completion;

@end
