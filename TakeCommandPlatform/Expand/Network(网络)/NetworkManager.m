//
//  NetworkManager.m
//  student_iphone
//
//  Created by jyd on 16/12/1.
//  Copyright © 2016年 he chao. All rights reserved.
//

#import "NetworkManager.h"

#import "AFNetworking.h"

#ifdef DEBUG
#define YWLog(...) printf("[%s] %s [第%d行]: %s\n", __TIME__ ,__PRETTY_FUNCTION__ ,__LINE__, [[NSString stringWithFormat:__VA_ARGS__] UTF8String])
#else
#define YWLog(...)
#endif


@implementation NetworkManager

static AFHTTPSessionManager *_sessionManager;
static NSMutableArray *_allSessionTask;

#pragma mark - 开始监听网络
+ (void)networkStatusWithBlock:(Status)networkStatus
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        AFNetworkReachabilityManager *reachabilityManager = [AFNetworkReachabilityManager sharedManager];
        [reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status)
            {
                case AFNetworkReachabilityStatusUnknown:
                    networkStatus ? networkStatus(YWNetworkStatusUnknown) : nil;
                    YWLog(@"未知网络");
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                    networkStatus ? networkStatus(YWNetworkStatusNotReachable) : nil;
                    YWLog(@"无网络");
                    break;
                case AFNetworkReachabilityStatusReachableViaWWAN:
                    networkStatus ? networkStatus(YWNetworkStatusReachableViaWWAN) : nil;
                    YWLog(@"手机自带网络");
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi:
                    networkStatus ? networkStatus(YWNetworkStatusReachableViaWiFi) : nil;
                    YWLog(@"WIFI");
                    break;
            }
        }];
        
        [reachabilityManager startMonitoring];
    });
}

+ (BOOL)isNetwork
{
    return [AFNetworkReachabilityManager sharedManager].reachable;
}

+ (BOOL)isWWANNetwork
{
    return [AFNetworkReachabilityManager sharedManager].reachableViaWWAN;
}

+ (BOOL)isWiFiNetwork
{
    return [AFNetworkReachabilityManager sharedManager].reachableViaWiFi;
}

+ (void)cancelAllRequest
{
    // 锁操作
    @synchronized(self)
    {
        [[self allSessionTask] enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            [task cancel];
        }];
        [[self allSessionTask] removeAllObjects];
    }
}

+ (void)cancelRequestWithURL:(NSString *)URL
{
    if (!URL) { return; }
    @synchronized (self)
    {
        [[self allSessionTask] enumerateObjectsUsingBlock:^(NSURLSessionTask  *_Nonnull task, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([task.currentRequest.URL.absoluteString hasPrefix:URL]) {
                [task cancel];
                [[self allSessionTask] removeObject:task];
                *stop = YES;
            }
        }];
    }
}

#pragma mark - GET请求无缓存

+ (NSURLSessionTask *)GET:(NSString *)URL
               parameters:(NSDictionary *)parameters
                  success:(RequestSuccess)success
                  failure:(RequestFailed)failure
{
    return [self GET:URL parameters:parameters responseCache:nil success:success failure:failure];
}


#pragma mark - POST请求无缓存

+ (NSURLSessionTask *)POST:(NSString *)URL
                parameters:(NSDictionary *)parameters
                   success:(RequestSuccess)success
                   failure:(RequestFailed)failure
{
    return [self POST:URL parameters:parameters responseCache:nil success:success failure:failure];
}


#pragma mark - GET请求自动缓存

+ (NSURLSessionTask *)GET:(NSString *)URL
               parameters:(NSDictionary *)parameters
            responseCache:(RequestCache)responseCache
                  success:(RequestSuccess)success
                  failure:(RequestFailed)failure
{
    //读取缓存
//    responseCache ? responseCache([PPNetworkCache httpCacheForURL:URL parameters:parameters]) : nil;
    
    NSURLSessionTask *sessionTask = [_sessionManager GET:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[self allSessionTask] removeObject:task];
        success ? success(responseObject) : nil;
        //对数据进行异步缓存
//        responseCache ? [PPNetworkCache setHttpCache:responseObject URL:URL parameters:parameters] : nil;
        YWLog(@"responseObject = %@",[self jsonToString:responseObject]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[self allSessionTask] removeObject:task];
        failure ? failure(error) : nil;
        YWLog(@"error = %@",error);
        
    }];
    // 添加sessionTask到数组
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
    
    return sessionTask;
}


#pragma mark - POST请求自动缓存

+ (NSURLSessionTask *)POST:(NSString *)URL
                parameters:(NSDictionary *)parameters
             responseCache:(RequestCache)responseCache
                   success:(RequestSuccess)success
                   failure:(RequestFailed)failure
{
    //读取缓存
//    responseCache ? responseCache([PPNetworkCache httpCacheForURL:URL parameters:parameters]) : nil;
    
    NSURLSessionTask *sessionTask = [_sessionManager POST:URL parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[self allSessionTask] removeObject:task];
        success ? success(responseObject) : nil;
        //对数据进行异步缓存
//        responseCache ? [PPNetworkCache setHttpCache:responseObject URL:URL parameters:parameters] : nil;
        YWLog(@"responseObject = %@",[self jsonToString:responseObject]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[self allSessionTask] removeObject:task];
        failure ? failure(error) : nil;
        YWLog(@"error = %@",error);
        
    }];
    
    // 添加最新的sessionTask到数组
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
    return sessionTask;
}

