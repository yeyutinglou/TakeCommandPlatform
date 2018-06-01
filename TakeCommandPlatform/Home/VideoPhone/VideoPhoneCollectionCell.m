//
//  VideoPhoneCollectionCell.m
//  TakeCommandPlatform
//
//  Created by jyd on 2018/1/5.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import "VideoPhoneCollectionCell.h"
@interface VideoPhoneCollectionCell ()
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *telephone;

@property (weak, nonatomic) IBOutlet UILabel *name;

@end

@implementation VideoPhoneCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _calling.hidden = YES;
}

- (void)setReceivermodel:(ReceiverModel *)receivermodel
{
    _receivermodel = receivermodel;
    _name.text = receivermodel.username;
    
    if (receivermodel.state == -1) {
        //不在线
        _bgView.backgroundColor = RGB(208, 208, 208);
    }
}


- (void)itemChangeSelectedState
{
    _calling.hidden = !_calling.hidden;
}

- (void)itemChangeCallingState:(BOOL)isCalling
{
    if (!isCalling) {
        _bgView.backgroundColor = RGB(166, 205, 249);
        _telephone.image = [UIImage imageNamed:@"telephone"];
        _calling.hidden = YES;
        _calling.image =  [UIImage imageNamed:@"phone_check"];
    } else {
        _bgView.backgroundColor = RGB(255, 182, 186);
        _telephone.image = [UIImage imageNamed:@"telephone_ring"];
        _calling.hidden = NO;
        _calling.image =  [UIImage imageNamed:@"calling"];
    }
}

@end
