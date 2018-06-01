//
//  ChatViewController+Category.m
//  TakeCommandPlatform
//
//  Created by jyd on 2018/3/6.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import "ChatViewController+Category.h"

@implementation ChatViewController (Category)

- (void)pickerPhotoCompletion:(DidFinishTakeMediaCompletionBlock)completion
{
    [[PhotoManager sharedPhotoManager] showPickerViewControllerSourceType:UIImagePickerControllerSourceTypePhotoLibrary onViewController:self completion:^(MediaType mediaType, NSData *data) {
        completion ? completion(mediaType, data) : nil;
    }];
}

@end
