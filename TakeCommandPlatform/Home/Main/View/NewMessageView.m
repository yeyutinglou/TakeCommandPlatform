//
//  NewMessageView.m
//  TakeCommandPlatform
//
//  Created by jyd on 2017/12/14.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import "NewMessageView.h"
#import "NoticeModel.h"
#import "NewMessageCell.h"

@interface NewMessageView () <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *messageTableView;
@property (weak, nonatomic) IBOutlet UIButton *moreBtn;

/** 市级通知数据 */
@property (nonatomic, strong) NSArray *noticeArray;

/** 校级通知数据 */
@property (nonatomic, strong) NSArray *schoolNoticeArray;



@end

@implementation NewMessageView



- (instancetype)init
{
    NewMessageView *messageView;
    if (!messageView) {
        messageView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return messageView;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    _messageTableView.dataSource = self;
    _messageTableView.delegate = self;
    _messageTableView.rowHeight = 40;
    
//    [self getNewMessageData];
}

- (void)getNewMessageData
{
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    params[@"userid"] = kUserId;
    params[@"sessionid"] = kUserSessionid;
    [NetworkManager setResponseSerializer:YWResponseSerializerJSON];
//    if (kUserIsSchoolLevel) {
        NSString *url = [NSString stringWithFormat:@"%@%@",kServiceAdress,REQUEST_URL_SCHOOLNOTICES];
        [NetworkManager POST:url parameters:params success:^(id responseObject) {
//            _schoolNoticeArray = [NSArray yy_modelArrayWithClass:[SchoolNoticeModel class] json:responseObject];
            if (_schoolNoticeArray.count < 4) {
                _moreBtn.hidden = YES;
            } else {
                _moreBtn.hidden = NO;
            }
        
            [_messageTableView reloadData];
        } failure:^(NSError *error) {
            
        }];
//    } else {
//        NSString *url = [NSString stringWithFormat:@"%@%@",kServiceAdress,REQUEST_URL_NEWNOTICES];
        [NetworkManager POST:url parameters:params success:^(id responseObject) {
            _noticeArray = [NSArray yy_modelArrayWithClass:[NoticeModel class] json:responseObject[@"content"]];
            if (_noticeArray.count < 4) {
                _moreBtn.hidden = YES;
            } else {
                _moreBtn.hidden = NO;
            }
            [_messageTableView reloadData];
        } failure:^(NSError *error) {
            
        }];
//    }
    
   
}

- (IBAction)moreNewMessage:(UIButton *)sender {
    
    if (_delegate && [_delegate respondsToSelector:@selector(lookAllNotice:)]) {
//        if (kUserIsSchoolLevel) {
            [_delegate lookAllNotice:_schoolNoticeArray];
//        } else {
            [_delegate lookAllNotice:_noticeArray];
//        }
        
    }
    
}

#pragma mark - UITableViewDataSource / Delegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//    if (kUserIsSchoolLevel) {
//        return _schoolNoticeArray.count > 4 ? 4  : _schoolNoticeArray.count;
//    }
    return _noticeArray.count > 4 ? 4  : _noticeArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewMessageCell *cell = [NewMessageCell cellWithTableView:tableView indentifier:@"cell"];
//    if (kUserIsSchoolLevel) {
//        cell.schoolNotice = _schoolNoticeArray[indexPath.row];
//    } else {
//        cell.notice = _noticeArray[indexPath.row];;
//    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectRowFromModel:)]) {
//        if (kUserIsSchoolLevel) {
//            [_delegate didSelectRowFromModel:_schoolNoticeArray[indexPath.row]];
//        } else {
//            [_delegate didSelectRowFromModel:_noticeArray[indexPath.row]];
//        }
    }
}
@end
