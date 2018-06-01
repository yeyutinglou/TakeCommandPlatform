//
//  MapViewController.m
//  TakeCommandPlatform
//
//  Created by jyd on 2017/12/11.
//  Copyright © 2017年 jyd. All rights reserved.
//

#import "MapViewController.h"
#import <BaiduMapAPI_Map/BMKMapView.h>
#import <BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapAPI_Utils/BMKUtilsComponent.h>

#import "ExamLocationModel.h"
#import "ExamLocationDetailsViewController.h"
#import "OfflineViewController.h"

#import "SearchView.h"
#import "StudentSearchViewController.h"

#import "CustomAnnotationView.h"

#import "UserLevelModel.h"

#import "ExaminationRoomListViewController.h"
@interface MapViewController ()<BMKMapViewDelegate, BMKDistrictSearchDelegate, StudentSearchDelegate>

@property (weak, nonatomic) IBOutlet BMKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIButton *trafficBtn;
@property (weak, nonatomic) IBOutlet UIButton *normalBtn;
@property (weak, nonatomic) IBOutlet UIButton *satelliteBtn;

//区域搜索
@property (nonatomic, strong) BMKDistrictSearch *districtSearch;

///** 点聚合管理类 */
//@property (nonatomic, strong) BMKClusterManager *clusterManager;

/** 考点数据 */
@property (nonatomic, strong) NSArray *examArray;

/** 大头针数据 */
@property (nonatomic, strong) NSMutableArray *annotationArray;

@property (weak, nonatomic) IBOutlet UIView *detailsView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailsBottom;

@property (weak, nonatomic) IBOutlet UIButton *examListBtn;

/** 国家级 */
@property (nonatomic, strong) NSMutableArray *countryArr;

/** 省级 */
@property (nonatomic, strong) NSMutableArray *provinceArr;
/** 市级 */
@property (nonatomic, strong) NSMutableArray *cityArr;

/** 县级 */
@property (nonatomic, strong) NSMutableArray *countyArr;

/** 校级 */
@property (nonatomic, strong) NSMutableArray *schoolArr;

/** 比例 */
@property (nonatomic, assign) float lastZoomLevel;

/** annnotationView */
@property (nonatomic, strong) NSMutableArray *annnotationViewArr;

//>>>>>详情页
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *siteCodeLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contactAddressLabel;
@property (weak, nonatomic) IBOutlet UILabel *wkLabel;

@property (weak, nonatomic) IBOutlet UILabel *lgLabel;


@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"电子地图";
    _mapView.delegate = self;
//    [self getExamInfo];
    
    [self setupSearchView];
    
    [_trafficBtn setBackgroundImage:[UIImage imageWithColor:RGB(0, 154, 217)] forState:UIControlStateNormal];
    [_trafficBtn setBackgroundImage:[UIImage imageWithColor:RGB(136, 169, 219)] forState:UIControlStateSelected];
    [_normalBtn setBackgroundImage:[UIImage imageWithColor:RGB(0, 154, 217)] forState:UIControlStateNormal];
    [_normalBtn setBackgroundImage:[UIImage imageWithColor:RGB(136, 169, 219)] forState:UIControlStateSelected];
    [_satelliteBtn setBackgroundImage:[UIImage imageWithColor:RGB(0, 154, 217)] forState:UIControlStateNormal];
    [_satelliteBtn setBackgroundImage:[UIImage imageWithColor:RGB(136, 169, 219)] forState:UIControlStateSelected];
    _trafficBtn.selected = NO;
    _normalBtn.selected = YES;
    _satelliteBtn.selected = NO;
    
//    [UIView animateWithDuration:10 delay:60 options:UIViewAnimationOptionTransitionNone animations:^{
//        _detailsBottom.constant = -200;
//    } completion:^(BOOL finished) {
//        
//        
//    }];
    [self performSelector:@selector(doAnimation) withObject:nil afterDelay:1];
    
    [self loadData];
    _annotationArray = [[NSMutableArray alloc] init];
    
}

