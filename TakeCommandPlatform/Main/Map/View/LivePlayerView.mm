//
//  LivePlayerView.m
//  TakeCommandPlatform
//
//  Created by jyd on 2017/12/20.
//  Copyright © 2017年 jyd. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "LivePlayerView.h"
#import <sys/socket.h>
#import <netdb.h>
#import "hcnetsdk.h"
#import "IOSPlayM4.h"
#import "dhplay.h"
#import "DHVideoWnd.h"
#import "AppDelegate.h"
#define SOCKET_DATA_BUFFER_LENGTH 50 * 1024
#define STREAM_DATA_BUFFER_LENGTH 10 * 1024 * 1024

typedef NS_ENUM(NSUInteger, LivePlayDeviceType) {
    LivePlayDeviceTypeHKandTF, //海康和同方
    LivePlayDeviceTypeDH, //大华

};

@interface LivePlayerView ()
{
    int socketFileDescriptor;
    int playPort; /// 播放通道号
     NSThread *communicationThread;
    
    NSMutableArray *videoDataArray; /// 视频数据数组
    NSOperationQueue *playOperationQueue;
    NSInvocationOperation *receiveDataOperation; /// 接收视频数据Operation
    NSInvocationOperation *processDataOperation; /// 处理视频数据Operation
}

/** 设备类型 */
@property (nonatomic, assign) LivePlayDeviceType deviceType;

/**
 *  转发IP
 */
@property (nonatomic, copy) NSString *transferServerIp;

/** 转发port */
@property (nonatomic,copy) NSString *transferServerPort;

/** 播放容器 */
@property (nonatomic, strong) UIView *playView;

/** DHView */
@property (nonatomic, strong) DHVideoWnd *DHView;

/** 全屏按钮 */
@property (nonatomic, strong) UIButton *screenBtn;

/** 是否全屏 */
@property (nonatomic, assign) BOOL isFullScreen;

/** AppDelegate */
@property (nonatomic, strong) AppDelegate *appDelegate;

///设备当前方向
@property (nonatomic, assign) UIInterfaceOrientation currentOrientation;

@end
@implementation LivePlayerView



- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor blackColor];
        [self setupConfig];
        [self setupOrientation];
    }
    return self;
}

