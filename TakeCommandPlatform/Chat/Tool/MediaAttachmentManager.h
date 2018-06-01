//
//  MediaAttachmentManager.h
//  TakeCommandPlatform
//
//  Created by jyd on 2018/3/6.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MediaAttachmentManager : NSObject

singleton_interface(MediaAttachmentManager)

///图片处理: 剪裁, 压缩
- (void)imageHandle:(NSData *)data completionCache:(void(^)(NSString *))completionCache;

///音频处理
- (void)audioHandle:(NSData *)data
    completionCache:(void(^)(NSString *))completionCache;


///视频处理
- (void)videoHandle:(NSData *)data
    completionCache:(void(^)(NSString *videoPath,NSString *videoThumbPath))completionCache;

@end
