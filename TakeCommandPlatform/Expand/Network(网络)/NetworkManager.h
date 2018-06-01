//
//  NetworkManager.h
//  student_iphone
//
//  Created by jyd on 16/12/1.
//  Copyright © 2016年 he chao. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FileConfig;
#ifndef kIsNetwork
#define kIsNetwork     [PPNetworkHelper isNetwork]  // 一次性判断是否有网的宏
#endif

#ifndef kIsWWANNetwork
#define kIsWWANNetwork [PPNetworkHelper isWWANNetwork]  // 一次性判断是否为手机网络的宏
#endif

#ifndef kIsWiFiNetwork
#define kIsWiFiNetwork [PPNetworkHelper isWiFiNetwork]  // 一次性判断是否为WiFi网络的宏
#endif

typedef NS_ENUM(NSUInteger, YWNetworkStatus) {
    /** 未知网络*/
    YWNetworkStatusUnknown,
    /** 无网络*/
    YWNetworkStatusNotReachable,
    /** 手机网络*/
    YWNetworkStatusReachableViaWWAN,
    /** WIFI网络*/
    YWNetworkStatusReachableViaWiFi
};

typedef NS_ENUM(NSUInteger, YWRequestSerializer) {
    /** 设置请求数据为JSON格式*/
    YWRequestSerializerJSON,
    /** 设置请求数据为二进制格式*/
    YWRequestSerializerHTTP,
};

typedef NS_ENUM(NSUInteger, YWResponseSerializer) {
    /** 设置响应数据为JSON格式*/
    YWResponseSerializerJSON,
    /** 设置响应数据为二进制格式*/
    YWResponseSerializerHTTP,
};

/** 请求成功的Block */
typedef void(^RequestSuccess)(id responseObject);

/** 请求失败的Block */
typedef void(^RequestFailed)(NSError *error);

/** 缓存的Block */
typedef void(^RequestCache)(id responseCache);

/** 上传或者下载的进度, Progress.completedUnitCount:当前大小 - Progress.totalUnitCount:总大小*/
typedef void (^Progress)(NSProgress *progress);

/** 网络状态的Block*/
typedef void(^Status)(YWNetworkStatus status);



@interface NetworkManager : NSObject

/**
 实时获取网络状态,通过Block回调实时获取(此方法可多次调用)
 */
+ (void)networkStatusWithBlock:(Status)networkStatus;

/**
 有网YES, 无网:NO
 */
+ (BOOL)isNetwork;

/**
 手机网络:YES, 反之:NO
 */
+ (BOOL)isWWANNetwork;

/**
 WiFi网络:YES, 反之:NO
 */
+ (BOOL)isWiFiNetwork;

/**
 取消所有HTTP请求
 */
+ (void)cancelAllRequest;

/**
 取消指定URL的HTTP请求
 */
+ (void)cancelRequestWithURL:(NSString *)URL;

/**
 *  GET请求,无缓存
 *
 *  @param URL        请求地址
 *  @param parameters 请求参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 *  @return 返回的对象可取消请求,调用cancel方法
 */
+ (__kindof NSURLSessionTask *)GET:(NSString *)URL
                        parameters:(NSDictionary *)parameters
                           success:(RequestSuccess)success
                           failure:(RequestFailed)failure;

/**
 *  GET请求,自动缓存
 *
 *  @param URL           请求地址
 *  @param parameters    请求参数
 *  @param responseCache 缓存数据的回调
 *  @param success       请求成功的回调
 *  @param failure       请求失败的回调
 *
 *  @return 返回的对象可取消请求,调用cancel方法
 */
+ (__kindof NSURLSessionTask *)GET:(NSString *)URL
                        parameters:(NSDictionary *)parameters
                     responseCache:(RequestCache)responseCache
                           success:(RequestSuccess)success
                           failure:(RequestFailed)failure;

/**
 *  POST请求,无缓存
 *
 *  @param URL        请求地址
 *  @param parameters 请求参数
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 *  @return 返回的对象可取消请求,调用cancel方法
 */
+ (__kindof NSURLSessionTask *)POST:(NSString *)URL
                         parameters:(NSDictionary *)parameters
                            success:(RequestSuccess)success
                            failure:(RequestFailed)failure;

/**
 *  POST请求,自动缓存
 *
 *  @param URL           请求地址
 *  @param parameters    请求参数
 *  @param responseCache 缓存数据的回调
 *  @param success       请求成功的回调
 *  @param failure       请求失败的回调
 *
 *  @return 返回的对象可取消请求,调用cancel方法
 */
+ (__kindof NSURLSessionTask *)POST:(NSString *)URL
                         parameters:(NSDictionary *)parameters
                      responseCache:(RequestCache)responseCache
                            success:(RequestSuccess)success
                            failure:(RequestFailed)failure;

/**
 *  上传图片文件
 *
 *  @param URL        请求地址
 *  @param parameters 请求参数
 *  @param images     图片数组
 *  @param name       文件对应服务器上的字段
 *  @param fileName   文件名
 *  @param mimeType   图片文件的类型,例:png、jpeg(默认类型)....
 *  @param progress   上传进度信息
 *  @param success    请求成功的回调
 *  @param failure    请求失败的回调
 *
 *  @return 返回的对象可取消请求,调用cancel方法
 */
