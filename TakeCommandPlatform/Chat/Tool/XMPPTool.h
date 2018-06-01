//
//  XMPPTool.h
//  TakeCommandPlatform
//
//  Created by jyd on 2018/3/1.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatMessageModel.h"
#import "ChatMessageServiceModel.h"

@protocol XMPPToolDelegate <NSObject>

/**
 *  @brief 消息成功或失败回调
 *
 *  @param imMessage <#imMessage description#>
 */
- (void)didSendMessage:(ChatMessageServiceModel *)imMessage;


//
/**
 *  @brief 接受实时聊天消息
 *
 *  @param imMessage <#imMessage description#>
 */
- (void)didReceiveMessage:(ChatMessageServiceModel *)imMessage;


/**
 *  @brief 接收到好友请求消息
 *
 *  @param imMessage <#imMessage description#>
 */
- (void)didRecevieFriendRequest:(ChatMessageServiceModel *)imMessage;


@end

@interface XMPPTool : NSObject

/** delegate */
@property (nonatomic, weak) id <XMPPToolDelegate> delegate;

typedef enum {
    XMPPResultTypeLoginSuccess,//登录成功
    XMPPResultTypeLoginFailure,//登录失败
    XMPPResultTypeNetErr,//网络不给力
    XMPPResultTypeRegisterSuccess,//注册成功
    XMPPResultTypeRegisterFailure//注册失败
}XMPPResultType;

/// XMPP请求结果的block
typedef void (^XMPPResultBlock)(XMPPResultType type);

singleton_interface(XMPPTool)

@property (nonatomic, strong)XMPPStream *xmppStream;

/** xmppJid */
@property (nonatomic, strong) XMPPJID *jid;

@property (nonatomic, strong)XMPPvCardTempModule *vCard;//电子名片
@property (nonatomic, strong)XMPPRosterCoreDataStorage *rosterStorage;//花名册数据存储
@property (nonatomic, strong)XMPPRoster *roster;//花名册模块ha

/** 好友 */
@property (nonatomic, strong) XMPPRosterMemoryStorage *rosterMemory;


/** 聊天模块 */
@property (nonatomic, strong) XMPPMessageArchivingCoreDataStorage *messageStorage;


/**
 *  注册标识 YES 注册 / NO 登录
 */
@property (nonatomic, assign,getter=isRegisterOperation) BOOL  registerOperation;//注册操作

/** 好友列表 */
@property (nonatomic, strong) NSArray *friends;


/**
 *  用户注销
 
 */
-(void)xmppUserlogout;
/**
 *  用户登录
 */
-(void)xmppUserLogin:(XMPPResultBlock)resultBlock;


/**
 *  用户注册
 */
-(void)xmppUserRegister:(XMPPResultBlock)resultBlock;

///发送消息
- (void)sendMessage:(ChatMessageModel *)message;

///添加好友
- (void)addFriendWithUserName:(NSString *)userName remarkName:(NSString *)remarkName;

///删除好友
- (void)removeFriendWithUserName:(NSString *)userName;
@end
