//
//  CacheManager.h
//  TakeCommandPlatform
//
//  Created by jyd on 2018/3/6.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatServerDefault.h"
@interface CacheManager : NSObject

singleton_interface(CacheManager)

///保存媒体文件:照片, 音频, 视频
- (void)saveMediaWithType:(MessageBodyType)type fileData:(NSData *)fileData completion:(void(^)(NSString * mediaPath))completion;

///媒体路径
- (NSString *)savePathForType:(MessageBodyType)type;
@end