- (void)setupConfig
{
   
    self.appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    self.appDelegate.allowRotation = YES;
    
    _screenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _screenBtn.frame = CGRectMake(self.width - 100, self.height - 40, 100, 40);
    [_screenBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_screenBtn setTitle:@"全屏" forState:UIControlStateNormal];
    [_screenBtn setBackgroundColor:RGB(0, 154, 217)];
    [_screenBtn addTarget:self action:@selector(videoBottomBarDidClickChangeScreenBtn) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setRoomInfo:(RoomInfo *)roomInfo
{
    _roomInfo = roomInfo;
    if ([roomInfo.devicetype isEqualToString:@"tps"] ||[roomInfo.devicetype isEqualToString:@"ttfn"]) {
        //海康 //同方
        self.deviceType = LivePlayDeviceTypeHKandTF;

        [self setupPlayViewHK];
    } else {
         //大华 tdh
        self.deviceType = LivePlayDeviceTypeDH;

        [self setupPlayViewDH];
    }
   
    //连接转发服务器
    [self startPlay];
    
}
- (void)setStudentSearchModel:(StudentSearchModel *)studentSearchModel
{
    _studentSearchModel = studentSearchModel;
    if ([studentSearchModel.devicetype isEqualToString:@"tps"] ||[studentSearchModel.devicetype isEqualToString:@"ttfn"]) {
        //海康 //同方
        self.deviceType = LivePlayDeviceTypeHKandTF;
        
        [self setupPlayViewHK];
    } else {
        //大华 tdh
        self.deviceType = LivePlayDeviceTypeDH;
        
        [self setupPlayViewDH];
    }
    
    //连接转发服务器
    [self startPlay];
}

///海康视频
- (void)setupPlayViewHK
{
    _playView = [[UIView alloc] init];
    _playView.frame = self.frame;
    _playView.backgroundColor = [UIColor blackColor];
    [self addSubview:_playView];
    
   
    
    
}
///大华视频
- (void)setupPlayViewDH
{
    _DHView = [[DHVideoWnd alloc] init];
    _DHView.frame = self.frame;
    [self addSubview:_DHView];
    
    
    
    //大华
    if (!PLAY_SetStreamOpenMode(0, STREAME_FILE)) {
        NSLog(@">>> PLAY_SetStreamOpenMode failed");
        NSLog(@">>> %u", PLAY_GetLastError(0));

    }
    
    if (!PLAY_OpenStream(0, NULL , 0, STREAM_DATA_BUFFER_LENGTH)) {
        NSLog(@">>>PLAY_OpenStream failed");
        NSLog(@">>> %u", PLAY_GetLastError(0));
    }
    if (!PLAY_Play(0, (__bridge HWND)_DHView)) {
        NSLog(@">>>PLAY_Play failed");
        NSLog(@">>> %u", PLAY_GetLastError(0));
    }
    if (!PLAY_PlaySound(0)) {
        NSLog(@">>>PLAY_PlaySound failed");
        NSLog(@">>> %u", PLAY_GetLastError(0));
    }
    [_DHView addSubview:_screenBtn];
}




///创建线程
- (void)startPlay
{
    playPort = -1;

    _transferServerIp = @"58.135.130.32";
    _transferServerPort = @"1001";

    //实例方法创建NSThread对象:先创建线程对象，然后再运行线程操作，在运行线程操作前可以设置线程的优先级等线程信息
    communicationThread = [[NSThread alloc] initWithTarget:self selector:@selector(startCommunication) object:nil];
    [communicationThread start];
    
}

/**
 *  开始与转发服务器通信
 *  连接转发服务器
 */
- (void)startCommunication
{
    NSLog(@">>> 连接转发服务器...IP: %@", self.transferServerIp);
    if (![self connectToServer]) {
        NSLog(@">>> 连接转发服务器失败！");
        return;
    }
    NSLog(@">>> 连接转发服务器成功！");
    
    NSLog(@">>> 向转发服务器发送取视频数据命令...");
    
    //转发命令
    NSString *getVideoCommand = [NSString stringWithFormat:@"tps:192.168.21.201:1"];
    
    NSLog(@"getVideoCommand=========>%@", getVideoCommand);
    
    //    NSString *message = [NSString stringWithFormat:@"tps:%@:1:dvr", deviceIP];
    //    JSLog(@"Old Message:=====%@", message);
    
    if (![self sendMessageToServer:getVideoCommand]) {
        NSLog(@">>> 向转发服务器发送取视频数据命令失败！");
        return;
    }
    NSLog(@">>> 向转发服务器发送取视频数据命令成功！");
    
    [self startPlayThread];
}

/// 连接转发服务器
- (BOOL)connectToServer {
    /// 创建socket
    socketFileDescriptor = socket(AF_INET, SOCK_STREAM, 0);
    if (socketFileDescriptor == -1) {
        NSLog(@">>> 创建socket失败！");
        return NO;
    }
    
    /// 解析服务器地址
    //    struct hostent *remoteHostEnt = gethostbyname([TRANSFER_SERVER_IP UTF8String]);
    struct hostent *remoteHostEnt = gethostbyname([self.transferServerIp UTF8String]);
    if (NULL == remoteHostEnt) {
        close(socketFileDescriptor);
        NSLog(@">>> 无法解析服务器地址！");
        return NO;
    }
    
    struct in_addr *remoteInAddr = (struct in_addr *)remoteHostEnt->h_addr_list[0];
    
    /// 设置socket参数
    struct sockaddr_in socketParams;
    socketParams.sin_family = AF_INET;
    socketParams.sin_addr = *remoteInAddr;
    socketParams.sin_port = htons([self.transferServerPort integerValue]);
    
    /// 连接socket
    int connectResult = connect(socketFileDescriptor, (struct sockaddr *)&socketParams, sizeof(socketParams));
    if (connectResult == -1) {
        close(socketFileDescriptor);
        //        NSString *errorString = [NSString stringWithFormat:@">>> 无法连接到socket：%@:%d", TRANSFER_SERVER_IP, TRANSFER_SERVER_PORT];
        NSString *errorString = [NSString stringWithFormat:@">>> 无法连接到socket：%@:%@", self.transferServerIp, self.transferServerPort];
        NSLog(@"%@", errorString);
        return NO;
    }
    
    return YES;
}

/// 向转发服务器发送消息
- (BOOL)sendMessageToServer:(NSString *)message {
    const char *messageData = [message UTF8String];
    if (send(socketFileDescriptor, messageData, strlen(messageData) + 1, 0) == -1) {
        ///close(socketFileDescriptor);
        return NO;
    }
    return YES;
}

/// 开始播放线程
- (void)startPlayThread
{
    videoDataArray = [[NSMutableArray alloc] init];
    
    receiveDataOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(receiveVideoData) object:nil];
    processDataOperation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(processVideoData) object:nil];
    
    playOperationQueue = [[NSOperationQueue alloc] init];
    [playOperationQueue addOperation:receiveDataOperation];
    [playOperationQueue addOperation:processDataOperation];
}

