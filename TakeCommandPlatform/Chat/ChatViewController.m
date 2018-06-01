//
//  ChatViewController.m
//  TakeCommandPlatform
//
//  Created by jyd on 2017/12/12.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import "ChatViewController.h"
#import "KeyBoardView.h"
#import "ChatMessageModel.h"
#import "ChatPhotoMessageModel.h"
#import "ChatVoiceMessageModel.h"
#import "ChatVideoMessageModel.h"
#import "ChatLocationMessageModel.h"
#import "ChatTextMessageModel.h"
#import "ChatMessageCell.h"
#import "ChatViewController+Category.h"
#import "MediaAttachmentManager.h"
#import "MessageSendManager.h"
#import "XMPPTool.h"
#import "CacheManager.h"
#import "BubblePressManager.h"
@interface ChatViewController ()<UITableViewDelegate, UITableViewDataSource,VoiceRecordingDelegate,MoreViewDelegate,EmojiEmoticonsViewDelegate,ChatMessageCellDelegate, XMPPToolDelegate>

/** tableView */
@property (nonatomic, strong) UITableView *chatTableView;

/** keyBoardView */
@property (nonatomic, strong) KeyBoardView *keyBoardView;

/** chatMessage */
@property (nonatomic, strong) NSMutableArray *chatMessages;

/** lastIndexPatch */
@property (nonatomic, strong) NSIndexPath *lastVoiceIndexPath;

/** lastMessageDate */
@property (nonatomic, copy) NSString *lastMessageDate;




@end

@implementation ChatViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupUI];
}

- (void)setupUI
{
    [self.view addSubview:self.chatTableView];
    [self.view addSubview:self.keyBoardView];
    
    [XMPPTool sharedXMPPTool].delegate = self;
}

- (void)loadDataSource
{
    
}

