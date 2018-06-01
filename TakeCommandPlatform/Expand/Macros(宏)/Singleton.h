//
//  Singleton.h
//  TakeCommandPlatform
//
//  Created by jyd on 2018/3/1.
//  Copyright © 2018年 jyd. All rights reserved.
//

#ifndef Singleton_h
#define Singleton_h

// .h
#define singleton_interface(class) + (instancetype)shared##class;

// .m
#define singleton_implementation(class) \
static class *_instance; \
\
+ (id)allocWithZone:(struct _NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
\
return _instance; \
} \
\
+ (instancetype)shared##class \
{ \
if (_instance == nil) { \
_instance = [[class alloc] init]; \
} \
\
return _instance; \
}


#endif /* Singleton_h */
