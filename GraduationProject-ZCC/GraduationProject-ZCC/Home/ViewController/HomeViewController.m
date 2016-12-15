//
//  HomeViewController.m
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/12.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate,BMKGeoCodeSearchDelegate>

@property(nonatomic,strong)BMKMapView *mapView;
@property(nonatomic,strong)BMKLocationService *location;
@property(nonatomic,strong)BMKPointAnnotation* annotation;
@property(nonatomic,strong)BMKGeoCodeSearch *search;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = nil;
    [self.view addSubview:self.mapView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.mapView.delegate = self;
    self.location.delegate = self;
    [self.location startUserLocationService];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.mapView.delegate = nil;
    self.location.delegate = nil;
    [self.location stopUserLocationService];
}

/**
 添加大头针
 */
- (void)addAnnotationWithLatitude:(CLLocationDegrees )latitude Longitude:(CLLocationDegrees )longitude
{
    CLLocationCoordinate2D coor;
    coor.latitude = latitude;
    coor.longitude = longitude;
    self.annotation.coordinate = coor;
    self.annotation.title = @"Ta在这里";
}

#pragma mark ----Delegate----

//大头针样式
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation
{
    static NSString *identifier = @"myAnnotation";
    BMKAnnotationView *annotationView = [_mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    //如果缓存池中不存在则新建
    if (!annotationView) {
        
        annotationView = [[BMKAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:identifier];
        annotationView.canShowCallout = true;//允许交互点击
    }
    
    //修改大头针视图
    annotationView.annotation = annotation;
    
    NSString *imgName = nil;
    self.sex == 1?(imgName = @"location-B"):(imgName = @"location-G");
    annotationView.image = [UIImage imageNamed:imgName];
    
    return annotationView;
}

#pragma mark ----BMKLocationServiceDelegate----

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    //self.annotation.title = result.address;
    NSLog(@"结果:%@",result.address);
}

//处理方向变更信息
- (void)didUpdateUserHeading:(BMKUserLocation *)userLocation
{
    //NSLog(@"heading is %@",userLocation.heading);
}
//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
    //反地理编码
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){userLocation.location.coordinate.latitude, userLocation.location.coordinate.longitude};
    
    BMKReverseGeoCodeOption *option = [[BMKReverseGeoCodeOption alloc]init];
    option.reverseGeoPoint = pt;
    BOOL isOk = [self.search reverseGeoCode:option];
    
    if (isOk) {
        
        NSLog(@"反地理编码成功");
    }else{
        
        NSLog(@"反地理编码失败");
    }
    
    //更新位置信息
    BmobUser *user = [BmobUser currentUser];
    [user setObject:[NSString stringWithFormat:@"%f",userLocation.location.coordinate.latitude] forKey:@"latitude"];
    [user setObject:[NSString stringWithFormat:@"%f",userLocation.location.coordinate.longitude] forKey:@"longitude"];
    [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
       
        if (!error) {
            
            NSLog(@"同步成功");
        
        }else{
            
            [AppTools alertViewWithTitle:@"提示" WithMsg:@"上传位置信息失败" WithSureBtn:@"重试" WithCancleBtn:@"取消" WithVC:self WithSureBtn:^{
                
            } WithCancleBtn:nil];
            [self.location stopUserLocationService];
            NSLog(@"同步失败:%@",error);
        }
    }];
    
    //更新位置信息,停止定位
    [self.mapView updateLocationData:userLocation];
    [self.location stopUserLocationService];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
       
        //重新开始定位 ->10秒
        [self.location startUserLocationService];
    });
}

#pragma mark ---Lazy----

- (BMKMapView *)mapView
{
    if (!_mapView) {
        _mapView = [[BMKMapView alloc]initWithFrame:self.view.bounds];
        //设置定位
        _mapView.userTrackingMode = BMKUserTrackingModeFollow;
        _mapView.showsUserLocation = YES;
    }
    return _mapView;
}

- (BMKLocationService *)location
{
    if (!_location) {
        _location = [[BMKLocationService alloc]init];
        [_location startUserLocationService];
    }
    return _location;
}

- (BMKPointAnnotation *)annotation
{
    if (!_annotation) {
        _annotation = [[BMKPointAnnotation alloc]init];
        [self.mapView addAnnotation:_annotation];

    }
    return _annotation;
}


- (BMKGeoCodeSearch *)search
{
    if (!_search) {
        _search = [[BMKGeoCodeSearch alloc]init];
        _search.delegate = self;
    }
    return _search;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
