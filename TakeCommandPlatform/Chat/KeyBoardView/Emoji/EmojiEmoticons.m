//
//  EmojiEmoticons.m
//  TakeCommandPlatform
//
//  Created by jyd on 2018/2/5.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import "EmojiEmoticons.h"

@implementation EmojiEmoticons

+ (NSArray *)allEmoticons {
    NSMutableArray *array = [NSMutableArray new];
    for (int i=0x1F600; i<=0x1F64F; i++) {
        if (i < 0x1F641 || i > 0x1F644) {
            [array addObject:[Emoji emojiWithCode:i]];
        }
    }
    return array;
}

@end
