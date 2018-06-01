//
//  CustomAnnotationView.m
//  TakeCommandPlatform
//
//  Created by jyd on 2017/12/25.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import "CustomAnnotationView.h"
#import "BubbleLayer.h"
@interface CustomAnnotationView ()<UIGestureRecognizerDelegate>

/** annotation图片 */
@property (nonatomic, strong) UIImageView *annotationImgView;

/** titleLabel */
@property (nonatomic, strong) UILabel *titleLabel;

/** bg */
@property (nonatomic, strong) UIView *bgView;

/** layer */
@property (nonatomic, strong) BubbleLayer *bubbleLayer;

/** 名称 */
@property (nonatomic, strong) UILabel *nameLabel;

/** 考生人数 */
@property (nonatomic, strong) UILabel *stuNumLabel;

/** 考场数 */
@property (nonatomic, strong) UILabel *roomNumLabel;

/** 考点数 */
@property (nonatomic, strong) UILabel *siteNumLabel;


/** target */
@property (nonatomic, weak) id target;

/** action */
@property (nonatomic) SEL action;


@end
@implementation CustomAnnotationView

- (id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // 添加所有子控件
        [self addAllSubViews];
    }
    return self;
}

- (void)addAllSubViews {
    
    // 0. 设置大头针基本属性
    [self setBounds:CGRectMake(0.f, 0.f, 138, 138)];
    [self setBackgroundColor:[UIColor clearColor]];
    
    // 1. 添加annotationImgView
    _annotationImgView = [[UIImageView alloc] initWithFrame:self.bounds];
    _annotationImgView.contentMode = UIViewContentModeCenter;
//    [self addSubview:_annotationImgView];
    
    
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = RGB(255, 152, 0);
    
    
    
    
//    [_bgView.layer setBackgroundColor:[UIColor blackColor].CGColor];
   _bubbleLayer = [[BubbleLayer alloc] init];
    _bubbleLayer.arrowDirection = ArrowDirectionButtom;
    _bubbleLayer.arrowHeight = 10;
    _bubbleLayer.arrowWidth = 15;
    _bubbleLayer.arrowPosition = 0.5;
    _bubbleLayer.cornerRadius = 0;
    
    ;
    // 2. 添加titleLabel
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.frame = CGRectMake(0, 0, 100, 30);
//    _titleLabel.font = [UIFont systemFontOfSize:17];
    _titleLabel.backgroundColor = [UIColor whiteColor];
    _titleLabel.layer.borderColor =[UIColor lightGrayColor].CGColor;
    _titleLabel.layer.borderWidth = 1.0f;
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.adjustsFontSizeToFitWidth = YES;
   
    
    
    _nameLabel = [[UILabel alloc] init];
    _nameLabel.frame = CGRectMake(0, 15, 100, 27);
    //    _titleLabel.font = [UIFont systemFontOfSize:17];
    _nameLabel.textAlignment = NSTextAlignmentCenter;
    _nameLabel.adjustsFontSizeToFitWidth = YES;
    [_bgView addSubview:_nameLabel];
    
    _stuNumLabel = [[UILabel alloc] init];
    _stuNumLabel.frame = CGRectMake(0, _nameLabel.bottom, 100, _nameLabel.height);
    //    _titleLabel.font = [UIFont systemFontOfSize:17];
    _stuNumLabel.textAlignment = NSTextAlignmentCenter;
    _stuNumLabel.adjustsFontSizeToFitWidth = YES;
    [_bgView addSubview:_stuNumLabel];
    
    _roomNumLabel = [[UILabel alloc] init];
    _roomNumLabel.frame = CGRectMake(0, _stuNumLabel.bottom, 100, _nameLabel.height);
    //    _titleLabel.font = [UIFont systemFontOfSize:17];
    _roomNumLabel.textAlignment = NSTextAlignmentCenter;
    _roomNumLabel.adjustsFontSizeToFitWidth = YES;
    [_bgView addSubview:_roomNumLabel];
    
    _siteNumLabel = [[UILabel alloc] init];
    _siteNumLabel.frame = CGRectMake(0, _roomNumLabel.bottom, 100, _nameLabel.height);
    //    _titleLabel.font = [UIFont systemFontOfSize:17];
    _siteNumLabel.textAlignment = NSTextAlignmentCenter;
    _siteNumLabel.adjustsFontSizeToFitWidth = YES;
    [_bgView addSubview:_siteNumLabel];
    
    
}

- (void)setImg:(UIImage *)img {
    
    _img = img;
    _annotationImgView.image = img;
}

- (void)setAddress:(NSString *)address
{
    _address = address;
    _titleLabel.text = address;
    
   
}

- (void)setUserLevelModel:(UserLevelModel *)userLevelModel
{
    _userLevelModel = userLevelModel;
    if (userLevelModel.info) {
        _nameLabel.text = userLevelModel.info.orgname;
        _stuNumLabel.text = [NSString stringWithFormat:@"考生人数: %ld",userLevelModel.info.studentnum];
        _roomNumLabel.text = [NSString stringWithFormat:@"考场数: %ld",userLevelModel.info.roomnum];
        _siteNumLabel.text = [NSString stringWithFormat:@"考点数: %ld",userLevelModel.info.sitenum];
    } else {
        _titleLabel.text = userLevelModel.schoolSite.sitename;
    }
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    CGSize size = [_address sizeWidthFont:_titleLabel.font size:CGSizeMake(0, 50)];
    if (_userLevelModel.info) {
        [self addSubview:_bgView];
        _bgView.frame = CGRectMake(0, 0, 138, 138);
        //    _bgView.center = _annotationImgView.center;
        _bgView.layer.masksToBounds = YES;
        _bgView.layer.cornerRadius = 138/2;
        _nameLabel.centerX = 138/2;
        _stuNumLabel.centerX = _nameLabel.centerX;
        _roomNumLabel.centerX = _nameLabel.centerX;
        _siteNumLabel.centerX = _nameLabel.centerX;
    } else {
        [self addSubview:_annotationImgView];
        [self addSubview:_titleLabel];
        _titleLabel.centerX = _annotationImgView.centerX;
        _titleLabel.y = 20;
       
    }
 
//    _bgView.centerX = _annotationImgView.x + 5;
//    _bubbleLayer.size = _bgView.bounds.size;
//    [_bgView.layer setMask:[_bubbleLayer layer]];
//    self.titleLabel.size = size;
//    self.titleLabel.y = 5;
    
}




- (void)didTouch
{
    IMP _imp = [self.target methodForSelector:self.action];
    bool (*func)(id, SEL, id) = (void *)_imp;
    bool result = func(self.target, self.action, self.userLevelModel);
    if (!result) {
        return;
    }
}

- (void)addTarget:(id)target action:(SEL)action
{
    self.target = target;
    self.action = action;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (!selected) {
         _bgView.backgroundColor = RGB(255, 152, 0);
    } else {
         _bgView.backgroundColor = RGB(255, 217, 82);
    }
    
}

- (void)setIsSelect:(BOOL)isSelect
{
    _isSelect = isSelect;
    if (!isSelect) {
        _bgView.backgroundColor = RGB(255, 152, 0);
    } else {
        _bgView.backgroundColor = RGB(255, 217, 82);
    }
}
@end
