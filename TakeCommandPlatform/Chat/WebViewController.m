//
//  WebViewController.m
//  TakeCommandPlatform
//
//  Created by jyd on 2018/3/13.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()<UIWebViewDelegate>

/** activityView */
@property (nonatomic, strong) UIActivityIndicatorView *activityView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI];
}

- (void)setupUI
{
    UIWebView *web = [[UIWebView alloc]initWithFrame:self.view.bounds];
    web.delegate = self;
    
    [web loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.url]]];
    [self.view addSubview:web];
    
    
    
    self.activityView = [[UIActivityIndicatorView alloc]init];
    
    self.activityView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.activityView startAnimating];
    self.activityView.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, CGRectGetHeight(self.view.frame)/2);
    [self.view addSubview:self.activityView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self.activityView stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self.activityView stopAnimating];
}



@end
