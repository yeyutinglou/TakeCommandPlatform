//
//  SearchViewController.h
//  TakeCommandPlatform
//
//  Created by jyd on 2018/3/23.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, SearchType) {
    ///考点
    SearchTypeExamAddress,
    ///考生
    SearchTypeExaminee,
    ///考场
    SearchTypeExamPlace,
    ///考务人员
    SearchTypeExamManager
};


@interface SearchViewController : UIViewController

/** 是否是搜索结果页面 */
@property (nonatomic, assign) BOOL isResult;

/** 搜索类型 */
@property (nonatomic, assign) SearchType searchType;

/** 搜索内容 */
@property (nonatomic, copy) NSString *text;

@end
