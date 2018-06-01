//
//  StudentSeatView.m
//  TakeCommandPlatform
//
//  Created by jyd on 2017/12/22.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import "StudentSeatView.h"
#import "StudentSeatCollectionCell.h"
#import "StudentSeatHeaderView.h"
#define kRow 5 //列

@interface StudentSeatView () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UICollectionView *seatCollectionView;

/** 考生座位 */
@property (nonatomic, strong) NSMutableArray *seatArray;

/** 标识 */
@property (nonatomic, strong) NSMutableDictionary *cellDic;;



@end

@implementation StudentSeatView

- (instancetype)init
{
    StudentSeatView *seatView;
    if (!seatView) {
        seatView = [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
    }
    return seatView;
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    _cellDic = [[NSMutableDictionary alloc] init];
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    _seatCollectionView.collectionViewLayout = flowLayout;

    _seatCollectionView.dataSource = self;
    _seatCollectionView.delegate = self;

    
    [_seatCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([StudentSeatHeaderView class]) bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header"];
    
  
}

//- (void)setRoomInfo:(RoomInfo *)roomInfo
//{
//    _roomInfo = roomInfo;
//    [self getStudentSeatData];
//}
//
//- (void)setStudentSearchModel:(StudentSearchModel *)studentSearchModel
//{
//    _studentSearchModel = studentSearchModel;
//    [self getStudentSeatData];
//}

- (void)setStudentArry:(NSArray *)studentArry
{
    _studentArry = studentArry;
    [_seatCollectionView reloadData];
}


///获考生座次表
//- (void)getStudentSeatData
//{
//    NSString *url = [NSString stringWithFormat:@"%@%@",kServiceAdress, REQUEST_URL_STUDENTSEATS];
//    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
//    //    param[@"userid"] = kUserId;
//    param[@"sessionid"] = kUserSessionid;
//    if (_roomInfo) {
//         param[@"code"] = _roomInfo.roomcode;
//    } else {
//         param[@"code"] = _studentSearchModel.roomcode;
//    }
//
//    [NetworkManager POST:url parameters:param success:^(id responseObject) {
//        NSArray *arr = [NSArray yy_modelArrayWithClass:[StudentSeatModel class] json:responseObject];
//        NSMutableArray *sortArray = [NSMutableArray arrayWithArray:arr];
//        [sortArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
//            NSComparisonResult result = [((StudentSeatModel *)obj1).seatnum compare:((StudentSeatModel *)obj2).seatnum];
//            return result;
//        }];
//
//        _seatArray = [[NSMutableArray alloc] init];
//        int line; //行数
//        if (sortArray.count % kRow == 0) {
//            line = (int)sortArray.count / kRow;
//        } else {
//            line = (int)sortArray.count / kRow + 1;
//        }
//        int index = 1;
//        int s = 2 * line - 1;
//        int d = 1;
//        int modelNum;
//        for (int i = 1; i <= line; i++) {
//            for (int j = 1; j <= kRow; j++) {
//                if(j == 1){
//                    index = i;
//                }else{
//                    if(j % 2 == 0){
//                        index += s;
//                    }else{
//                        index += d;
//                    }
//                }
//                NSLog(@"%d",index);
//                modelNum = (i - 1) * 5 + (j - 1);
//                [_seatArray insertObject:[sortArray objectAtIndex:index - 1] atIndex:modelNum];
//            }
//            s -= 2;
//            d += 2;
//        }
//
//        [_seatCollectionView reloadData];
//    } failure:^(NSError *error) {
//
//    }];
//}
#pragma mark - delegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _studentArry.count;
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
        [_seatCollectionView registerNib:[UINib nibWithNibName:NSStringFromClass([StudentSeatCollectionCell class]) bundle:nil] forCellWithReuseIdentifier:identifier];
    }
    
    StudentSeatCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
//    cell.studentSeatModel = _seatArray[indexPath.row];
//    cell.studentSearchModel = _studentSearchModel;
    cell.studentModel = _studentArry[indexPath.row];
    return cell;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(SCREEN_WIDTH/kRow , 40);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"header";
    StudentSeatHeaderView *cell = (StudentSeatHeaderView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:CellIdentifier forIndexPath:indexPath];
   
    return cell;
    
}

- (CGSize)collectionView:(UICollectionView*)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    
    
    return CGSizeMake(SCREEN_WIDTH, 60);
    
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_delegate && [_delegate respondsToSelector:@selector(didSelectItemWithModel:)]) {
        [_delegate didSelectItemWithModel:_studentArry[indexPath.row]];
    }
}


@end
