//
//  PhotoManager.m
//  TakeCommandPlatform
//
//  Created by jyd on 2018/3/6.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import "PhotoManager.h"
#import <MobileCoreServices/MobileCoreServices.h>
@interface PhotoManager ()<UINavigationBarDelegate, UIImagePickerControllerDelegate>

/** block */
@property (nonatomic, copy) DidFinishTakeMediaCompletionBlock didFinishTakeMediaCompletion;

/** imagePicker */
@property (nonatomic, strong) UIImagePickerController *imagePickerController;


@end

@implementation PhotoManager
singleton_implementation(PhotoManager)

- (void)showPickerViewControllerSourceType:(UIImagePickerControllerSourceType)sourceType onViewController:(UIViewController *)viewController completion:(DidFinishTakeMediaCompletionBlock)completion
{
    if (![UIImagePickerController isSourceTypeAvailable:sourceType]) {
        completion(MediaTypeUnknow, nil);
        return;
    }
    
    self.didFinishTakeMediaCompletion = completion;
    self.imagePickerController = [[UIImagePickerController alloc] init];
    self.imagePickerController.allowsEditing = NO;
    self.imagePickerController.delegate = (id<UINavigationControllerDelegate, UIImagePickerControllerDelegate>)self;
    self.imagePickerController.sourceType = sourceType;
//    if (sourceType == UIImagePickerControllerSourceTypeCamera)
//    {
//        self.imagePickerController.mediaTypes =  [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
//    }
    
    [viewController presentViewController:self.imagePickerController animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    NSString* mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
    {
        
        //获取图片对象
        UIImage* image = [info objectForKey:UIImagePickerControllerOriginalImage];
        NSData *imageData = UIImageJPEGRepresentation(image, 1);
        self.didFinishTakeMediaCompletion ? self.didFinishTakeMediaCompletion(MediaTypePhoto,imageData) : nil;
        
    }
    else if ([mediaType isEqualToString:(NSString *)kUTTypeMovie])
    {
        //获取视频文件的url
        NSURL* mediaURL = [info objectForKey:UIImagePickerControllerMediaURL];
        
        
        //1.保存视频到相册
        NSData *videoData = [NSData dataWithContentsOfURL:mediaURL];
        self.didFinishTakeMediaCompletion ? self.didFinishTakeMediaCompletion(MediaTypeVideo,videoData) : nil;
        
    }
    [self dismissPickerViewController:picker];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissPickerViewController:picker];
}

- (void)dismissPickerViewController:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
@end
