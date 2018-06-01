//
//  XMPPTool.m
//  TakeCommandPlatform
//
//  Created by jyd on 2018/3/1.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import "XMPPTool.h"
#import "LoginViewController.h"
#import "BaseNavigationController.h"
#import "AppDelegate.h"

///服务器ip
#define XMPPServerAddress @"60.172.229.162"
///服务器端口
#define XMPPServerPort 5222
///服务器域名
#define XMPPServerName @"ios"

@interface XMPPTool ()<XMPPStreamDelegate,XMPPRosterDelegate, XMPPRosterMemoryStorageDelegate>

/** resultBlock */
@property (nonatomic, assign) XMPPResultBlock resultBlock;


/** 自动连接 */
@property (nonatomic, strong) XMPPReconnect *reconnect;

/** 电子名片 */
@property (nonatomic, strong) XMPPvCardCoreDataStorage *vCardStorage;

/** 定义一个消息对象 */
@property (nonatomic, strong) XMPPMessageArchiving *messageArchiving;


/** 头像 */
@property (nonatomic, strong) XMPPvCardAvatarModule *avatar;



@end

@implementation XMPPTool

singleton_implementation(XMPPTool)



#pragma mark - 初始化XMPPStream
- (void)setupXMPPStream
{
    _xmppStream = [[XMPPStream alloc] init];
    
    //自动连接模块
    _reconnect = [[XMPPReconnect alloc] init];
    [_reconnect activate:_xmppStream];
    
    //添加电子名片模块
    _vCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
    _vCard = [[XMPPvCardTempModule alloc] initWithvCardStorage:_vCardStorage];
    
    //激活
    [_vCard activate:_xmppStream];
    
    //添加头像模块
    _avatar = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:_vCard];
    [_avatar activate:_xmppStream];
    
    // 添加花名册模块【获取好友列表】
    _rosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
    _roster = [[XMPPRoster alloc] initWithRosterStorage:_rosterStorage];
    [_roster activate:_xmppStream];
    
    //聊天模块
    _messageStorage = [[XMPPMessageArchivingCoreDataStorage alloc] init];
    _messageArchiving = [[XMPPMessageArchiving alloc] initWithMessageArchivingStorage:_messageStorage];
    [_messageArchiving activate:_xmppStream];
    
    // 设置代理
    [_xmppStream addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    
    //添加好友模块
    self.rosterMemory = [[XMPPRosterMemoryStorage alloc] init];
    self.roster = [[XMPPRoster alloc] initWithRosterStorage:self.rosterMemory];
    [self.roster activate:self.xmppStream];
    [self.roster addDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    //自动同步好友
    [self.roster setAutoFetchRoster:YES];
    // 关掉自动接收好友请求，默认开启自动同意
    [self.roster setAutoAcceptKnownPresenceSubscriptionRequests:NO];
    self.friends = self.rosterMemory.unsortedUsers;
}


#pragma mark — 连接服务器
- (void)connectToHost
{
    if (!_xmppStream) {
        [self setupXMPPStream];
    }
    
   
    
    XMPPJID *myJID = [XMPPJID jidWithUser:kUserAccount domain:XMPPServerName resource:@"iphone" ];
    _xmppStream.myJID = myJID;
    
    // 设置服务器域名
    _xmppStream.hostName = XMPPServerAddress;//不仅可以是域名，还可是IP地址
    
    // 设置端口 如果服务器端口是5222，可以省略
    _xmppStream.hostPort = XMPPServerPort;
    
    // 连接
    NSError *err = nil;
    if(![_xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&err]){
        NSLog(@"%@",err);
    }
}

#pragma mark -XMPPStream的代理
#pragma mark 与主机连接成功
-(void)xmppStreamDidConnect:(XMPPStream *)sender{
    DYWLog(@"与主机连接成功");
    
    if (self.isRegisterOperation) {//注册操作，发送注册的密码
        NSString *pwd = [LoginManager sharedInstance].password;
        [_xmppStream registerWithPassword:pwd error:nil];
    }else{//登录操作
        // 主机连接成功后，发送密码进行授权
        [self sendPwdToHost];
    }
    
}

#pragma mark 连接到服务成功后，再发送密码授权
-(void)sendPwdToHost{
    DYWLog(@"再发送密码授权");
    NSError *err = nil;
    
    // 从单例里获取密码
    NSString *pwd = [LoginManager sharedInstance].password;
    
    [_xmppStream authenticateWithPassword:pwd error:&err];
    
    if (err) {
        DYWLog(@"%@",err);
    }
}
#pragma mark  与主机断开连接
-(void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error{
    // 如果有错误，代表连接失败
    
    // 如果没有错误，表示正常的断开连接(人为断开连接)
    
    
    if(error && _resultBlock){
        _resultBlock(XMPPResultTypeNetErr);
    }
    DYWLog(@"与主机断开连接 %@",error);
    
}


#pragma mark 授权成功
-(void)xmppStreamDidAuthenticate:(XMPPStream *)sender{
    DYWLog(@"授权成功");
    
    [self sendOnlineToHost];
    
    // 回调控制器登录成功
    if(_resultBlock){
        _resultBlock(XMPPResultTypeLoginSuccess);
    }
    
    
}


#pragma mark 授权失败
-(void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(DDXMLElement *)error{
    DYWLog(@"授权失败 %@",error);
    
    // 判断block有无值，再回调给登录控制器
    if (_resultBlock) {
        _resultBlock(XMPPResultTypeLoginFailure);
    }
}

#pragma mark 注册成功
-(void)xmppStreamDidRegister:(XMPPStream *)sender{
    DYWLog(@"注册成功");
    if(_resultBlock){
        _resultBlock(XMPPResultTypeRegisterSuccess);
    }
    
}

#pragma mark 注册失败
-(void)xmppStream:(XMPPStream *)sender didNotRegister:(DDXMLElement *)error{
    
    DYWLog(@"注册失败 %@",error);
    if(_resultBlock){
        _resultBlock(XMPPResultTypeRegisterFailure);
    }
    
}

#pragma mark  授权成功后，发送"在线" 消息
-(void)sendOnlineToHost{
    
    DYWLog(@"发送 在线 消息");
    XMPPPresence *presence = [XMPPPresence presence];
    DYWLog(@"%@",presence);
    
    [_xmppStream sendElement:presence];
    
    
}

///离线消息
- (void)goOffline
{
    XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
    
    [_xmppStream sendElement:presence];
}

#pragma mark — 接收消息
- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
    NSDate *date = [self getDelayStampTime:message];
    
    if (date == nil) {
        date = [NSDate date];
    }
    
    NSString *strDate=[NSDate date:date WithFormate:KDateFormate];
    XMPPJID *jid = [message from];
    NSString *body = [[message elementForName:@"body"] stringValue];
    
    //封装im数据
    if (body) {
        ChatMessageServiceModel *model = [[ChatMessageServiceModel alloc] init];
        model.from = [jid user];
        model.to  = [_xmppStream.myJID user];
        model.timeStamp = strDate;
        model.messageBody = body;
        model.messageType = [[[message elementForName:@"type"] stringValue] intValue];
        if (_delegate && [_delegate respondsToSelector:@selector(didReceiveMessage:)]) {
            [_delegate didReceiveMessage:model];
        }
    }
    
    //本地通知
    UILocalNotification *local=[[UILocalNotification alloc]init];
    local.alertBody=body;
    local.alertAction=body;
    //声音
    local.soundName=[[NSBundle mainBundle] pathForResource:@"shake_match" ofType:@"mp3"];
    //时区  根据用户手机的位置来显示不同的时区
    local.timeZone=[NSTimeZone defaultTimeZone];
    //开启通知
    [[UIApplication sharedApplication] scheduleLocalNotification:local];
    //发送一个通知
    if(body){
        NSDictionary *dict=@{@"uname":[jid user],@"time":strDate,@"body":body,@"jid":jid,@"user":@"other"};
        NSNotification *note=[[NSNotification alloc]initWithName:SendMsgName object:dict userInfo:nil];
        [[NSNotificationCenter defaultCenter] postNotification:note];
    }

}

#pragma mark — 发送消息
- (void)sendMessage:(ChatMessageModel *)message
{
    ChatMessageServiceModel *imMessage = message.imMessage;
    [self sendMessageWithIM:imMessage];
}

/// 发送IM消息
- (void)sendMessageWithIM:(ChatMessageServiceModel *)imMessage{
    //创建一个xml
    //创建元素
    NSXMLElement *msg=[[NSXMLElement alloc]initWithName:@"message"];
    //定制根元素的属性
    [msg addAttributeWithName:@"type" stringValue:[NSString stringWithFormat:@"%lu",(unsigned long)imMessage.messageType]];
    [msg addAttributeWithName:@"from" stringValue:imMessage.from];
    [msg addAttributeWithName:@"to" stringValue:imMessage.to];
    //创建一个子元素
    NSXMLElement *body=[[NSXMLElement alloc]initWithName:@"body"];
    [body setStringValue:imMessage.messageBody];
    [msg addChild:body];
    //发送信息
    [_xmppStream sendElement:msg];
    NSLog(@"%@",msg);
}

- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message
{
    
}

#pragma mark 获得离线消息的时间

-(NSDate *)getDelayStampTime:(XMPPMessage *)message{
    //获得xml中德delay元素
    XMPPElement *delay=(XMPPElement *)[message elementsForName:@"delay"];
    if(delay){  //如果有这个值 表示是一个离线消息
        //获得时间戳
        NSString *timeString=[[ (XMPPElement *)[message elementForName:@"delay"] attributeForName:@"stamp"] stringValue];
        //创建日期格式构造器
        NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
        [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"];
        //按照T 把字符串分割成数组
        NSArray *arr=[timeString componentsSeparatedByString:@"T"];
        //获得日期字符串
        NSString *dateStr=[arr objectAtIndex:0];
        //获得时间字符串
        NSString *timeStr=[[[arr objectAtIndex:1] componentsSeparatedByString:@"."] objectAtIndex:0];
        //构建一个日期对象 这个对象的时区是0
        NSDate *localDate=[formatter dateFromString:[NSString stringWithFormat:@"%@T%@+0000",dateStr,timeStr]];
        return localDate;
    }else{
        return nil;
    }
    
}

#pragma mark — XMPPRosterDelegate 获取好友
//同步好友列表到本地
- (void)xmppRosterDidPopulate:(XMPPRosterMemoryStorage *)sender
{
    
}

/// 同步到一个好友节点到本地
- (void)xmppRoster:(XMPPRoster *)sender didReceiveRosterItem:(NSXMLElement *)item
{
    
}

/// 同步好友列表到本地完成
- (void)xmppRosterDidEndPopulating:(XMPPRoster *)sender
{
    
}

#pragma mark — XMPPRosterMemoryStorageDelegate
///本地好友发生改变
- (void)xmppRosterDidChange:(XMPPRosterMemoryStorage *)sender
{
    // 如果设置了自动同步，当服务器的好友列表发生改变时，会自动同步存入本地好友存储器
}
///收到添加好友请求
- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence
{
    NSString *name = [NSString stringWithFormat:@"添加 %@ 为好友？", presence.from.user];
    
    // 同意并添加对方为好友，YES 存入本地好友存储器
    [self.roster acceptPresenceSubscriptionRequestFrom:presence.from andAddToRoster:YES];
    
    // 拒绝添加对方为好友
    [self.roster rejectPresenceSubscriptionRequestFrom:presence.from];
    if (self.delegate && [self.delegate respondsToSelector:@selector(didRecevieFriendRequest:)])
    {
//        [self.delegate didRecevieFriendRequest:imMessage];
        
    }
}

#pragma mark — XMPPStreamDelegate
///好友状态改变
- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
    // 收到对方取消定阅我的消息，对方删除我、对方状态改变
    
    if ([presence.type isEqualToString:@"unsubscribe"]) {
        
        // 从我的本地好友存储器中将对方移除
        [self.roster removeUser:presence.from];
    }
}


#pragma mark -退出登录
-(void)xmppUserlogout{
    // 1." 发送 "离线" 消息"
    [self goOffline];
    
    // 2. 与服务器断开连接
    [_xmppStream disconnect];
    
    // 3. 回到登录界面
    
    LoginViewController *login = [[LoginViewController alloc] init];
    BaseNavigationController *na = [[BaseNavigationController alloc] initWithRootViewController:login];
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.window.rootViewController = na;
  
    
    
    //4.更新用户的登录状态
    [LoginManager sharedInstance].isLogin = NO;
    
}

#pragma mark — 登录成功
-(void)xmppUserLogin:(XMPPResultBlock)resultBlock{
    
    // 先把block存起来
    _resultBlock = resultBlock;
    
    //    Domain=XMPPStreamErrorDomain Code=1 "Attempting to connect while already connected or connecting." UserInfo=0x7fd86bf06700 {NSLocalizedDescription=Attempting to connect while already connected or connecting.}
    // 如果以前连接过服务，要断开
    [_xmppStream disconnect];
    
    // 连接主机 成功后发送登录密码
    [self connectToHost];
}


#pragma mark — 注册成功
-(void)xmppUserRegister:(XMPPResultBlock)resultBlock{
    // 先把block存起来
    _resultBlock = resultBlock;
    
    // 如果以前连接过服务，要断开
    [_xmppStream disconnect];
    
    // 连接主机 成功后发送注册密码
    [self connectToHost];
}

#pragma mark — 添加好友
/// 添加好友，自定义方法
- (void)addFriendWithUserName:(NSString *)userName remarkName:(NSString *)remarkName
{
    NSString *jidString = userName;
    
//    // 判断有没有域名，如果没有域名，自己添加形成完整的 jid
//    NSString *domainString = [NSString stringWithFormat:@"@%@", HOST_DOMAIN];
//    if (![jidString containsString:domainString]) {
//        jidString = [jidString stringByAppendingString:domainString];
//    }
    
    XMPPJID *friendJID = [XMPPJID jidWithString:jidString];
    
    // 添加好友，remarkName 为备注名称
    [self.roster addUser:friendJID withNickname:remarkName];
}

#pragma mark — 删除好友
- (void)removeFriendWithUserName:(NSString *)userName
{
    NSString *jidString = userName;
    
//    // 判断有没有域名，如果没有域名，自己添加形成完整的 jid
//    NSString *domainString = [NSString stringWithFormat:@"@%@", HOST_DOMAIN];
//    if (![jidString containsString:domainString]) {
//        jidString = [jidString stringByAppendingString:domainString];
//    }
    
    XMPPJID *friendJID = [XMPPJID jidWithString:jidString];
    
    // 删除好友
    [self.roster removeUser:friendJID];
}

#pragma mark — 释放XMPPStream
- (void)teardownXMPP
{
    // 移除代理
    [_xmppStream removeDelegate:self];
    
    // 停止模块
    [_reconnect deactivate];
    [_vCard deactivate];
    [_avatar deactivate];
    [_roster deactivate];
    
    // 断开连接
    [_xmppStream disconnect];
    
    // 清空资源
    _reconnect = nil;
    _vCard = nil;
    _vCardStorage = nil;
    _avatar = nil;
    _roster = nil;
    _rosterStorage = nil;
    _xmppStream = nil;
}


-(void)dealloc{
    [self teardownXMPP];
}

@end
