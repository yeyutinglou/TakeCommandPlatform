//
//  OfflineMapViewController.m
//  TakeCommandPlatform
//
//  Created by jyd on 2018/1/10.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import "OfflineMapViewController.h"

@interface OfflineMapViewController () <BMKMapViewDelegate>
@property (weak, nonatomic) IBOutlet BMKMapView *mapView;

@end

@implementation OfflineMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"更新" target:self action:@selector(update)];
    
    //显示当前某地的离线地图
//    _mapView = [[BMKMapView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _mapView.delegate = self;
//    [self.view addSubview:_mapView];
    BMKOLUpdateElement* localMapInfo;
    localMapInfo = [_offlineServiceOfMapview getUpdateInfo:_cityId];
    [_mapView setCenterCoordinate:localMapInfo.pt];
}



- (void)update
{
    [_offlineServiceOfMapview update:_cityId];
}

- (void)viewDidUnload {
    [super viewDidUnload];
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
