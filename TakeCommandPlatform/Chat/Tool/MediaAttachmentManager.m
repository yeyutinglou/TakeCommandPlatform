//
//  MediaAttachmentManager.m
//  TakeCommandPlatform
//
//  Created by jyd on 2018/3/6.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import "MediaAttachmentManager.h"
#import "CacheManager.h"
#define KImageScale 0.9
@implementation MediaAttachmentManager

singleton_implementation(MediaAttachmentManager)

- (void)imageHandle:(NSData *)data completionCache:(void (^)(NSString *))completionCache
{
    UIImage *image = [UIImage thumbWithImage:[UIImage imageWithData:data] scale:KImageScale];
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    [[CacheManager sharedCacheManager] saveMediaWithType:MessageBodyTypePhoto fileData:imageData completion:^(NSString *mediaPath) {
        completionCache ? completionCache(mediaPath) :nil;
    }];
}

- (void)audioHandle:(NSData *)data completionCache:(void (^)(NSString *))completionCache
{
    [[CacheManager sharedCacheManager] saveMediaWithType:MessageBodyTypeVoice fileData:data completion:^(NSString *mediaPath) {
        completionCache ? completionCache(mediaPath) : nil;
    }];
}

-(void)videoHandle:(NSData *)data completionCache:(void (^)(NSString *, NSString *))completionCache
{
    [[CacheManager sharedCacheManager] saveMediaWithType:MessageBodyTypeVideo fileData:data completion:^(NSString *videoPath) {
        UIImage *thumbImage = [UIImage videoThumbImage:[NSURL fileURLWithPath:videoPath]];
        UIImage *mergeImage = [UIImage addImage:thumbImage addMsakImage:kChatImage(@"play@2x") maskRect:CGRectMake(thumbImage.size.width/2-45, thumbImage.size.height/2-45, 90, 90)];
        NSData *imageData = UIImageJPEGRepresentation(mergeImage, 1.0);
        [[CacheManager sharedCacheManager] saveMediaWithType:MessageBodyTypePhoto fileData:imageData completion:^(NSString *videoThumbPath) {
            completionCache ? completionCache(videoPath, videoThumbPath) : nil;
        }];
        
    }];
}
@end
