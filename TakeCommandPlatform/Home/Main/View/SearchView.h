//
//  SearchView.h
//  TakeCommandPlatform
//
//  Created by jyd on 2017/12/13.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol  StudentSearchDelegate <NSObject>

///学生搜索界面
- (void)jumpStudentSearchVC;

@end
@interface SearchView : UIView

/** delegate */
@property (nonatomic,weak) id<StudentSearchDelegate> delegate;
@end