#pragma mark - 上传图片文件

+ (NSURLSessionTask *)uploadWithURL:(NSString *)URL
                         parameters:(NSDictionary *)parameters
                             images:(NSArray<UIImage *> *)images
                               name:(NSString *)name
                           fileName:(NSString *)fileName
                           mimeType:(NSString *)mimeType
                           progress:(Progress)progress
                            success:(RequestSuccess)success
                            failure:(RequestFailed)failure
{
    
    NSURLSessionTask *sessionTask = [_sessionManager POST:URL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        if (images.count == 0) {
            NSMutableString *str = [NSMutableString string];
            [formData appendPartWithFormData:[[str copy] dataUsingEncoding:NSUTF8StringEncoding] name:@"noImgid"];
        } else {
            //压缩-添加-上传图片
            [images enumerateObjectsUsingBlock:^(UIImage * _Nonnull image, NSUInteger idx, BOOL * _Nonnull stop) {
                
                NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
                [formData appendPartWithFileData:imageData name:name fileName:[NSString stringWithFormat:@"%@%lu.%@",fileName,(unsigned long)idx,mimeType?mimeType:@"jpeg"] mimeType:[NSString stringWithFormat:@"image/%@",mimeType ? mimeType : @"jpeg"]];
            }];
        }
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //上传进度
        dispatch_sync(dispatch_get_main_queue(), ^{
            progress ? progress(uploadProgress) : nil;
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [[self allSessionTask] removeObject:task];
        success ? success(responseObject) : nil;
        YWLog(@"responseObject = %@",[self jsonToString:responseObject]);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [[self allSessionTask] removeObject:task];
        failure ? failure(error) : nil;
        YWLog(@"error = %@",error);
        
    }];
    
    // 添加sessionTask到数组
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
    
    return sessionTask;
}

#pragma mark - 下载文件
+ (NSURLSessionTask *)downloadWithURL:(NSString *)URL
                              fileDir:(NSString *)fileDir
                             progress:(Progress)progress
                              success:(void(^)(NSString *))success
                              failure:(RequestFailed)failure
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URL]];
    NSURLSessionDownloadTask *downloadTask = [_sessionManager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        //下载进度
        dispatch_sync(dispatch_get_main_queue(), ^{
            progress ? progress(downloadProgress) : nil;
        });
        YWLog(@"下载进度:%.2f%%",100.0*downloadProgress.completedUnitCount/downloadProgress.totalUnitCount);
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        
        //拼接缓存目录
        NSString *downloadDir = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:fileDir ? fileDir : @"Download"];
        
        //打开文件管理器
        NSFileManager *fileManager = [NSFileManager defaultManager];
        //创建Download目录
        [fileManager createDirectoryAtPath:downloadDir withIntermediateDirectories:YES attributes:nil error:nil];
        //拼接文件路径
        NSString *filePath = [downloadDir stringByAppendingPathComponent:response.suggestedFilename];
        
        YWLog(@"downloadDir = %@",downloadDir);
        //返回文件位置的URL路径
        return [NSURL fileURLWithPath:filePath];
        
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
        [[self allSessionTask] removeObject:downloadTask];
        if(failure && error) {failure(error) ; return ;};
        success ? success(filePath.absoluteString /** NSURL->NSString*/) : nil;
        
    }];
    
    //开始下载
    [downloadTask resume];
    
    // 添加sessionTask到数组
    downloadTask ? [[self allSessionTask] addObject:downloadTask] : nil ;
    return downloadTask;
}

