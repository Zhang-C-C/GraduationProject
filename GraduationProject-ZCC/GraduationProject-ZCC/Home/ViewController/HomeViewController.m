//
//  HomeViewController.m
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/12.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import "HomeViewController.h"
#import "DetailAddressViewController.h"
#import "MsgViewController.h"

@interface HomeViewController ()<BMKMapViewDelegate,BMKLocationServiceDelegate>

@property(nonatomic,strong)BMKMapView *mapView;
@property(nonatomic,strong)BMKLocationService *location;
@property(nonatomic,strong)BMKPointAnnotation* annotation;
@property(nonatomic,strong)UIButton *distBtn;//距离显示

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = nil;
    [self.view addSubview:self.mapView];
    
    //设置导航栏右侧按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"消息" target:self action:@selector(msgBtnAction)];
    
    //取消关注的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationCancleFocus) name:@"canclFocus" object:nil];
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

- (void)setDistance:(double)distance
{
    _distance = distance;
    
    [self.distBtn setTitle:[NSString stringWithFormat:@"我们之间的距离:%.2f米,点击查看详情",_distance] forState:UIControlStateNormal];
}

#pragma mark ----Action----

/**
 导航栏右侧按钮点击事件
 */
- (void)msgBtnAction
{
    MsgViewController *msgVC = [[MsgViewController alloc]init];
    [[AppDelegate sharedAppDelegate] pushViewController:msgVC WithTitle:@"消息中心"];
}

/**
 取消关注通知点击事件
 */
- (void)notificationCancleFocus
{
    [self.mapView removeAnnotation:self.annotation];
    [self.distBtn removeFromSuperview];
}

/**
 距离显示按钮点击事件
 */
- (void)distBtnAction
{
    DetailAddressViewController *addressVC = [[DetailAddressViewController alloc]init];
    [[AppDelegate sharedAppDelegate] pushViewController:addressVC WithTitle:@"位置信息"];
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

//处理位置坐标更新
- (void)didUpdateBMKUserLocation:(BMKUserLocation *)userLocation
{
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

- (UIButton *)distBtn
{
    if (!_distBtn) {
        _distBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, kScreenHeight-70 -kBtnHeight, kScreenWidth, kBtnHeight)];
        _distBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _distBtn.titleLabel.font = [UIFont systemFontOfSize:14.0];
        [_distBtn setTitleColor:REDRGB forState:UIControlStateNormal];
        
        [_distBtn addTarget:self action:@selector(distBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_distBtn];
    }
    return _distBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

/**
 移除通知
 */
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
