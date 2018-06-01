//
//  HomeViewController.m
//  TakeCommandPlatform
//
//  Created by jyd on 2017/12/12.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import "HomeViewController.h"
#import "MapViewController.h"
#import "SearchView.h"
#import "AreaView.h"
#import "NewMessageView.h"
#import "NoticeViewController.h"
#import "NoticeDetailsViewController.h"
#import "MapViewController.h"
#import "StudentSearchViewController.h"
#import "NoticeViewController.h"
#import "VideoPhoneViewController.h"
@interface HomeViewController ()<AreaDelegate, NewMessageDelegate, StudentSearchDelegate>

/** scrollView */
@property (nonatomic, strong) UIScrollView *scrollView;

/** 通知信息 */
@property (nonatomic, strong) NSArray *noticeArray;

/** 业务 */
@property (nonatomic, strong) AreaView *areaView;


/** 通知 */
@property (nonatomic, strong) NewMessageView *messageView;


@end

@implementation HomeViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_messageView getNewMessageData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setupContainerView];
    
}

///创建界面
- (void)setupContainerView
{
    _scrollView = [[UIScrollView alloc] init];
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.view);
    }];
    SearchView *search = [[SearchView alloc] init];
    [_scrollView addSubview:search];
    search.delegate = self;
    [search mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(_scrollView);
        make.height.mas_equalTo(60);
        make.width.equalTo(_scrollView);
    }];
    
    AreaView *area = [[AreaView alloc] init];
    area.delegate = self;
    [_scrollView addSubview:area];
    [area mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(search.mas_bottom).offset(10);
        make.left.right.equalTo(_scrollView);
        make.height.mas_equalTo(180);
        make.width.equalTo(_scrollView);
    }];
    _areaView = area;
    
    NewMessageView *newMessage = [[NewMessageView alloc] init];
    newMessage.delegate = self;
    [_scrollView addSubview:newMessage];
    [newMessage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(area.mas_bottom).offset(10);
        make.left.right.equalTo(_scrollView);
        make.height.mas_equalTo(200);
         make.width.equalTo(_scrollView);
    }];
    _messageView = newMessage;
}


#pragma mark - StudentSearchDelegate
- (void)jumpStudentSearchVC
{
    StudentSearchViewController *search = [[StudentSearchViewController alloc] init];
    [self.navigationController pushViewController:search animated:YES];
}


#pragma mark - AreaDelegate
- (void)businessAreaBtnClick:(UIButton *)sender
{
    NSInteger tag = sender.tag;
    switch (tag) {
        case 1:
            {
                MapViewController *map = [[MapViewController alloc] init];
                [self.navigationController pushViewController:map animated:YES];
            }
            break;
        case 2:
            {
                NoticeViewController *notice = [[NoticeViewController alloc] init];
//                notice.noticeArray = [NSArray arrayWithArray:_noticeArray];
                [self.navigationController pushViewController:notice animated:YES];
            
            }
            break;
        case 3:
        {
            
        }
            break;
        case 4:
        {
            VideoPhoneViewController *videoPhone = [[VideoPhoneViewController alloc] init];
            [self.navigationController pushViewController:videoPhone animated:YES];
        }
            break;
        case 5:
        {
            
        }
            break;
        case 6:
        {
            
        }
            break;
        case 7:
        {
            
        }
            break;
        case 8:
        {
            
        }
            break;
        default:
            break;
    }
}

#pragma mark - NewMessageDelegate
- (void)didSelectRowFromModel:(id)model
{
    NoticeDetailsViewController *deatils = [[NoticeDetailsViewController alloc] init];
    deatils.model = model;
    [self.navigationController pushViewController:deatils animated:YES];
}

- (void)lookAllNotice:(NSArray *)arr
{
    NoticeViewController *notice = [[NoticeViewController alloc] init];
//    notice.noticeArray = [NSArray arrayWithArray:arr];
    [self.navigationController pushViewController:notice animated:YES];
}

- (void)getAllNotice:(NSArray *)arr
{
    ///获取数据,改变消息控件大小
    _noticeArray = [NSArray arrayWithArray:arr];
    [_messageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_areaView.mas_bottom).offset(10);
        make.left.right.equalTo(_scrollView);
        make.height.mas_equalTo(40 + arr.count * 40);
        make.width.equalTo(_scrollView);
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
