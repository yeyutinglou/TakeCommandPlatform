//
//  NSObject+Log.m
//  KVO
//
//  Created by jyd on 2017/7/6.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import "NSObject+Log.h"

@implementation NSObject (Log)


+ (void)resolveDic:(NSDictionary *)dic
{
    //拼接属性字符串
    NSMutableString *strM = [NSMutableString string];
    //遍历字典,把所以key取出,生成对应的属性代码
    [dic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        //类型
        NSString *type;
        if ([obj isKindOfClass:NSClassFromString(@"NSString")]) {
            type = @"NSString";
        } else if ([obj isKindOfClass:NSClassFromString(@"NSArray")]) {
            type = @"NSArray";
        }else if ([obj isKindOfClass:NSClassFromString(@"NSNumber")]) {
            type = @"int";
        } else if ([obj isKindOfClass:NSClassFromString(@"NSDictionary")]) {
            type = @"NSDictionary";
        }
        
        //属性字符串
        NSString *str;
        if ([type containsString:@"NS"]) {
            str = [NSString stringWithFormat:@"@property (nonatomic, strong) %@ *%@;",type,key];
        } else {
            str = [NSString stringWithFormat:@"@property (nonatomic, assign) %@ %@;",type,key];
        }
        
        //生成属性字符串,自动换行
        [strM appendFormat:@"\n%@\n",str];
        
    }];
    
    NSLog(@"%@",strM);
    
}

@end
