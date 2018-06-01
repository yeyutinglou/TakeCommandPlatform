//
//  Emoji.m
//  TakeCommandPlatform
//
//  Created by jyd on 2018/2/5.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import "Emoji.h"
#import "EmojiEmoticons.h"

@implementation Emoji

+ (NSString *)emojiWithCode:(int)code {
    int sym = EMOJI_CODE_TO_SYMBOL(code);
    return [[NSString alloc] initWithBytes:&sym length:sizeof(sym) encoding:NSUTF8StringEncoding];
}
+ (NSArray *)allEmoji {
    NSMutableArray *array = [NSMutableArray new];
    [array addObjectsFromArray:[EmojiEmoticons allEmoticons]];
//    [array addObjectsFromArray:[EmojiMapSymbols allMapSymbols]];
//    [array addObjectsFromArray:[EmojiPictographs allPictographs]];
//    [array addObjectsFromArray:[EmojiTransport allTransport]];
    
    return array;
}

@end
