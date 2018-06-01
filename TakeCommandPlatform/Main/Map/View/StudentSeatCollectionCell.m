//
//  StudentSeatCollectionCell.m
//  TakeCommandPlatform
//
//  Created by jyd on 2017/12/22.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import "StudentSeatCollectionCell.h"
@interface StudentSeatCollectionCell ()
@property (weak, nonatomic) IBOutlet UIImageView *bg;
@property (weak, nonatomic) IBOutlet UILabel *seatNum;
@property (weak, nonatomic) IBOutlet UILabel *studentName;

@end

@implementation StudentSeatCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

//- (void)setStudentSeatModel:(StudentSeatModel *)studentSeatModel
//{
//    _studentSeatModel = studentSeatModel;
//    _seatNum.text = studentSeatModel.seatnum;
//    _studentName.text = studentSeatModel.studentname;
//}
//
//- (void)setStudentSearchModel:(StudentSearchModel *)studentSearchModel
//{
//    _studentSearchModel = studentSearchModel;
//    if ([studentSearchModel.studentid isEqualToString:_studentSeatModel.studentid]) {
//        _bg.image = [UIImage imageNamed:@"rectangle_on"];
//    }
//}

- (void)setStudentModel:(StudentModel *)studentModel
{
    _studentModel = studentModel;
    _seatNum.text = studentModel.seatnum;
    _studentName.text = studentModel.s_name;
}

@end
