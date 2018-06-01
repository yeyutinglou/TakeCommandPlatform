//
//  CacheManager.m
//  TakeCommandPlatform
//
//  Created by jyd on 2018/3/6.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import "CacheManager.h"

@implementation CacheManager
singleton_implementation(CacheManager)

- (void)saveMediaWithType:(MessageBodyType)type fileData:(NSData *)fileData completion:(void (^)(NSString *))completion
{
    NSString *mediaPath = nil;
    switch (type) {
        case MessageBodyTypePhoto:
        {
            mediaPath = [self savePathForType:MessageBodyTypePhoto];
        }
            break;
        case MessageBodyTypeVideo:
        {
            mediaPath = [self savePathForType:MessageBodyTypeVideo];
        }
            break;
        case MessageBodyTypeVoice:
        {
            mediaPath = [self savePathForType:MessageBodyTypeVoice];
        }
            break;
            
        default:
            break;
    }
    
    [fileData writeToFile:mediaPath atomically:YES];
    completion ? completion(mediaPath) : nil;
}

- (NSString *)savePathForType:(MessageBodyType)type
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"YYYY-MM-dd hh:mm:ss";
    NSString *dateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    
    NSString *rootPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).firstObject;
    
    NSString *meidaPath = nil;
    switch (type) {
            
        case MessageBodyTypeText:
            break;
        case MessageBodyTypeLocation:
            break;
        case MessageBodyTypePhoto: {
            
            //数据格式待定：jpg/gif/tiff
            meidaPath = [[rootPath stringByAppendingPathComponent:dateStr]stringByAppendingString:@"picture"];
            break;
        }
        case MessageBodyTypeVideo: {
            meidaPath = [[rootPath stringByAppendingPathComponent:dateStr]stringByAppendingString:@"video.mov"];
            break;
        }
        case MessageBodyTypeVoice: {
            meidaPath = [[rootPath stringByAppendingPathComponent:dateStr]stringByAppendingString:@"voice.m4a"];
            break;
        }
            
    }
    
    return meidaPath;
}
@end
