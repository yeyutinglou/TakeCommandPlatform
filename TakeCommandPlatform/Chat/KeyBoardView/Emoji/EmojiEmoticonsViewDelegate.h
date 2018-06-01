//
//  EmojiEmoticonsViewDelegate.h
//  TakeCommandPlatform
//
//  Created by jyd on 2018/2/27.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol EmojiEmoticonsViewDelegate <NSObject>

/**
 *  @brief 点击emoij表情，增加内容，或删除最后一个emoij
 *
 *  @param emoij             <#emoij description#>
 *  @param isDeleteLastEmoij <#isDeleteLastEmoij description#>
 */
- (void)addEmoij:(NSString *)emoij isDeleteLastEmoij:(BOOL)isDeleteLastEmoij;

/**
 *  @brief 发送emoij表情
 *
 *  @param text <#text description#>
 */
- (void)sendEmoijMessage:(NSString *)text;

/**
 *  @brief 发送浪小花等图片，扩展功能
 *
 *  @param imagePath <#imagePath description#>
 */
- (void)sendEmotionImage:(NSString *)localPath emotionType:(EmotionType)emotionType;

@end