#pragma mark — 上传文件
+ (__kindof NSURLSessionTask *)uploadFiles:(FileConfig *)files
                                  progress:(Progress)progress
                                   success:(RequestSuccess)success
                                   failure:(RequestFailed)failure
{
    NSURLSessionTask *sessionTask = [_sessionManager POST:files.url parameters:files.parameter constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i<files.fileDatas.count; i++) {
            
            NSDate *date = [NSDate date];
            NSDateFormatter *formate = [[NSDateFormatter alloc]init];
            formate.dateFormat = @"yyyy/MM/dd hh:mm:ss";
            NSString *dateString = [formate stringFromDate:date];
            
            //photo:
            NSString *fileName = [dateString stringByAppendingString:@".jpg"];
            //or
            // NSString *fileName = date;
            
            
            //name:服务器上传文件名字  fileName:上传图片的名字  mineType:服务器指定的type:
            //formData拼接所有图片url或data数据
            
            if([files.fileDatas[i] isKindOfClass:[NSData class]])
            {
                if (files.fileNames) {
                    [formData appendPartWithFileData:files.fileDatas[i] name:files.serverName fileName:files.fileNames[i] mimeType:files.mimeType];
                }else{
                    
                    [formData appendPartWithFileData:files.fileDatas[i] name:files.serverName fileName:fileName mimeType:files.mimeType];
                }
                
            }
            else{
                
                if (files.fileNames) {
                    [formData appendPartWithFileURL:files.fileDatas[i] name:files.serverName fileName:files.fileNames[i] mimeType:files.mimeType error:nil];
                }else{
                    [formData appendPartWithFileURL:files.fileDatas[i] name:files.serverName fileName:fileName mimeType:files.mimeType error:nil];
                }
                
            }
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        dispatch_sync(dispatch_get_main_queue(), ^{
            progress ? progress(uploadProgress) : nil;
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [[self allSessionTask] removeObject:task];
        success ? success(responseObject) : nil;
        YWLog(@"responseObject = %@",[self jsonToString:responseObject]);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [[self allSessionTask] removeObject:task];
        failure ? failure(error) : nil;
        YWLog(@"error = %@",error);
    }];
    
    // 添加最新的sessionTask到数组
    sessionTask ? [[self allSessionTask] addObject:sessionTask] : nil ;
    return sessionTask;
}

/**
 *  json转字符串
 */
+ (NSString *)jsonToString:(id)data
{
    if(!data) { return nil; }
    //是否可以json解析
    if (![NSJSONSerialization isValidJSONObject:data]) {
        return nil;
    }
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

/**
 存储着所有的请求task数组
 */
+ (NSMutableArray *)allSessionTask
{
    if (!_allSessionTask)
    {
        _allSessionTask = [[NSMutableArray alloc] init];
    }
    return _allSessionTask;
}
#pragma mark - 初始化AFHTTPSessionManager相关属性
/**
 *  所有的HTTP请求共享一个AFHTTPSessionManager,原理参考地址:http://www.jianshu.com/p/5969bbb4af9f
 *  + (void)initialize该初始化方法在当用到此类时候只调用一次
 */
+ (void)initialize
{
    _sessionManager = [AFHTTPSessionManager manager];
    // 设置请求参数的类型:JSON (AFJSONRequestSerializer,AFHTTPRequestSerializer)
//    _sessionManager.requestSerializer = [AFJSONRequestSerializer serializer];
    // 设置请求的超时时间
    _sessionManager.requestSerializer.timeoutInterval = 30.f;
    // 设置服务器返回结果的类型:JSON (AFJSONResponseSerializer,AFHTTPResponseSerializer)
    _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/json", @"text/plain", @"text/javascript", @"text/xml", @"image/*", @"multipart/form-data", @"image/jpeg", @"image/png", @"application/octet-stream", nil];
    
   
}

#pragma mark - 重置AFHTTPSessionManager相关属性
+ (void)setRequestSerializer:(YWRequestSerializer)requestSerializer
{
    _sessionManager.requestSerializer = requestSerializer==YWRequestSerializerHTTP ? [AFHTTPRequestSerializer serializer] : [AFJSONRequestSerializer serializer];
}

+ (void)setResponseSerializer:(YWResponseSerializer)responseSerializer
{
    _sessionManager.responseSerializer = responseSerializer==YWResponseSerializerHTTP ? [AFHTTPResponseSerializer serializer] : [AFJSONResponseSerializer serializer];
}

+ (void)setRequestTimeoutInterval:(NSTimeInterval)time
{
    _sessionManager.requestSerializer.timeoutInterval = time;
}

+ (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field
{
    [_sessionManager.requestSerializer setValue:value forHTTPHeaderField:field];
}


@end


@implementation FileConfig

+ (instancetype)fileConfigWithUrl:(NSString *)url
                         fileData:(NSArray *)fileDatas
                        serveName:(NSString *)serveName
                         fileName:(NSArray *)fileNames
                         mimeType:(NSString *)mimeType
{
    return [[self alloc]initWithUrl:url
                           fileData:fileDatas
                          serveName:serveName
                          fileNames:fileNames
                           mimeType:mimeType];
}

- (instancetype)initWithUrl:(NSString *)url
                   fileData:(NSArray *)fileDatas
                  serveName:(NSString *)serveName
                  fileNames:(NSArray *)fileNames
                   mimeType:(NSString *)mimeType
{
    if (self = [super init]) {
        _url = url;
        _fileDatas  = fileDatas;
        _serverName = serveName;
        _fileNames = fileNames;
        _mimeType = mimeType;
    }
    return self;
}
@end


#pragma mark - NSDictionary,NSArray的分类
/*
 ************************************************************************************
 *新建NSDictionary与NSArray的分类, 控制台打印json数据中的中文
 ************************************************************************************
 */

#ifdef DEBUG
@implementation NSArray (YW)

- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *strM = [NSMutableString stringWithString:@"(\n"];
    
    [self enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        [strM appendFormat:@"\t%@,\n", obj];
    }];
    
    [strM appendString:@")"];
    
    return strM;
}

@end

@implementation NSDictionary (YW)

- (NSString *)descriptionWithLocale:(id)locale
{
    NSMutableString *strM = [NSMutableString stringWithString:@"{\n"];
    
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
        [strM appendFormat:@"\t%@ = %@;\n", key, obj];
    }];
    
    [strM appendString:@"}\n"];
    
    return strM;
}
@end
#endif



