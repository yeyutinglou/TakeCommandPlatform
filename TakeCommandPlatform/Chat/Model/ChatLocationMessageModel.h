//
//  ChatLocationMessageModel.h
//  TakeCommandPlatform
//
//  Created by jyd on 2018/3/5.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import "ChatMessageModel.h"

@interface ChatLocationMessageModel : ChatMessageModel

+ (instancetype)localPositionPhoto:(NSString *)localPositionPhotoPath
                           address:(NSString *)address
                          location:(CLLocation *)location
                          username:(NSString *)username
                         timeStamp:(NSString *)timeStamp
                          isSender:(BOOL)isSender;

@end
