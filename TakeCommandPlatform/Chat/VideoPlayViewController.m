//
//  VideoPlayViewController.m
//  TakeCommandPlatform
//
//  Created by jyd on 2018/3/12.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import "VideoPlayViewController.h"
#import "ZFPlayerView.h"
@interface VideoPlayViewController ()

/** playView */
@property (nonatomic, strong) ZFPlayerView *playerView;


@end

@implementation VideoPlayViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [UIApplication sharedApplication].statusBarHidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.playerView = [ZFPlayerView setupZFPlayer];
    [self.view addSubview:self.playerView];
    [self.playerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.centerY.equalTo(self.view);
        make.height.equalTo(self.playerView.mas_width).multipliedBy(9.0f/16.0f);
    }];
    
    self.playerView.videoURL = self.videoURL;
    __weak typeof(self) weakSelf = self;
    self.playerView.goBackBlock = ^{
        [weakSelf dismissViewControllerAnimated:NO completion:nil];
    };
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait) {
        self.view.backgroundColor  = [UIColor whiteColor];
    }else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        self.view.backgroundColor = [UIColor blackColor];
    }
}


-(void)dealloc
{
    [self.playerView cancelAutoFadeOutControlBar];
}

@end
