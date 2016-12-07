//
//  LocationViewController.m
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/7.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import "LocationViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@interface LocationViewController ()<MKMapViewDelegate>

@property(strong,nonatomic)MKMapView *mapView;

@end

@implementation LocationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.mapView];
}

#pragma -mark MKMapViewDelegate

//位置变化时调用
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    
    NSLog(@"%f     %f",userLocation.location.coordinate.latitude,userLocation.location.coordinate.longitude);
}

#pragma mark ----Lazy----

- (MKMapView *)mapView
{
    if (!_mapView) {
        _mapView = [[MKMapView alloc]initWithFrame:self.view.bounds];
        _mapView.delegate = self;
        _mapView.userTrackingMode = MKUserTrackingModeFollow;
        _mapView.mapType = MKMapTypeStandard;
        _mapView.showsUserLocation = YES;
        
        // 地图的操作属性
        _mapView.zoomEnabled = YES;// 可以缩放
        _mapView.scrollEnabled = YES;// 可以滚动
        _mapView.rotateEnabled = YES;// 可以旋转
        _mapView.pitchEnabled = YES;// 是否显示3D
        
        _mapView.showsCompass = YES;// 指南针
        _mapView.showsScale = YES;// 显示比例尺
    }
    return _mapView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