/// 接收视频数据
- (void)receiveVideoData {
    int dataActualLength = 0; /// 每次接收到的实际数据长度
    while (![receiveDataOperation isCancelled]) {
        @synchronized(videoDataArray) {
            Byte buffer[SOCKET_DATA_BUFFER_LENGTH]; /// 存储每次接收到的视频数据
            dataActualLength = recv(socketFileDescriptor, buffer, SOCKET_DATA_BUFFER_LENGTH, 0);
            if (dataActualLength > 0) {
                ///NSLog(@"接收到的视频数据：%s", buffer);
                NSData *data = [[NSData alloc] initWithBytes:buffer length:dataActualLength];
                if (data != nil) {
                    [videoDataArray addObject:data];
                    ///NSLog(@">>>接收数据后视频数据数组长度：%d", [videoDataArray count]);
                }
            }
        }
    }
}

/// 处理视频数据
- (void)processVideoData {
    while (![processDataOperation isCancelled]) {
        @synchronized(videoDataArray) {
            if ([videoDataArray count] > 0) {
                NSData *data = [videoDataArray objectAtIndex:0];
                if (data != nil) {
                    ///NSLog(@"处理的视频数据：%s", [data bytes]);
                    [self performSelectorOnMainThread:@selector(playVideoData:) withObject:data waitUntilDone:NO];
                    [videoDataArray removeObjectAtIndex:0];
                    ///NSLog(@">>>接收数据后视频数据数组长度：%d", [videoDataArray count]);
                }
            }
        }
    }
}

/// 播放视频数据
- (BOOL)playVideoData:(NSData *)data {
    Byte *buffer = (Byte *)[data bytes];
    NSUInteger length = [data length];
    switch (_deviceType) {
        case LivePlayDeviceTypeHKandTF:
            {
                if (playPort < 0) { /// 第一次接收到数据——数据头
                    ///NSLog(@">>> data header");
                    ///NSLog(@"data header length : %d", length);
                    ///NSLog(@">>> 接收到数据头");
                    NSLog(@">>> 获取未使用的通道号");
                    if (PlayM4_GetPort(&playPort) != 1) {
                        NSLog(@">>> PlayM4_GetPort失败！");
                        NSLog(@">>> %u", PlayM4_GetLastError(playPort));
                        return NO;
                    }
                    NSLog(@">>> 设置流播放模式");
                    if (!PlayM4_SetStreamOpenMode(playPort, STREAME_REALTIME)) {
                        NSLog(@">>> PlayM4_SetStreamOpenMode失败！");
                        NSLog(@">>> %u", PlayM4_GetLastError(playPort));
                        return NO;
                    }
                    NSLog(@">>> 打开流");
                    if (!PlayM4_OpenStream(playPort, buffer, (int)length, STREAM_DATA_BUFFER_LENGTH)) {
                        NSLog(@">>> PlayM4_OpenStream failed");
                        NSLog(@">>> %u", PlayM4_GetLastError(playPort));
                        return NO;
                    }
                    NSLog(@">>> 开启播放");
                    if (!PlayM4_Play(playPort, (void *)CFBridgingRetain(_playView))) {
                        NSLog(@">>> PlayM4_Play失败！");
                        NSLog(@">>> %u", PlayM4_GetLastError(playPort));
                        return NO;
                    }
                    
                    NSLog(@">>> 打开声音");
                    
                    if (!PlayM4_PlaySound(playPort)) {
                        NSLog(@">>> PlayM4_PlaySound失败！");
                        NSLog(@">>> %u", PlayM4_GetLastError(playPort));
                    }
                    NSLog(@">>> 开始播放");
                     [_playView addSubview:_screenBtn];
                   
                    
                    
                    
                } else { /// 之后接收的为视频数据
                    if (![processDataOperation isCancelled]) {
                        ///NSLog(@">>> data body");
                        ///NSLog(@"data body length : %d", length);
                        ///NSLog(@">>> 输入流数据");
                        if (!PlayM4_InputData(playPort, buffer, length)) {
                            NSLog(@">>> PlayM4_InputData失败！");
                            NSLog(@">>> %u", PlayM4_GetLastError(playPort));
                            return NO;
                        }
                    }
                }
            }
            break;
        case LivePlayDeviceTypeDH:
        {
            if (![processDataOperation isCancelled]) {
                //输入数据流
                if (!PLAY_InputData(0, buffer, length)) {
                    NSLog(@">>> PLAY_InputData  failed！");
                    NSLog(@">>> %u", PLAY_GetLastError(0));
                    return NO;
                }
            }
        }
            break;
        default:
            break;
    }
    
    return YES;
}

