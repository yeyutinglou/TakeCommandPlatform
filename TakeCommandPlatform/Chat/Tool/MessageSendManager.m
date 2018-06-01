//
//  MessageSendManager.m
//  TakeCommandPlatform
//
//  Created by jyd on 2018/3/7.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import "MessageSendManager.h"

@implementation MessageSendManager

+ (void)sendMessage:(ChatMessageModel *)message completion:(void (^)(ChatMessageServiceModel *))completion
{
    //照片，视频，音频消息发送：先将文件上传到对应的图片，视频或音频服务器，获取远程地址url，在进行消息体包装后进行发送
    switch (message.bubbleMessageBodyType) {
        case MessageBodyTypeText:
            break;
        case MessageBodyTypeVoice:
        {
            FileConfig *fileConfig =[FileConfig fileConfigWithUrl:@"" fileData:nil serveName:nil fileName:nil mimeType:nil];
            [NetworkManager uploadFiles:fileConfig progress:^(NSProgress *progress) {
                
            } success:^(id responseObject) {
                NSString *remoteFileUrl = responseObject[@"url"];
                message.imMessage.messageType = MessageBodyTypeVoice;
                message.imMessage.messageBody = remoteFileUrl;
            } failure:^(NSError *error) {
                 NSLog(@"音频上传失败:%@",error.localizedDescription);
            }];
        }
            break;
        case MessageBodyTypePhoto:
        {
            FileConfig *fileConfig =[FileConfig fileConfigWithUrl:@"" fileData:nil serveName:nil fileName:nil mimeType:nil];
            [NetworkManager uploadFiles:fileConfig progress:^(NSProgress *progress) {
                
            } success:^(id responseObject) {
                NSString *remoteFileUrl = responseObject[@"url"];
                
                
                message.imMessage.messageType = MessageBodyTypePhoto;
                message.imMessage.messageBody = remoteFileUrl;
            } failure:^(NSError *error) {
                NSLog(@"图片上传失败:%@",error.localizedDescription);
            }];
        }
            break;
        case MessageBodyTypeVideo:
        {
            FileConfig *fileConfig =[FileConfig fileConfigWithUrl:@"" fileData:nil serveName:nil fileName:nil mimeType:nil];
            [NetworkManager uploadFiles:fileConfig progress:^(NSProgress *progress) {
                
            } success:^(id responseObject) {
                NSString *remoteFileUrl = responseObject[@"url"];
                message.imMessage.messageType = MessageBodyTypeVideo;
                message.imMessage.messageBody = remoteFileUrl;
            } failure:^(NSError *error) {
                NSLog(@"视频上传失败:%@",error.localizedDescription);
            }];
        }
            break;
        case MessageBodyTypeLocation:
        {
             FileConfig *fileConfig =[FileConfig fileConfigWithUrl:@"" fileData:nil serveName:nil fileName:nil mimeType:nil];
            [NetworkManager uploadFiles:fileConfig progress:^(NSProgress *progress) {
                
            } success:^(id responseObject) {
                NSString *remoteFileUrl = responseObject[@"url"];
                message.imMessage.messageType = MessageBodyTypePhoto;
                message.imMessage.messageBody = remoteFileUrl;
            } failure:^(NSError *error) {
                NSLog(@"位置截图上传失败:%@",error.localizedDescription);
            }];
        }
            break;
        default:
            break;
    }
    
    ChatMessageServiceModel *messageService = [[ChatMessageServiceModel alloc]init];
    messageService.messageId = message.messageId;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        message.deliveryState = arc4random_uniform(3);
        completion ? completion(messageService): nil;
    });
}

@end
