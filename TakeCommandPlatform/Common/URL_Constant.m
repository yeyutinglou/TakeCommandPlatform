//
//  URL_Constant.m
//  TakeCommandPlatform
//
//  Created by jyd on 2017/12/12.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import "URL_Constant.h"

@implementation URL_Constant


//>>>>>>>>>>>登录
NSString *const REQUEST_URL_LOGIN = @"/mobile/mobileLogin/isLogin";

//>>>>>>>>>>>>>搜索
NSString *const REQUEST_URL_SEARCHINFOS = @"/mobile/mobileLogin/searchInfos";

NSString *const REQUEST_URL_FindStudentDetails = @"/mobile/mobileLogin/findStudentDetails";

NSString *const REQUEST_URL_FindStaffDetails = @"/mobile/mobileLogin/findStaffDetails";


NSString *const REQUEST_URL_FindRoomInfo = @"/mobile/mobileLogin/findRoomInfo";

//>>>>>>>>>>>>>通知
NSString *const REQUEST_URL_NEWNOTICES = @"mobile/mobileLogin/noticeDetails";

NSString *const REQUEST_URL_SCHOOLNOTICES = @"/mobile/mobileLogin/findAllNotices";

NSString *const REQUEST_URL_UpadeNoticeState = @"/mobile/mobileLogin/updateNoticeState";


NSString *const REQUEST_URL_SENDNEWNOTICE = @"/mobile/mobileLogin/addNewNotice";

NSString *const REQUEST_URL_RECEIVERS = @"/mobile/mobileLogin/findOnLineUsers";

NSString *const REQUEST_URL_DELETENOTICES = @"/mobile/mobileLogin/deleteNotice";

NSString *const REQUEST_URL_FINDUSERS = @"mobile/mobileLogin/findUsers";

//>>>>>>>>>>>>>>>>>地图
NSString *const REQUEST_URL_EXAMADDRESSINFO = @"/mobile/mobileLogin/findSitesDistribution";

NSString *const REQUEST_URL_EXAMROOMLIST =  @"/mobile/mobileLogin/findMobileRooms";

NSString *const REQUEST_URL_STUDENTSEATS = @"/mobile/mobileLogin/findRoomSeat";

NSString *const REQUEST_URL_STUDENTSEARCH = @"/mobile/mobileLogin/finStudentInfoNoCode";

NSString *const REQUEST_URL_FINDUSERINFO = @"/mobile/mobileLogin/findUserInfo";
@end
