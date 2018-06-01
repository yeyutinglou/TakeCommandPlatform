//
//  PhotoManager.h
//  TakeCommandPlatform
//
//  Created by jyd on 2018/3/6.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, MediaType) {
    MediaTypePhoto,
    MediaTypeVideo,
    MediaTypeUnknow,
};

typedef void(^DidFinishTakeMediaCompletionBlock)(MediaType mediaType, NSData *data);

@interface PhotoManager : NSObject

singleton_interface(PhotoManager)

- (void)showPickerViewControllerSourceType:(UIImagePickerControllerSourceType)sourceType onViewController:(UIViewController *)viewController completion:(DidFinishTakeMediaCompletionBlock)completion;
@end
