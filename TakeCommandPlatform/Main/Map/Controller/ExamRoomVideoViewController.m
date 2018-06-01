//
//  ExamRoomVideoViewController.m
//  TakeCommandPlatform
//
//  Created by jyd on 2017/12/19.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import "ExamRoomVideoViewController.h"
#import "LivePlayerView.h"
#import "StudentSeatModel.h"
#import "StudentSeatView.h"
#import "StudentDetailsViewController.h"

@interface ExamRoomVideoViewController () <StudentSeatDelegate>


/** playView */
@property (nonatomic, strong)  LivePlayerView *playView;

/** studentSeat */
@property (nonatomic, strong) StudentSeatModel *seatModel;


/** seatArr */
@property (nonatomic, strong) NSMutableArray *seatArray;


@end

@implementation ExamRoomVideoViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self showVideoView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_playView destoryPlayView];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
//    if (_isSearch) {
//        self.title = [NSString stringWithFormat:@"%@%@",_studentSearchModel.sitechoolname,_studentSearchModel.roomname];
//    } else {
//         self.title = [NSString stringWithFormat:@"%@%@",_sitechoolname, _roomInfo.examname];
//    }
    
    self.title = _examRoom.roomname;
   
    
//    [self showVideoView];
    
    [self setupStudentSeatView];
    
    
}

- (void)loadRoomSeatData
{
    NSString *url = [NSString stringWithFormat:@"%@%@",kServiceAdress, REQUEST_URL_STUDENTSEATS];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    //    param[@"userid"] = kUserId;
    param[@"roomid"] = _examRoom.roomid;
    
    [NetworkManager POST:url parameters:param success:^(id responseObject) {
        _seatModel = [StudentSeatModel yy_modelWithJSON:responseObject];
        NSMutableArray *sortArray = [NSMutableArray arrayWithArray:_seatModel.students];
        [sortArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            NSComparisonResult result = [((StudentModel *)obj1).seatnum compare:((StudentModel *)obj2).seatnum];
            return result;
        }];
        
        _seatArray = [[NSMutableArray alloc] init];
        int line; //行数
        if (_seatModel.studentnum % _seatModel.column == 0) {
            line = (int)sortArray.count / _seatModel.column;
        } else {
            line = (int)sortArray.count / _seatModel.column + 1;
        }
        int index = 1;
        int s = 2 * line - 1;
        int d = 1;
        int modelNum;
        for (int i = 1; i <= line; i++) {
            for (int j = 1; j <= _seatModel.column; j++) {
                if(j == 1){
                    index = i;
                }else{
                    if(j % 2 == 0){
                        index += s;
                    }else{
                        index += d;
                    }
                }
                NSLog(@"%d",index);
                modelNum = (i - 1) * 5 + (j - 1);
                [_seatArray insertObject:[sortArray objectAtIndex:index - 1] atIndex:modelNum];
            }
            s -= 2;
            d += 2;
        }
        
    } failure:^(NSError *error) {
        
    }];
}



///视频
- (void)showVideoView
{
    if (_isSearch) {
        if (!_studentSearchModel.siptype) {
            //走转发
            [self setupPlayView];
            
            
        } else {
            //sip
        }
    } else {
        if (!_seatModel.device.siptype) {
            //走转发
            [self setupPlayView];
            
            
        } else {
            //sip
        }
    }
    
}

///设置转发视频
- (void)setupPlayView
{
    _playView  = [[LivePlayerView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH)];
    [self.view addSubview:_playView];
    _playView.studentSearchModel = _studentSearchModel;
//    if (_isSearch) {
//        
//    } else {
//        _playView.roomInfo = _roomInfo;
//    }
    
    
}

///座位界面
- (void)setupStudentSeatView
{
    StudentSeatView *seatView = [[StudentSeatView alloc] init];
   
//    seatView.frame = CGRectMake(0, _playView.bottom, SCREEN_WIDTH, SCREEN_HEIGHT - _playView.height);
    [self.view addSubview:seatView];
    [seatView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.equalTo(self.view);
        make.top.equalTo(self.view).offset(SCREEN_WIDTH);
    }];
    
    seatView.delegate = self;
//    if (_isSearch) {
//        seatView.studentSearchModel = _studentSearchModel;
//    } else {
//        seatView.roomInfo = _roomInfo;
//    }
    seatView.studentArry = _seatArray;
}

#pragma mark - StudentSeatDelegate

- (void)didSelectItemWithModel:(StudentModel *)model
{
    StudentDetailsViewController *details = [[StudentDetailsViewController alloc] init];
    details.studentModel = model;
    [self.navigationController pushViewController:details animated:YES];
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