#pragma mark — UITableViewDataSource / Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.chatMessages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ChatMessageCell *cell = [ChatMessageCell cellWithTableView:tableView indentifier:@"cell"];
    cell.message = self.chatMessages[indexPath.row];
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [ChatMessageCell cellHeight:self.chatMessages[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark — MoreViewClick
- (void)moreViewClick:(MoreViewType)type
{
    switch (type) {
        case MoreViewTypePhotoAblums:
        {
            [self pickerPhotoCompletion:^(MediaType mediaType, NSData *data) {
                [self handleMediaType:mediaType data:data];
            }];
        }
            break;
            
        default:
            break;
    }
}
/**
 *  @brief 发送消息时选相册图片，拍照，视频的媒体内容处理
 *
 *  @param mediaType 媒体类型
 *  @param data      内容
 */
- (void)handleMediaType:(MediaType)mediaType data:(NSData *)data
{
    switch (mediaType) {
        case MediaTypePhoto:
            {
                [[MediaAttachmentManager sharedMediaAttachmentManager] imageHandle:data completionCache:^(NSString *imagePath) {
                    ChatPhotoMessageModel *message = [ChatPhotoMessageModel photo:imagePath thumbnailUrl:nil originPhotoUrl:nil username:nil timeStamp:[NSDate date:[NSDate date] WithFormate:KDateFormate ] isSender:YES];
                    message.avatarUrl = @"";
                    message.isGif = NO;
                    [self sendMessage:message];
                }];
            }
            break;
            
        default:
            break;
    }
}

#pragma mark — SendMessage
- (void)sendMessage:(ChatMessageModel *)message
{
    message.messageId = [NSString stringWithFormat:@"%zd",arc4random_uniform(arc4random_uniform(1000)*arc4random_uniform(1000))];
    //先判断是否加入时间戳
    [self insertTimeMessage:message];
    
    
    
    
    //先加载到视图，再网络业务发送，成功后插入数据库
    
    
    //step1:updateUi
    message.deliveryState = MessageDeliveryStateDelivering;
    [self.chatMessages addObject:message];
    [self.chatTableView reloadData];
    
    //接收消息自动滚动到当前可视区域取消
    
//    //在colleview中因layout布局耗费时间，需要延时
//    if ([message isKindOfClass:[MessageModel class]] &&  message.isSender ) {
//
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.15 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [self.chatCollectionView setContentOffset:CGPointMake(0, self.chatCollectionView.contentSize.height+self.keyBoardView.keyBoardDetalChange-SCREEN_HEIGHT) animated:YES];
//        });
//    }
//
    
    
    
    //服务层数据包装
    message.imMessage.from = @"";
    message.imMessage.to = @"";
    message.messageId = @"";
    
    
    switch (message.bubbleMessageBodyType) {
        case MessageBodyTypeText: {
            
            NSLog(@"messageSend  <Text>:%@",message.text);
            break;
        }
        case MessageBodyTypePhoto: {
            NSLog(@"messageSend <Photo>:%@",message.localPhotoPath);
            break;
        }
        case MessageBodyTypeVideo: {
            NSLog(@"messageSend <Video>:%@",message.videoThumbPhoto);
            break;
        }
        case MessageBodyTypeVoice: {
            NSLog(@"messageSend <Voice>:%@",message.voicePath);
            break;
        }
            
        case MessageBodyTypeLocation: {
            NSLog(@"messageSend <Location>:%@",message.location);
            break;
        }
    }
    
    
    
    
    //消息业务发送
    __block ChatMessageModel *updateMessage = nil;
    [MessageSendManager sendMessage:message completion:^(ChatMessageServiceModel *serviceMessage) {
        
        //定位到ui上已经展示的那条消息，进行消息状态的更新
        for (ChatMessageModel *message in self.chatMessages) {
            
            if ([message isKindOfClass:[NSString class]]) {
                continue;
            }
            
            if ([message.messageId isEqualToString:serviceMessage.messageId]) {
                
                updateMessage = message;
                break;
            }
        }
        
        
        [self.chatTableView reloadData];
    }];
    
    
    self.lastMessageDate = message.timeStamp;
}

#pragma mark — XMPPToolDelegate
//IM业务层消息监听：收到消息，发送消息成功，添加好友申请

// 消息发送成功，通知监听:消息发送时消息ui提前跟新，网络成功后再实时更新当前状态
- (void)didSendMessage:(ChatMessageServiceModel *)imMessage
{
    ChatMessageModel *upDateMessage = nil;
    for (ChatMessageModel *message in self.chatMessages) {
        
        if ([message.imMessage.messageId isEqualToString:imMessage.messageId]) {
            
            upDateMessage = message;
            
            //根据messageId找到列表中messageModel,进行状态更新
            upDateMessage.deliveryState = imMessage.deliveryState;
            break;
        }
    }
    
    
    
    [self.chatTableView reloadData];
}
//接受消息，通知监听：消息接受到的是MessageServiceModel,进行组装成MessageModel来更新界面
- (void)didReceiveMessage:(ChatMessageServiceModel *)imMessage
{
    
    
    
    //在下载媒体类型附件
    //消息组装，组装uiMessage数据，进行本地存储等相关操作
    ChatMessageModel *messageModel = [self formateMessage:imMessage];
    //先判断是否加入时间戳
    [self insertTimeMessage:messageModel];
    
    
    
    
    [self handleReceiveMessage:messageModel completion:^{
        NSLog(@"插入接收消息成功！");
        [self.chatMessages addObject:messageModel];
        [self.chatTableView reloadData];
        
    }];
    
    
    
    self.lastMessageDate = imMessage.timeStamp;

}
//根据接收的serviceMessageModel组装messageModel:刷新ui等操作
- (ChatMessageModel *)formateMessage:(ChatMessageServiceModel *)serviceMessage
{
 
//    MessageModel *fakeServiceMessage = (MessageModel *)serviceMessage;
    ChatMessageModel *message = nil;
    
    switch (serviceMessage.messageType) {
        case MessageBodyTypeText: {
            
            message = [ChatTextMessageModel text:serviceMessage.messageBody username:serviceMessage.from timeStamp:serviceMessage.timeStamp isSender:NO];
            break;
        }
        case MessageBodyTypePhoto: {
            message = [ChatPhotoMessageModel photo:nil thumbnailUrl:nil originPhotoUrl:nil username:nil timeStamp:nil isSender:NO];
            break;
        }
        case MessageBodyTypeVideo: {
            message = [ChatVideoMessageModel videoThumbPhoto:nil videoThumbUrl:nil videoUrl:nil username:nil timeStamp:nil isSender:NO];
            break;
        }
        case MessageBodyTypeVoice: {
            message = [ChatVoiceMessageModel voicePath:nil voiceUrl:nil voiceDuration:nil username:nil timeStamp:nil isRead:nil isSender:NO];
            break;
        }
        case MessageBodyTypeLocation: {
            message = [ChatLocationMessageModel localPositionPhoto:nil address:nil location:nil username:nil timeStamp:nil isSender:NO];
            break;
        }
    }
    return message;
}

/**
*  @brief 接收消息时处理媒体类型附件：
*
*  @param message <#message description#>
*/

//文本消息不处理;
//图片自己不做硬盘管理，全权交给sdWebImage:首先展现在ui上;
//音频先下载下来再进行ui展示
//视频先下载下来，播放视频时在未下载到本地时使用网络同步播放    或者先展示截图，再进度下载视频，直至下载完才可播放视频：
//位置同照片，全权交给sdWebImage:首先展现在ui上
- (void)handleReceiveMessage:(ChatMessageModel *)message completion:(void(^)(void))completion
{
    switch (message.bubbleMessageBodyType) {
        case MessageBodyTypeText: {
            //doNothing
            completion();
            break;
        }
        case MessageBodyTypePhoto: {
            //sdWebImage do allThing
            completion();
            break;
        }
        case MessageBodyTypeVideo: {
            //videoThumb  sdWebImage do allThing
            //video       catchIntoDisk,later play
            //边播边下载
            completion ? completion() : nil;
            
            if (!message.isDownloading) {
                NSString *cachePath = [[CacheManager sharedCacheManager] savePathForType:MessageBodyTypeVideo];
                message.locationVideoPath = cachePath;
                [NetworkManager downloadWithURL:message.videoUrl fileDir:cachePath progress:^(NSProgress *progress) {
                    NSLog(@"视频下载中:%@",progress);
                    message.isDownloading = YES;
                } success:^(NSString *filePath) {
                    message.isVideoCache = YES;
                    completion ? completion() : nil;
                } failure:^(NSError *error) {
                     NSLog(@"视频下载失败:%@",error);
                }];
            }
            
            
            break;
        }
        case MessageBodyTypeVoice: {
            //catchVoiceIntoDisk,later play
            
            NSString *cachePath = [[CacheManager sharedCacheManager]savePathForType:MessageBodyTypeVoice];
            message.voicePath = cachePath;
            [NetworkManager downloadWithURL:message.voiceUrl fileDir:cachePath progress:^(NSProgress *progress) {
                 NSLog(@"音频下载中:%@",progress);
            } success:^(NSString *filePath) {
                NSLog(@"音频下载完成:%@",cachePath);
                completion ? completion() : nil;
            } failure:^(NSError *error) {
                NSLog(@"音频下载失败:%@",error);
            }];
            break;
        }
        case MessageBodyTypeLocation: {
            //catchPhotoIntoDisk,later play
            completion();
            break;
        }
    }
}





#pragma mark --- 插入时间戳

- (void)insertTimeMessage:(ChatMessageModel *)message
{
    
    NSDate *lastMessageDate = [NSDate dateString:self.lastMessageDate WithFormate:KDateFormate];
    
    NSDate *messageDate = [NSDate dateString:message.timeStamp WithFormate:KDateFormate];
    
    //加入时间戳
    CGFloat timeInterval = [NSDate timeIntervalWithFormer:lastMessageDate latter:messageDate];
    if (timeInterval>kTimeInterval) {
        
        [self.chatMessages addObject:message.timeStamp];
    }
}

#pragma mark — ChatCellClickDelegate
- (void)audioRecoderBubbleDidSelectedOnMessage:(ChatMessageModel *)message
{
    NSLog(@"点击了音频bubble");
    
    message.isRead = YES;
    
    //局部刷新
    
    NSInteger row = [self.chatMessages indexOfObject:message];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:0];
    
    //如果上次和当前选中非同一行： 先取消上一次音频播放
    
    if (! (indexPath == self.lastVoiceIndexPath) && self.lastVoiceIndexPath) {
        ChatMessageModel *lastPlayMessage =  self.lastVoiceIndexPath ? self.chatMessages[self.lastVoiceIndexPath.row] : nil;
        if (lastPlayMessage) {
            lastPlayMessage.isPlaying = NO;
        }
        
        [self.chatTableView reloadRowsAtIndexPaths:@[self.lastVoiceIndexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
    
    
    
    //再当前选中音频播放/暂停
    message.isPlaying ^= 1;
    
    [self.chatTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    
    self.lastVoiceIndexPath = indexPath;
    
    
    [[BubblePressManager sharedBubblePressManager] audioPlayOrStop:message finishPlay:^(NSString *url) {
        
        for (NSInteger i = 0; i<self.chatMessages.count; i++) {
            
            ChatMessageModel *finishPlayMessage = self.chatMessages[i];
            
            if ([finishPlayMessage isKindOfClass:[ChatMessageModel class]]) {
                if (finishPlayMessage.voicePath) {
                    
                    if ([finishPlayMessage.voicePath isEqualToString:url]) {
                        
                        finishPlayMessage.isPlaying = NO;
                        [self.chatTableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:i inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
                    }
                }
            }
            
            
        }
        
    }];
}

- (void)videoBubbleDidSelectedOnMessage:(ChatMessageModel *)message
{
    NSLog(@"点击了视频bubble");
    [[BubblePressManager sharedBubblePressManager] videoPlay:message];
}

- (void)textBubbleDidSelectedOnMessage:(ChatMessageModel *)message
{
    NSLog(@"双击了纯文本bubble");
    [[BubblePressManager sharedBubblePressManager] viewTextContent:message];
}

- (void)locationBubbleDidSelectedOnMessage:(ChatMessageModel *)message
{
    NSLog(@"点击了位置bubble");
    [[BubblePressManager sharedBubblePressManager] locationMap:message viewController:self];
}

- (void)photoBubbleDidSelectedOnMessage:(ChatMessageModel *)message photo:(UIImageView *)photo
{
    NSLog(@"点击了图片bubble");
    [[BubblePressManager sharedBubblePressManager] photoBrow:message photo:photo];
}

- (void)avaterDidSelectedOnMessage:(ChatMessageModel *)message
{
    NSLog(@"点击了头像");
}

- (void)resendMessage:(ChatMessageModel *)message
{
    message.deliveryState = MessageDeliveryStateDelivering;
    [self refreshSingleMessage:message];
    
    //消息业务发送
    __block ChatMessageModel *updateMessage = nil;
    [MessageSendManager sendMessage:message completion:^(ChatMessageServiceModel *serviceMessage) {
        
        //定位到ui上已经展示的那条消息，进行消息状态的更新
        for (ChatMessageModel *message in self.chatMessages) {
            
            if ([message isKindOfClass:[NSString class]]) {
                continue;
            }
            
            if ([message.messageId isEqualToString:serviceMessage.messageId]) {
                
                updateMessage = message;
                updateMessage.deliveryState = serviceMessage.deliveryState;
                break;
            }
        }
        
        
        [self.chatTableView reloadData];
    }];
    NSLog(@"重新发送消息");
}

- (void)refreshSingleMessage:(ChatMessageModel *)message
{
    NSInteger item = [self.chatMessages indexOfObject:message];
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:item inSection:0];
    
    [self.chatTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

- (void)didSelectLink:(NSString *)link withType:(MLEmojiLabelLinkType)type
{
    NSLog(@"点击了链接");
    [[BubblePressManager sharedBubblePressManager] linkHandle:link type:type];
}

#pragma mark — kvo 盘事件调整table的offset
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    //监测键盘变化：改变chatTable的offset
    if ([keyPath isEqualToString:@"keyBoardDetalChange"]){
        
        [self.chatTableView setContentOffset:CGPointMake(0, self.chatTableView.contentSize.height+self.keyBoardView.keyBoardDetalChange-SCREEN_HEIGHT) animated:YES];
        
    }
}


- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    self.keyBoardView.hideKeyBoard = YES;
}

#pragma mark — getter
- (UITableView *)chatTableView
{
    if (!_chatTableView) {
        _chatTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kWidth, kHeight - KeyToolBarHeight) style:UITableViewStylePlain];
        _chatTableView.delegate = self;
        _chatTableView.dataSource = self;
        _chatTableView.backgroundColor = [UIColor whiteColor];
        _chatTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _chatTableView;
}

- (NSMutableArray *)chatMessages
{
    if (!_chatMessages) {
        _chatMessages = [NSMutableArray array];
    }
    return _chatMessages;
}

- (KeyBoardView *)keyBoardView
{
    if (!_keyBoardView) {
        _keyBoardView = [[KeyBoardView alloc] initWithFrame:CGRectMake(0, kHeight - KeyToolBarHeight, kWidth, KeyToolBarHeight)];
    }
    return _keyBoardView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
