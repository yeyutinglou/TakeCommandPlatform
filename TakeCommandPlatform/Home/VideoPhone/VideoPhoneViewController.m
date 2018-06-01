//
//  VideoPhoneViewController.m
//  TakeCommandPlatform
//
//  Created by jyd on 2018/1/5.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import "VideoPhoneViewController.h"
#import "ReceiverModel.h"
#import "VideoPhoneCollectionCell.h"
#import "VideoPhoneRTCViewController.h"
@interface VideoPhoneViewController () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *videoPhoneCollectionView;
@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UIButton *phoneBtn;

/** 用户数据 */
@property (nonatomic, strong) NSArray *dataArray;

/** 标识 */
@property (nonatomic, strong) NSMutableDictionary *cellDic;;

/** 标记cell */
@property (nonatomic, strong) VideoPhoneCollectionCell *lastCell;

@end

@implementation VideoPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"可视通话";
    
    _cellDic = [[NSMutableDictionary alloc] init];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _videoPhoneCollectionView.collectionViewLayout = flowLayout;
    
    _videoPhoneCollectionView.dataSource = self;
    _videoPhoneCollectionView.delegate = self;
    
    _phoneView.hidden = YES;
    [_phoneBtn setBackgroundImage:[UIImage imageWithColor:RGB(95, 202, 107)] forState:UIControlStateNormal];
    [_phoneBtn setTitle:@"通 话" forState:UIControlStateNormal];
    [_phoneBtn setBackgroundImage:[UIImage imageWithColor:[UIColor redColor]] forState:UIControlStateSelected];
    [_phoneBtn setTitle:@"挂 断" forState:UIControlStateSelected];
    [self getReciverData];
}

///接收通知的用户信息
- (void)getReciverData
{
    NSString *url = [NSString stringWithFormat:@"%@%@",kServiceAdress, REQUEST_URL_RECEIVERS];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    param[@"userid"] = kUserId;
    param[@"sessionid"] = kUserSessionid;
    [NetworkManager POST:url parameters:param success:^(id responseObject) {
        _dataArray = [NSArray yy_modelArrayWithClass:[ReceiverModel class] json:responseObject];
        [_videoPhoneCollectionView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

#pragma mark - delegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // 每次先从字典中根据IndexPath取出唯一标识符
    NSString *identifier = [_cellDic objectForKey:[NSString stringWithFormat:@"%@", indexPath]];
    // 如果取出的唯一标示符不存在，则初始化唯一标示符，并将其存入字典中，对应唯一标示符注册Cell
    if (identifier == nil) {
        identifier = [NSString stringWithFormat:@"cell%@", indexPath];
        [_cellDic setValue:identifier forKey:[NSString stringWithFormat:@"%@", indexPath]];
        // 注册Cell
        [collectionView registerNib:[UINib nibWithNibName:NSStringFromClass([VideoPhoneCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:identifier];
    }
    
    VideoPhoneCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.receivermodel = _dataArray[indexPath.row];
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((SCREEN_WIDTH - 4 * 20)/3 , 60);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 20;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 20;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20, 20, 0, 20);
}



- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    VideoPhoneCollectionCell *cell = (VideoPhoneCollectionCell *)[collectionView cellForItemAtIndexPath:indexPath];
    ReceiverModel *model = _dataArray[indexPath.row];
    int state = model.state;
    switch (state) {
        case -1:
            {
                [MBProgressHUD showError:@"用户不在线"];
            }
            break;
        case 0:
        {
            if (_lastCell  != cell && _lastCell.calling.hidden == NO) {
                //改变上一个cell选中状态
                [_lastCell itemChangeSelectedState];
            }
            //改变当前cell选中状态
            [cell itemChangeSelectedState];
            //通话view随选中状态改变
            _phoneView.hidden = cell.calling.hidden;
            
            //赋值
            _lastCell = cell;
            
            
        }
            break;
        case 1:
        {
            [MBProgressHUD showError:@"用户通话中"];
        }
            break;
        default:
            break;
    }
}

- (IBAction)phoneBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    VideoPhoneRTCViewController * rtc = [[VideoPhoneRTCViewController alloc] init];
    [self.navigationController pushViewController:rtc animated:YES];
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