/// 停止播放
- (void)stopPlayHK
{
    if (playPort >= 0) {
        NSLog(@">>> 关闭播放");
        if (!PlayM4_Stop(playPort)) {
            NSLog(@">>> PlayM4_Stop失败！");
            NSLog(@">>> %u", PlayM4_GetLastError(playPort));
        }
        NSLog(@">>> 关闭流");
        if (!PlayM4_CloseStream(playPort)) {
            NSLog(@">>> PlayM4_CloseStream失败！");
            NSLog(@">>> %u", PlayM4_GetLastError(playPort));
        }
        NSLog(@">>> 释放已使用的通道号");
        if (!PlayM4_FreePort(playPort)) {
            NSLog(@">>> PlayM4_FreePort失败！");
            NSLog(@">>> %u", PlayM4_GetLastError(playPort));
        }
        NSLog(@">>> 停止播放");
    }
    
    
}

///销毁播放
- (void)destoryPlayView
{
    if (_deviceType == LivePlayDeviceTypeHKandTF) {
        [self stopPlayHK];
    } else {
        [self stopPlayDH];
    }
   
    [playOperationQueue cancelAllOperations]; /// 停止接收和处理视频数据
    
    NSLog(@">>> 关闭socket");
    if (socketFileDescriptor != -1) {
        close(socketFileDescriptor);
    }
    
    
    self.appDelegate.allowRotation = NO;
    [self interfaceOrientation:UIInterfaceOrientationPortrait];
}

///停止大华播放
- (void)stopPlayDH
{
    PLAY_Stop(0);
    PLAY_SetEngine(0, DECODE_SW, RENDER_NONE);
}


#pragma mark - Screen
- (void)videoBottomBarDidClickChangeScreenBtn {
    
    if (_isFullScreen) {
        [self interfaceOrientation:UIInterfaceOrientationPortrait];
    } else {
        [self interfaceOrientation:UIInterfaceOrientationLandscapeRight];
    }
    
    
    
}
- (void)interfaceOrientation:(UIInterfaceOrientation)orientation
{
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector             = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val                  = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}


- (void)setupOrientation {
    
    switch ([UIDevice currentDevice].orientation) {
        case UIDeviceOrientationPortrait:
            _currentOrientation = UIInterfaceOrientationPortrait;
            break;
        case UIDeviceOrientationLandscapeLeft:
            _currentOrientation = UIInterfaceOrientationLandscapeLeft;
            break;
        case UIDeviceOrientationLandscapeRight:
            _currentOrientation = UIInterfaceOrientationLandscapeRight;
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            _currentOrientation = UIInterfaceOrientationPortraitUpsideDown;
            break;
        default:
            break;
    }
    
    // Notice: Must set the app only support portrait orientation.
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationDidChange) name:UIDeviceOrientationDidChangeNotification object:nil];
    
}

#pragma mark - Monitor Methods

- (void)orientationDidChange {
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    switch (orientation) {
        case UIDeviceOrientationPortrait:
            [self changeToOrientation:UIInterfaceOrientationPortrait];
            break;
        case UIDeviceOrientationLandscapeLeft:
            [self changeToOrientation:UIInterfaceOrientationLandscapeRight];
            break;
        case UIDeviceOrientationLandscapeRight:
            [self changeToOrientation:UIInterfaceOrientationLandscapeLeft];
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            [self changeToOrientation:UIInterfaceOrientationPortraitUpsideDown];
            break;
        default:
            break;
    }
}

#pragma mark - Orientation Methods

- (void)changeToOrientation:(UIInterfaceOrientation)orientation {
    
    if (_currentOrientation == orientation) {
        return;
    }
    _currentOrientation = orientation;
    
    if (self.deviceType == LivePlayDeviceTypeHKandTF) {
        [_playView removeFromSuperview];
    } else {
        [_DHView removeFromSuperview];
    }
    
    switch (orientation) {
        case UIInterfaceOrientationPortrait:
        case UIInterfaceOrientationPortraitUpsideDown:
        {
            _isFullScreen = NO;
            if (self.deviceType == LivePlayDeviceTypeHKandTF) {
                [self addSubview:_playView];
                _playView.frame = self.frame;
            } else
            {
                [self addSubview:_DHView];
                _DHView.frame = self.frame;
            }
            _screenBtn.frame = CGRectMake(self.width - 100, self.height - 40, 100, 40);
            break;
        }
        case UIInterfaceOrientationLandscapeLeft:
        case UIInterfaceOrientationLandscapeRight:
        {
            _isFullScreen = YES;
            if (self.deviceType == LivePlayDeviceTypeHKandTF) {
                [[UIApplication sharedApplication].keyWindow addSubview:_playView];
                _playView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            } else
            {
                [[UIApplication sharedApplication].keyWindow addSubview:_DHView];
                _DHView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
            }
            _screenBtn.frame = CGRectMake(SCREEN_WIDTH - 100, SCREEN_HEIGHT - 40, 100, 40);
            
            
            break;
        }
        default:
            break;
    }
    
}

@end
