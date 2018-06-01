//
//  BubblePressManager.m
//  TakeCommandPlatform
//
//  Created by jyd on 2018/3/9.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import "BubblePressManager.h"
#import "IDMPhotoBrowser.h"
#import "AudioPlayManager.h"
#import "VideoPlayViewController.h"
#import "MapLocationViewController.h"
#import "BaseNavigationController.h"
#import "WebViewController.h"
@interface BubblePressManager ()

@property(nonatomic,strong) UIWindow *keyWindow;

@end
@implementation BubblePressManager

singleton_implementation(BubblePressManager)



//点击photoBubble,大图浏览图片
- (void)photoBrow:(ChatMessageModel *)message photo:(UIImageView *)photo
{
    //默认浏览当前照片
    NSArray *imageUrlArray = nil;
    
    imageUrlArray =  (message.localPhotoPath?[@[message.localPhotoPath]mutableCopy] :[@[message.thumbnailUrl]mutableCopy]);
    IDMPhotoBrowser *photoVc = [[IDMPhotoBrowser alloc] initWithPhotoURLs:imageUrlArray];
    UIViewController *rootController = [self.keyWindow rootViewController];
    [rootController presentViewController:photoVc animated:NO completion:nil];
    
}

//点击audioBubble,播放或暂停语音播放
- (void)audioPlayOrStop:(ChatMessageModel *)message finishPlay:(void(^)(NSString *url))finishPlay
{
    NSURL *url = nil;
    
    //音频不存在网络播放，完全下载成功后再插入消息ui中的
    url = [NSURL fileURLWithPath:message.voicePath];
    
    if (message.isPlaying) {
        [[AudioPlayManager sharedAudioPlayManager]playAudioWithFileUrl:url finishPlay:^(NSString *url) {
            finishPlay ? finishPlay(url) : nil;
        }];
    }else{
        [[AudioPlayManager sharedAudioPlayManager]pauseAudioWithFileUrl:url];
    }
    
}




//点击videoBubble,浏览视频
- (void)videoPlay:(ChatMessageModel *)message
{
    UIViewController *rootController = [self.keyWindow rootViewController];
    
    
    VideoPlayViewController *videoPlayVc = [[VideoPlayViewController alloc]init];
    
    //视频可能没有完全被下载，未下载完前使用网络播放，下载后用本地播放
    
    
    if (!message.isVideoCache) {
        NSLog(@"视频正在下载中，正使用网络播放");
        videoPlayVc.videoURL = [NSURL URLWithString:message.videoUrl];
    }else{
        NSLog(@"视频已下载完，使用本地播放");
        videoPlayVc.videoURL = [NSURL fileURLWithPath:message.locationVideoPath];
    }
    
    [rootController presentViewController:videoPlayVc animated:NO completion:nil];
    
}


//点击locationBubble,浏览地图
- (void)locationMap:(ChatMessageModel *)message viewController:(UIViewController *)controller
{
    MapLocationViewController *mapVc = [[MapLocationViewController alloc]init];
    mapVc.mapType = MapTypePosition;
    mapVc.location = message.location;
    
    controller.navigationController ? [controller.navigationController pushViewController:mapVc animated:YES] : nil;
    
}

//双击纯文本,浏览
- (void)viewTextContent:(ChatMessageModel *)message
{
    
}


//点击locationBubble,浏览地图
- (void)linkHandle:(NSString *)link type:(MLEmojiLabelLinkType)type
{
    switch (type) {
        case MLEmojiLabelLinkTypeURL: {
            NSLog(@"点击了网址");
            //AlertShow(@"点击了网址");
            WebViewController *webVc = [[WebViewController alloc]init];
            
            UIViewController *rootController = [self.keyWindow rootViewController];
            webVc.url = link;
            [rootController.navigationController pushViewController:webVc animated:YES];
            
            break;
        }
        case MLEmojiLabelLinkTypeEmail: {
            NSLog(@"点击了邮箱");
            AlertShow(@"点击的可能是个邮箱");
            break;
        }
        case MLEmojiLabelLinkTypePhoneNumber: {
            NSLog(@"点击了电话");
            AlertShow(@"点击了电话");
            break;
        }
        case MLEmojiLabelLinkTypeAt: {
            NSLog(@"点击了@");
            break;
        }
        case MLEmojiLabelLinkTypePoundSign: {
            //NSLog(@"点击了网址");
            break;
        }
    }
}




//lazy
- (UIWindow *)keyWindow
{
    if(_keyWindow == nil)
    {
        _keyWindow = [[UIApplication sharedApplication] keyWindow];
    }
    
    return _keyWindow;
}


@end