/** 显示详情视图 */
- (void)doAnimation
{
    [UIView animateWithDuration:1 animations:^{
        _detailsBottom.constant = 0;
        [self.view layoutIfNeeded];
    }];
}

///考生搜索
- (void)setupSearchView
{
//    SearchView *search = [[SearchView alloc] init];
//    [self.view addSubview:search];
//    search.delegate = self;
//    [search mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.left.right.equalTo(self.view);
//        make.height.mas_equalTo(60);
//    }];
}

/** 加载数据 */
- (void)loadData
{
    _countryArr = [[NSMutableArray alloc] init];
    _provinceArr = [[NSMutableArray alloc] init];
    _cityArr = [[NSMutableArray alloc] init];
    _countyArr = [[NSMutableArray alloc] init];
    _schoolArr = [[NSMutableArray alloc] init];
    _annnotationViewArr = [[NSMutableArray alloc] init];
   

    NSString *url = [NSString stringWithFormat:@"%@%@",kServiceAdress,REQUEST_URL_FINDUSERINFO];
    [NetworkManager POST:url parameters:@{@"id" : kUserId} success:^(id responseObject) {
        UserLevelModel *model = [UserLevelModel yy_modelWithJSON:responseObject];
        [self addCircleView:model];
        [self getLevelModel:model];
    } failure:^(NSError *error) {
        
    }];
}

/** 获取各个等级数据 */
- (void)getLevelModel:(UserLevelModel *)model
{
    if (model.schoolSite) {
        [_schoolArr addObject:model];
    } else {
        switch (model.info.lev) {
            case UserLevelCountry:
            {
                [_countryArr addObject:model];
                for (ProvinceSite *site in model.subInfos) {
                    UserLevelModel *level = [[UserLevelModel alloc] init];
                    level.info = site.info;
                    level.subInfos = site.citySites;
                    
//                    [_provinceArr addObject:level];
                    [self getLevelModel:level];
                }
            }
                break;
            case UserLevelProvince:
            {
                 [_provinceArr addObject:model];
                for (CitySite *site in model.subInfos) {
                    UserLevelModel *level = [[UserLevelModel alloc] init];
                    level.info = site.info;
                    level.subInfos = site.countrySites;
//                    [_cityArr addObject:level];
                     [self getLevelModel:level];
                }
            }
                break;
            case UserLevelCity:
            {
                [_cityArr addObject:model];
                for (CountySite *site in model.subInfos) {
                    UserLevelModel *level = [[UserLevelModel alloc] init];
                    level.info = site.info;
                    level.subInfos = site.schoolSites;
//                    [_countyArr addObject:level];
                    [self getLevelModel:level];
                }
            }
                break;
            case UserLevelCounty:
            {
                [_countyArr addObject:model];
                for (SchoolSite *site in model.subInfos) {
                    UserLevelModel *level = [[UserLevelModel alloc] init];
                    level.schoolSite = site;
//                    [_schoolArr addObject:level];
                    [self getLevelModel:level];
                }
            }
                break;
                
            default:
                break;
        }
    }
    
}

#pragma mark — 添加原型覆盖物
- (void)addCircleView:(UserLevelModel *)model
{
   
    BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];
    float zoomLevel;
    if (model.info) {
        annotation.coordinate = CLLocationCoordinate2DMake(model.info.latitude, model.info.longitude);
        zoomLevel = model.info.zoomlevel;
        _examListBtn.hidden = YES;
    } else {
        annotation.coordinate = CLLocationCoordinate2DMake(model.schoolSite.y, model.schoolSite.x);
        zoomLevel = model.schoolSite.zoomlevel;
        _examListBtn.hidden = NO;
    }
    
    annotation.title =[model yy_modelToJSONString];
    [_annotationArray addObject:annotation];
    _lastZoomLevel = _mapView.zoomLevel;
    [_mapView setCenterCoordinate:annotation.coordinate];

    [_mapView setZoomLevel:zoomLevel];
    
    [_mapView addAnnotation:annotation];
    [_mapView mapForceRefresh];
    
    NSLog(@"%.f",_mapView.zoomLevel);
    if (kUserLevel == model.info.lev || kUserLevel == model.schoolSite.lev) {
        [self showDetailsWithModel:model];
    }
}


