//
//  NoticeDetailsViewController.m
//  TakeCommandPlatform
//
//  Created by jyd on 2017/12/18.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import "NoticeDetailsViewController.h"
#import "NoticeModel.h"

#import "FileDisplayViewController.h"
#import "ReceiverView.h"
@interface NoticeDetailsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *toppic;
@property (weak, nonatomic) IBOutlet UILabel *sender;
@property (weak, nonatomic) IBOutlet UILabel *sendTime;
@property (weak, nonatomic) IBOutlet UILabel *receiverLabel;
@property (weak, nonatomic) IBOutlet UIButton *receiver;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *fileName;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentY;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *receiverY;

/** 接收 */
@property (nonatomic, strong) ReceiverView *receiverView;


@end

@implementation NoticeDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"通知详情";
    [self showNoticeDetails];
}

///显示通知信息
- (void)showNoticeDetails
{
    ReceiverView *receiver = [[ReceiverView alloc] init];
    [self.view addSubview:receiver];
    [receiver mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(100);
        make.left.right.bottom.equalTo(self.view);
    }];
    receiver.isDetails = YES;
    receiver.detailsReceiberArray = [NSArray arrayWithArray:_model.receiver];
    receiver.hidden = YES;
    _receiverView = receiver;
    _toppic.text = _model.title;
    _sender.text = _model.username;
    _sendTime.text = _model.send_time;
    [_receiver setTitle:[NSString stringWithFormat:@"已发送:%d      已阅读:%d",_model.reader_count, _model.readernum] forState: UIControlStateNormal] ;
    _content.text = _model.content;
    CGSize size = [_model.content sizeHeightFont:_content.font size:CGSizeMake(245, 0)];
   _contentHeight.constant = size.height;

    _fileName.text = _model.filename;
    
//    if (kUserIsSchoolLevel) {
//        _receiver.hidden = YES;
//        _receiverLabel.hidden = YES;
//        _contentY.constant = -21;
//
//    }
    
    //阅读状态
    NSString *url = [NSString stringWithFormat:@"%@%@",kServiceAdress, REQUEST_URL_UpadeNoticeState];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    [NetworkManager setResponseSerializer:YWResponseSerializerHTTP];
    param[@"userid"] = kUserId;
    param[@"noticeid"] = _model.notice_id;
    [NetworkManager POST:url parameters:param success:^(id responseObject) {
        
    } failure:^(NSError *error) {
        
    }];
    
    
   
}

- (IBAction)fileBtnClick:(UIButton *)sender {
    Notice *model;
//    if (kUserIsSchoolLevel) {
//        model = self.model;
//    } else {
//        NoticeModel *notice = self.model;
//        model = notice.notice;
//    }
//    if (model.url.length == 0) {
//        [MBProgressHUD showError:@"无附件"];
//        return;
//    }
    FileDisplayViewController *display = [[FileDisplayViewController alloc] init];
    display.model = _model;
    [self.navigationController pushViewController:display animated:YES];
}

- (IBAction)receiverBtnClick:(UIButton *)sender {
    
    _receiverView.hidden = NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _receiverView.hidden = YES;
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
