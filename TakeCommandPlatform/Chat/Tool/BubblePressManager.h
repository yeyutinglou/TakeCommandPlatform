//
//  BubblePressManager.h
//  TakeCommandPlatform
//
//  Created by jyd on 2018/3/9.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatMessageModel.h"
#import "MLEmojiLabel.h"
@interface BubblePressManager : NSObject

singleton_interface(BubblePressManager)

//点击photoBubble,大图浏览图片
- (void)photoBrow:(ChatMessageModel *)message photo:(UIImageView *)photo;

//点击audioBubble,播放或暂停语音播放
- (void)audioPlayOrStop:(ChatMessageModel *)message finishPlay:(void(^)(NSString *url))finishPlay;

//点击videoBubble,浏览视频
- (void)videoPlay:(ChatMessageModel *)message;


//点击locationBubble,浏览地图
- (void)locationMap:(ChatMessageModel *)message viewController:(UIViewController *)controller;

//双击纯文本
- (void)viewTextContent:(ChatMessageModel *)message;

//点击文本中link链接处理
- (void)linkHandle:(NSString *)link type:(MLEmojiLabelLinkType)type;
@end