+ (__kindof NSURLSessionTask *)uploadWithURL:(NSString *)URL
                                  parameters:(NSDictionary *)parameters
                                      images:(NSArray<UIImage *> *)images
                                        name:(NSString *)name
                                    fileName:(NSString *)fileName
                                    mimeType:(NSString *)mimeType
                                    progress:(Progress)progress
                                     success:(RequestSuccess)success
                                     failure:(RequestFailed)failure;

/**
 *  下载文件
 *
 *  @param URL      请求地址
 *  @param fileDir  文件存储目录(默认存储目录为Download)
 *  @param progress 文件下载的进度信息
 *  @param success  下载成功的回调(回调参数filePath:文件的路径)
 *  @param failure  下载失败的回调
 *
 *  @return 返回NSURLSessionDownloadTask实例，可用于暂停继续，暂停调用suspend方法，开始下载调用resume方法
 */
+ (__kindof NSURLSessionTask *)downloadWithURL:(NSString *)URL
                                       fileDir:(NSString *)fileDir
                                      progress:(Progress)progress
                                       success:(void(^)(NSString *filePath))success
                                       failure:(RequestFailed)failure;


/*
 **************************************  说明  **********************************************
 *
 * 在一开始设计接口的时候就想着方法接口越少越好,越简单越好,只有GET,POST,上传,下载,监测网络状态就够了.
 *
 * 无奈的是在实际开发中,每个APP与后台服务器的数据交互都有不同的请求格式,如果要修改请求格式,就要在此封装
 * 内修改,再加上此封装在支持CocoaPods后,如果使用者pod update最新PPNetworkHelper,那又要重新修改此
 * 封装内的相关参数.
 *
 * 依个人经验,在项目的开发中,一般都会将网络请求部分封装 2~3 层,第2层配置好网络请求工具的在本项目中的各项
 * 参数,其暴露出的方法接口只需留出请求URL与参数的入口就行,第3层就是对整个项目请求API的封装,其对外暴露出的
 * 的方法接口只留出请求参数的入口.这样如果以后项目要更换网络请求库或者修改请求URL,在单个文件内完成配置就好
 * 了,大大降低了项目的后期维护难度
 *
 * 综上所述,最终还是将设置参数的接口暴露出来,如果通过CocoaPods方式使用PPNetworkHelper,在设置项目网络
 * 请求参数的时候,强烈建议开发者在此基础上再封装一层,通过以下方法配置好各种参数与请求的URL,便于维护
 *
 **************************************  说明  **********************************************
 */

#pragma mark - 重置AFHTTPSessionManager相关属性
/**
 *  设置网络请求参数的格式:默认为JSON格式
 *
 *  @param requestSerializer RWRequestSerializerJSON(JSON格式),PPRequestSerializerHTTP(二进制格式),
 */
+ (void)setRequestSerializer:(YWRequestSerializer)requestSerializer;

/**
 *  设置服务器响应数据格式:默认为JSON格式
 *
 *  @param responseSerializerRWResponseSerializerJSON(JSON格式),PPResponseSerializerHTTP(二进制格式)
 */
+ (void)setResponseSerializer:(YWResponseSerializer)responseSerializer;

/**
 *  设置请求超时时间:默认为30S
 *
 *  @param time 时长
 */
+ (void)setRequestTimeoutInterval:(NSTimeInterval)time;

/**
 *  设置请求头
 */
+ (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field;


/**
 *  @brief 上传文件
 *
 *  @param files               文件模型
 *  @param progress            上传进度
 *  @param completion          <#completion description#>
 *  @param failure             <#failure description#>
 */

+ (__kindof NSURLSessionTask *)uploadFiles:(FileConfig *)files
           progress:(Progress)progress
            success:(RequestSuccess)success
            failure:(RequestFailed)failure;



@end

#pragma mark -- FileConfig

/**
 *  @brief 用来封装上文件数据的模型类
 */
@interface FileConfig :NSObject


/**
 *  @brief url
 */
@property (nonatomic, strong) NSString *url;

/**
 *  @brief 文件数据:可为url或data
 */
@property (nonatomic, strong) NSArray *fileDatas;

/**
 *  @brief 服务器接收参数
 */
@property (nonatomic, copy) NSString *serverName;


/**
 *  @brief 上传文件名:可不传
 */
@property (nonatomic, copy) NSArray *fileNames;

/**
 *  @brief 文件类型
 */
@property (nonatomic, copy) NSString *mimeType;


/**
 *  @brief 上传参数
 */
@property (nonatomic, copy) NSDictionary *parameter;


+ (instancetype)fileConfigWithUrl:(NSString *)url
                         fileData:(NSArray *)fileDatas
                        serveName:(NSString *)serveName
                         fileName:(NSArray *)fileNames
                         mimeType:(NSString *)mimeType;

- (instancetype)initWithUrl:(NSString *)url
                   fileData:(NSArray *)fileDatas
                  serveName:(NSString *)serveName
                  fileNames:(NSArray *)fileNames
                   mimeType:(NSString *)mimeType;

@end
