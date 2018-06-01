//
//  HttpRequest.m
//  wenbaStudentProject
//
//  Created by jyd on 16/5/20.
//  Copyright © 2016年 jydZJ. All rights reserved.
//

#import "ZJHttpRequest.h"
#import "AFNetworking.h"

@implementation ZJHttpRequest

static id _instance = nil;
+ (instancetype)sharedInstance {
    return [[self alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

- (instancetype)init {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super init];
        AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
        [manager startMonitoring];
        [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            switch (status) {
                case AFNetworkReachabilityStatusUnknown:
                {
                    // 位置网络
                    NSLog(@"位置网络");
                }
                    break;
                case AFNetworkReachabilityStatusNotReachable:
                {
                    // 无法联网
                    NSLog(@"无法联网");
                }
                    break;
                case AFNetworkReachabilityStatusReachableViaWiFi:
                {
                    // 手机自带网络
                    NSLog(@"当前使用的是2G/3G/4G网络");
                }
                    break;
                case AFNetworkReachabilityStatusReachableViaWWAN:
                {
                    // WIFI
                    NSLog(@"当前在WIFI网络下");
                }
            }
        }];
    });
    return _instance;
}

#pragma mark -- GET请求 --
+ (void)getWithURLString:(NSString *)URLString
          headParameters:(id)headParameters
          bodyParameters:(id)bodyParameters
                 success:(void (^)(id))success
                 failure:(void (^)(NSError *))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    /**
     *  可以接受的类型
     */
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    /**
     *  请求队列的最大并发数
     */
    //    manager.operationQueue.maxConcurrentOperationCount = 5;
    
    /**
     *  请求超时的时间
     */
    manager.requestSerializer.timeoutInterval = 30;
    
    [manager GET:URLString parameters:bodyParameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark -- POST请求 --
+ (void)postWithURLString:(NSString *)URLString
           headParameters:(id)headParameters
           bodyParameters:(id)bodyParameters
                  success:(void (^)(id))success
                  failure:(void (^)(NSError *))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:URLString parameters:bodyParameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

#pragma mark -- POST/GET网络请求 --
+ (void)requestWithURLString:(NSString *)URLString
              headParameters:(id)headParameters
              bodyParameters:(id)bodyParameters
                        type:(HttpRequestType)type
                     success:(void (^)(id))success
                     failure:(void (^)(NSError *))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    switch (type) {
        case HttpRequestTypeGet:
        {
            [manager GET:URLString parameters:bodyParameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure(error);
                }
            }];
        }
            break;
        case HttpRequestTypePost:
        {
            [manager POST:URLString parameters:bodyParameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                if (success) {
                    success(responseObject);
                }
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                if (failure) {
                    failure(error);
                }
            }];
        }
            break;
    }
}

#pragma mark -- 上传图片 --
+ (void)uploadWithURLString:(NSString *)URLString
             headParameters:(id)headParameters
             bodyParameters:(id)bodyParameters
                uploadParam:(UploadParam *)uploadParam
                    success:(void (^)())success
                    failure:(void (^)(NSError *))failure {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:URLString parameters:bodyParameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:uploadParam.data name:uploadParam.name fileName:uploadParam.filename mimeType:uploadParam.mimeType];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
    }];
}

//get请求
/*
 [HttpRequest getWithURLString:@"http://1000phone.net:8088/app/iAppFree/api/limited.php?page=1&number=20" parameters:nil success:^(id responseObject) {
 id json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
 NSLog(@"%@",json);
 } failure:^(NSError *error) {
 NSLog(@"请求失败");
 }];
 */


//post请求
/*
 NSMutableDictionary *params = [NSMutableDictionary dictionary];
 params[@"page"] = @"1";
 params[@"number"] = @"20";
 [HttpRequest postWithURLString:@"http://1000phone.net:8088/app/iAppFree/api/limited.php" parameters:params success:^(id responseObject) {
 id json = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
 NSLog(@"--------------------%@",json);
 } failure:^(NSError *error) {
 NSLog(@"--------------------请求失败");
 }];
 */

/*
//2合1
UIImageView *iamgeV = [[UIImageView alloc] init];
iamgeV.frame = [UIScreen mainScreen].bounds;
[self.view addSubview:iamgeV];
[HttpRequest requestWithURLString:@"http://b.hiphotos.baidu.com/zhidao/wh%3D600%2C800/sign=abb1ea66bb12c8fcb4a6fecbcc33be7d/4ec2d5628535e5dd3e2b3d9974c6a7efce1b6275.jpg" parameters:nil type:HttpRequestTypeGet success:^(id responseObject) {
    iamgeV.image = [UIImage imageWithData:responseObject];
} failure:^(NSError *error) {
    NSLog(@"请求错误");
}];
  */

@end

