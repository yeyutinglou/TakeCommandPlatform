//
//  URL_Constant.h
//  TakeCommandPlatform
//
//  Created by jyd on 2017/12/12.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URL_Constant : NSObject

//>>>>>>>>>>>>>>>>登录
///登录接口
extern NSString *const REQUEST_URL_LOGIN;

//>>>>>>>>>>>>>>>>end

//>>>>>>>>>.>>>搜索
///搜索接口
extern NSString *const REQUEST_URL_SEARCHINFOS;

/** 查询学生信息详情 */
extern NSString *const REQUEST_URL_FindStudentDetails;

/** 查询监考员信息详情 */
extern NSString *const REQUEST_URL_FindStaffDetails;


/** 获取考场列表 */
extern NSString *const REQUEST_URL_FindRoomInfo;

//>>>>>>>>>..end

//>>>>>>>>>>>>通知
///通知公告接口(市级)
extern NSString *const REQUEST_URL_NEWNOTICES;

///通知公告接口(校级)
extern NSString *const REQUEST_URL_SCHOOLNOTICES;

///修改用户阅读通知状态
extern NSString *const REQUEST_URL_UpadeNoticeState;

///发送新建通知
extern NSString *const REQUEST_URL_SENDNEWNOTICE;

///获取接收用户
extern NSString *const REQUEST_URL_RECEIVERS;

///删除通知公告
extern NSString *const REQUEST_URL_DELETENOTICES;


///用户阅读状态
extern NSString *const REQUEST_URL_FINDUSERS;

//>>>>>>>>>>>>>end


///考点信息
extern NSString *const REQUEST_URL_EXAMADDRESSINFO;

///获取考场列表数据
extern NSString *const REQUEST_URL_EXAMROOMLIST;

///获取考生座次表
extern NSString *const REQUEST_URL_STUDENTSEATS;

///搜索查询考生
extern NSString *const REQUEST_URL_STUDENTSEARCH;



#pragma mark — Map
///获取用户列表
extern NSString *const REQUEST_URL_FINDUSERINFO;

@end
