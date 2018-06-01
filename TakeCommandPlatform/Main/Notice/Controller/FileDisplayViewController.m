//
//  FileDisplayViewController.m
//  TakeCommandPlatform
//
//  Created by jyd on 2018/1/8.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import "FileDisplayViewController.h"
#import "NoticeModel.h"
@interface FileDisplayViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *file;

@end

@implementation FileDisplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    Notice *model;
//    if (kUserIsSchoolLevel) {
//        model = self.model;
//    } else {
//        NoticeModel *notice = self.model;
//        model = notice.notice;
//    }
//    self.title = model.filename;
//    [_file sd_setImageWithURL:(NSURL *)[NSString stringWithFormat:@"%@%@",kServiceAdress, model.url]];
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
