//
//  NoticeModel.h
//  TakeCommandPlatform
//
//  Created by jyd on 2017/12/15.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Notice;
@class Receiver;
@interface NoticeModel : NSObject

/** 通知 */
@property (nonatomic, strong) Notice *notice;

/** 接收者数量 */
@property (nonatomic, assign) int toatle;

/** 通知内容 */
@property (nonatomic, copy) NSString *content;


/** 通知id */
@property (nonatomic,copy) NSString *notice_id;

/** 通知标题 */
@property (nonatomic,copy) NSString *title;

/** 已读人数 */
@property (nonatomic, assign) int readernum;

/** 发送人数 */
@property (nonatomic, assign) int reader_count;

/** 发布人 */
@property (nonatomic,copy) NSString *sender;

/** 发布人id */
@property (nonatomic, copy) NSString *sender_id;

/** 附件名称 */
@property (nonatomic,copy) NSString *filename;

/** 附件地址 */
@property (nonatomic,copy) NSString *fileurl;


/** 创建时间 */
@property (nonatomic,copy) NSString *send_time;

/** 阅读状态  0未读  1已读 */
@property (nonatomic, assign) BOOL state;


/** 接收者 */
@property (nonatomic, strong) NSArray *receiver;
/** 用户姓名 */
@property (nonatomic,copy) NSString *username;

@end

@interface Notice : NSObject



@end

@interface Receiver : NSObject

/** 接收人id */
@property (nonatomic,copy) NSString *userid;

/** 接收人账号 */
@property (nonatomic,copy) NSString *account;

/** 考点code */
@property (nonatomic,copy) NSString *schoolcode;

/** 学校id */
@property (nonatomic,copy) NSString *schoolId;

/** 学校名称 */
@property (nonatomic,copy) NSString *schoolname;

/** 通知id */
@property (nonatomic,copy) NSString *notice_id;


/** 用户姓名 */
@property (nonatomic,copy) NSString *username;

/** 阅读状态  0未读  1已读 */
@property (nonatomic, assign) BOOL state;

@end