#pragma mark - RMaps
///离线地图
- (IBAction)downloadRMapsBtnClick:(UIButton *)sender {
    OfflineViewController *off = [[OfflineViewController alloc] init];
    [self.navigationController pushViewController:off animated:YES];
}

///实时交通
- (IBAction)RTICBtnClick:(UIButton *)sender {
    sender.selected = !sender.selected;
    [_mapView setTrafficEnabled:sender.selected];
}

///普通图
- (IBAction)generalMapBtnClick:(UIButton *)sender {
    if (!sender.selected) {
        sender.selected = YES;
        _satelliteBtn.selected = NO;
    }
    _mapView.mapType = BMKMapTypeStandard;
}
///卫星图
- (IBAction)satelliteMapBtnClick:(UIButton *)sender {
    if (!sender.selected) {
        sender.selected = YES;
        _normalBtn.selected = NO;
    }
    _mapView.mapType = BMKMapTypeSatellite;
}


#pragma mark - examAddressInfo
///考点信息
- (void)getExamInfo
{
    NSString *url = [NSString stringWithFormat:@"%@%@",kServiceAdress, REQUEST_URL_EXAMADDRESSINFO];
    NSMutableDictionary *param = [[NSMutableDictionary alloc] init];
    param[@"id"] = kUserId;
    param[@"sessionid"] = kUserSessionid;
    [NetworkManager POST:url parameters:param success:^(id responseObject) {
        _examArray = [NSArray yy_modelArrayWithClass:[ExamLocationModel class] json:responseObject];
        [self showAnnotationView:_examArray];
    } failure:^(NSError *error) {
        
    }];
}

///显示大头针
- (void)showAnnotationView:(NSArray *)arr
{
    _annotationArray = [[NSMutableArray alloc] init];
    for (ExamLocationModel *model in arr) {
        BMKPointAnnotation* annotation = [[BMKPointAnnotation alloc]init];

        annotation.coordinate = CLLocationCoordinate2DMake([model.y doubleValue], [model.x doubleValue]);
        annotation.title = model.sitename;
       
        [_annotationArray addObject:annotation];
        if ([model.x doubleValue] == 0 || [model.y doubleValue] == 0) {
            continue;
        }
        
//        if (kUserIsSchoolLevel) {
//            //校级
//            //只显示自己
//            if ([kUserAccount isEqualToString:model.sitecode]) {
//                [_mapView addAnnotation:annotation];
//            }
//        } else {
//            //市级
//            [_mapView addAnnotation:annotation];
//        }
        
//        [_mapView selectAnnotation:annotation animated:YES];
    }
   
    
}

- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
//        static NSString *pointReuseIndentifier = @"pointReuseIndentifier";
         NSString *pointReuseIndentifier = [NSString stringWithFormat:@"pointReuseIndentifier%@",annotation.title];
        CustomAnnotationView *annotationView = (CustomAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndentifier];
        if (annotationView == nil) {
            annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndentifier];
        }
//        annotationView.pinColor = BMKPinAnnotationColorPurple;
        annotationView.canShowCallout= NO;      //设置气泡可以弹出，默认为NO
//        annotationView.animatesDrop=YES;         //设置标注动画显示，默认为NO
        annotationView.draggable = YES; //设置标注可以拖动，默认为NO
        UserLevelModel *model = [UserLevelModel yy_modelWithJSON:annotation.title];
        annotationView.userLevelModel = model;
        if (model.schoolSite) {
            annotationView.img = [UIImage imageNamed:@"pin"];
        }
        [_annnotationViewArr addObject:annotationView];
    
        return annotationView;
    }
    return nil;
}



