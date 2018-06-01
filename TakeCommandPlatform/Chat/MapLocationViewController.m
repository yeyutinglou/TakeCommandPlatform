//
//  MapLocationViewController.m
//  TakeCommandPlatform
//
//  Created by jyd on 2018/3/12.
//  Copyright © 2018年 jyd. All rights reserved.
//

#import "MapLocationViewController.h"
#import <MapKit/MapKit.h>
#import "LocationManager.h"
@interface MapLocationViewController ()<MKMapViewDelegate>

/** mapView */
@property (nonatomic, strong) MKMapView *mapView;

/** address */
@property (nonatomic, copy) NSString *address;

/** error */
@property (nonatomic, strong) NSError *error;

/** locationImage */
@property (nonatomic, strong) UIImage *locationImage;

@end

@implementation MapLocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mapView];
    
    if (self.mapType == MapTypeLocation) {
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"发送位置" style:UIBarButtonItemStylePlain target:self action:@selector(sendLocationAction:)];
        self.navigationItem.rightBarButtonItem.enabled = NO;
        
        [[LocationManager sharedLocationManager] startSystemLocationWithRes:^(CLLocation *location, NSError *error) {
            if (error) {
                self.completion  ? self.completion(nil, nil, nil, error) : nil;
            } else {
                [self setMapPosition:location];
                
                [[LocationManager sharedLocationManager] address:location completion:^(NSString *address, CLLocation *location, NSError *error) {
                    self.address = address;
                    self.location = location;
                    self.error = error;
                    if (error) {
                        NSLog(@"解析地址失败:%@",error.localizedDescription);
                        self.navigationItem.rightBarButtonItem.enabled = NO;
                    } else {
                        self.navigationItem.rightBarButtonItem.enabled = YES;
                    }
                }];
            }
        }];
    } else {
        [self setMapPosition:self.location];
    }
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    // NSLog(@"%@",userLocation.location);
}


- (void)setMapPosition:(CLLocation *)location
{
    [self.mapView setCenterCoordinate:location.coordinate animated:YES];
    
    CLLocationCoordinate2D center = location.coordinate;
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.009310,0.007812);
    // 将用户当前的位置作为显示区域的中心点, 并且指定需要显示的跨度范围
    MKCoordinateRegion region = MKCoordinateRegionMake(center, span);
    
    
    [self.mapView  setRegion:region animated:YES];
    self.mapView .rotateEnabled = YES;
    
    
    self.mapView .showsUserLocation = NO;
    
    
    
    //加大头针
    MKPointAnnotation *annotation=[[MKPointAnnotation alloc]init];
    annotation.coordinate = location.coordinate;
    [self.mapView addAnnotation:annotation];
    [self.mapView selectAnnotation:annotation animated:YES];
}

- (void)sendLocationAction:(UIBarButtonItem *)barBtn
{
    //snapMapView
    UIImage *image = [UIImage captureWithView:self.mapView];
    image = [UIImage getImageWithSize:CGRectMake(image.size.width*2/2-90, image.size.height*2/2-90+64, 180, 180) FromImage:image];
    self.locationImage = [UIImage thumbWithImage:image scale:1];
    
    
    self.completion ? self.completion(self.address,self.location ,self.locationImage,self.error) : nil;
}



- (MKMapView *)mapView
{
    if (!_mapView) {
        _mapView = [[MKMapView alloc]initWithFrame:self.view.bounds];
        _mapView.delegate = self;
    }
    
    return _mapView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