- (void)mapView:(BMKMapView *)mapView didSelectAnnotationView:(BMKAnnotationView *)view
{
    [_mapView deselectAnnotation:view.annotation animated:YES];
    CustomAnnotationView *customView = (CustomAnnotationView *)view;
   
    if (!customView.isSelect) {
        if (_detailsBottom.constant == -200) {
            [self performSelector:@selector(doAnimation) withObject:nil afterDelay:1];
        }
        if (kUserLevel == customView.userLevelModel.info.lev) {
             [self didTouchCircleView:customView.userLevelModel];
        }
        
        [self showDetailsWithModel:customView.userLevelModel];
        
    } else {
        if (customView.userLevelModel.schoolSite.lev != UserLevelExamSite) {
             [self didTouchCircleView:customView.userLevelModel];
        }
       
    }
     customView.isSelect = YES;
    for (CustomAnnotationView *view in _annnotationViewArr) {
        if (![view isEqual:customView]) {
            view.isSelect = NO;
        }
    }
    
}
- (void)didTouchCircleView:(UserLevelModel *)model
{
    [_mapView removeAnnotations:_annotationArray];
    [_annotationArray removeAllObjects];
    [_annnotationViewArr removeAllObjects];
    if (_detailsBottom.constant == 0) {
        _detailsBottom.constant = -200;
    }
    _annotationArray = [[NSMutableArray alloc] init];
    switch (model.info.lev) {
        case UserLevelCountry:
        {
            for (ProvinceSite *site in model.subInfos) {
                UserLevelModel *model = [[UserLevelModel alloc] init];
                model.info = site.info;
                model.subInfos = site.citySites;
                [self addCircleView:model];
            }
        }
            break;
        case UserLevelProvince:
        {

            for (CitySite *site in model.subInfos) {
                UserLevelModel *model = [[UserLevelModel alloc] init];
                model.info = site.info;
                model.subInfos = site.countrySites;
                [self addCircleView:model];
            }
        }
            break;
        case UserLevelCity:
        {
    
            for (CountySite *site in model.subInfos) {
                UserLevelModel *model = [[UserLevelModel alloc] init];
                model.info = site.info;
                model.subInfos = site.schoolSites;
                [self addCircleView:model];
            }
        }
            break;
        case UserLevelCounty:
        {
            
            for (SchoolSite *site in model.subInfos) {
                UserLevelModel *model = [[UserLevelModel alloc] init];
                model.schoolSite = [SchoolSite yy_modelWithJSON:site];
                [self addCircleView:model];
            }
        }
            break;
        case UserLevelExamSite:
        {
            
        }
            
        default:
            break;
    }
}

/** 显示详细信息 */
- (void)showDetailsWithModel:(UserLevelModel *)model
{
    if (model.info) {
        _nameLabel.text = model.info.orgname;
    } else {
        _nameLabel.text = model.schoolSite.sitename;
        _siteCodeLabel.text = model.schoolSite.areacode;
        _contactNameLabel.text = model.schoolSite.siteresponsible;
        _contactAddressLabel.text = model.schoolSite.sitelocation;
        _wkLabel.text = [NSString stringWithFormat:@"%ld",model.schoolSite.wsroomsnum] ;
        _lgLabel.text = [NSString stringWithFormat:@"%ld",model.schoolSite.lgroomsnum];
    }
}

- (void)mapStatusDidChanged:(BMKMapView *)mapView
{
//    if ([mapView zoomIn]  || [mapView zoomOut]) {
//        [self showCircleViewWithZoomLevel];
//    }
    
}

- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
        if (_lastZoomLevel != mapView.zoomLevel) {
            [self showCircleViewWithZoomLevel];
        }
    _lastZoomLevel = mapView.zoomLevel;
}



- (void)mapViewDidFinishLoading:(BMKMapView *)mapView
{
//    [self.mapView addObserver:self forKeyPath:@"zoomLevel" options:0 context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    
}


/** 根据地图比例显示相应的内容 */
- (void)showCircleViewWithZoomLevel
{
    if (_provinceArr.count > 0) {
        [self showCircleViewWithInfo:_countryArr sub:_provinceArr];
    }
    if (_cityArr.count > 0) {
        [self showCircleViewWithInfo:_provinceArr sub:_cityArr];
    }
    if (_countyArr.count > 0) {
        [self showCircleViewWithInfo:_cityArr sub:_countyArr];
    }
    if (_schoolArr.count > 0) {
        [self showCircleViewWithInfo:_countyArr sub:_schoolArr];
    }
    [self showCircleViewWithSchoolArr];
}

/** 根据地图比例显示等级内容  */
- (void)showCircleViewWithInfo:(NSArray *)infoArr sub:(NSArray *)subArr;
{
    
    
    if (infoArr.count > 0) {
        float maxZoomLevel;
        float minZoomLevel;
        float mapZoomLevel = _mapView.zoomLevel;
        UserLevelModel *provinceModel = infoArr[0];
        minZoomLevel = provinceModel.info.zoomlevel;
        UserLevelModel *cityModel = subArr[0];
        if (cityModel.info) {
            maxZoomLevel = cityModel.info.zoomlevel;
        } else {
            maxZoomLevel = cityModel.schoolSite.zoomlevel;
        }
//        if (subArr.count > 0) {
//
//
//        }else {
//            maxZoomLevel = 0;
//        }
        if (kUserLevel == provinceModel.info.lev) {
            if (mapZoomLevel < minZoomLevel) {
                [self showCircleViewWithArr:infoArr];
            }
        } else {
            if ( minZoomLevel <= mapZoomLevel &&  mapZoomLevel < maxZoomLevel) {
                [self showCircleViewWithArr:infoArr];
                
                
                
            }
        }
        
    }
    
}

/** 显示圆环 */
- (void)showCircleViewWithArr:(NSArray* )arr
{
    if (_annotationArray.count > 0) {
        BMKPointAnnotation *annotaion = _annotationArray[0];
        UserLevelModel *level = [UserLevelModel yy_modelWithJSON:annotaion.title];
        for (int i = 0; i < arr.count; i++) {
            UserLevelModel *model = arr[i];
            if ([model.info.orgid isEqualToString:level.info.orgid]) {
                break;
            } else {
                if (i == arr.count - 1) {
                    [_mapView removeAnnotations:_annotationArray];
                    [_annotationArray removeAllObjects];
                    for (UserLevelModel *model in arr) {
                        [self addCircleView:model];
                    }
                }
            }
            
        }
        

    }
}
/** 显示学校 */
- (void)showCircleViewWithSchoolArr
{
    if (_schoolArr.count > 0) {
        UserLevelModel *model = _schoolArr[0];
        if (kUserLevel != model.schoolSite.lev) {
            if (_mapView.zoomLevel >= model.schoolSite.zoomlevel) {
                BMKPointAnnotation *annotaion = _annotationArray[0];
                UserLevelModel *level = [UserLevelModel yy_modelWithJSON:annotaion.title];
                for (int i = 0; i < _schoolArr.count; i++) {
                    UserLevelModel *model = _schoolArr[i];
                    if ([model.schoolSite.userid isEqualToString:level.schoolSite.userid]) {
                        break;
                    } else {
                        if (i == _schoolArr.count -1) {
                            [_mapView removeAnnotations:_annotationArray];
                            [_annotationArray removeAllObjects];
                            for (UserLevelModel *model in _schoolArr) {
                                [self addCircleView:model];
                            }
                        }
                        }
                    }
                
            }
        }
    }
}

#pragma mark - StudentSearchDelegate
- (void)jumpStudentSearchVC
{
    StudentSearchViewController *search = [[StudentSearchViewController alloc] init];
    [self.navigationController pushViewController:search animated:YES];
}

- (void)viewDidUnload {
    [super viewDidUnload];
}


#pragma mark — 考场列表

- (IBAction)examListBtnClick:(UIButton *)sender {
    
    ExaminationRoomListViewController *list = [[ExaminationRoomListViewController alloc] init];
    [self.navigationController pushViewController:list animated:YES];
}

//-(void)viewWillAppear:(BOOL)animated {
//    [_mapView viewWillAppear];
//    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
//}
//
//-(void)viewWillDisappear:(BOOL)animated {
//    [_mapView viewWillDisappear];
//    _mapView.delegate = nil; // 不用时，置nil
//}
//
//- (void)dealloc {
//    if (_mapView) {
//        _mapView = nil;
//    }
//}

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
