//
//  PerfectHeadView.m
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/2.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import "PerfectHeadView.h"
#import "HCDataHelper.h"
#import <CoreLocation/CoreLocation.h>
#import "LocationViewController.h"

@interface PerfectHeadView ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,CLLocationManagerDelegate>

//定位管家
@property(nonatomic,strong)CLLocationManager *locationManager;
//解析地址
@property(nonatomic,strong)CLGeocoder *geocoder;

@end

@implementation PerfectHeadView

+ (instancetype)loadView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"PerfectHeadView" owner:nil options:nil] lastObject];
}

//获取定位信息
- (void)getLocationMsg
{
    //安全判断
    if (![CLLocationManager locationServicesEnabled]) {
        
        [self.viewController showErrorWith:@"硬件定位服务未开启"];
        return;
    }
    
    //请求用户开启定位服务
    if ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusNotDetermined) {
        
        // 发出授权请求
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
            
            // 授权请求需要对应不同的info设置
            [self.locationManager requestWhenInUseAuthorization];
        }
    }
    // 设置定位精度
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    // 设置定位距离，避免定位过于频繁,每隔多少米定位一次
    self.locationManager.distanceFilter = 10;
    // 开始定位
    [self.locationManager startUpdatingLocation];
}

//经纬度转化成地址名称
- (void)changeLocationWithLatitude:(CLLocationDegrees)latitude
                         longitude:(CLLocationDegrees)longitude{
    
    CLLocation *location = [[CLLocation alloc]initWithLatitude:latitude longitude:longitude];
    [self.geocoder reverseGeocodeLocation:location completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        
        if (error) return;
        
        for (CLPlacemark *pm in placemarks) {
            
            [self.locationBtn setTitle:[pm.addressDictionary objectForKey:@"City"] forState:UIControlStateNormal];
        }
        //停止定位服务
        [self.locationManager stopUpdatingLocation];
    }];
}

#pragma mark ----Action----

/**
 定位按钮点击事件

 @param sender 按钮
 */
- (IBAction)locationBtnAction:(UIButton *)sender {
    
    LocationViewController *locationVC = [[LocationViewController alloc]init];
    [[AppDelegate sharedAppDelegate]pushViewController:locationVC WithTitle:@"定位信息"];
}

/**
 头像按钮点击事件

 @param sender 按钮
 */
- (IBAction)headBtnAction:(UIButton *)sender {
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"头像选择" message:@"选择" preferredStyle:UIAlertControllerStyleActionSheet];
    
    //相册
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.delegate = self;
    
    UIAlertAction* action1 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) return;
        ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.viewController presentViewController:ipc animated:YES completion:nil];
    }];
    UIAlertAction* action2 = [UIAlertAction actionWithTitle:@"从相册上传" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {

        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) return;
        ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self.viewController presentViewController:ipc animated:YES completion:nil];
    }];
    
    UIAlertAction* cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:action1];
    [alertVC addAction:action2];
    [alertVC addAction:cancle];
    
    [self.viewController presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark ----CLLocationManagerDelegate----

//位置发生变化时,就会调用这个方法
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    
    for (CLLocation *loc in locations) {
        
        CLLocationCoordinate2D coor = loc.coordinate;
        
        [self changeLocationWithLatitude:coor.latitude longitude:coor.longitude];
    }
}

#pragma mark ----UIImagePickerControllerDelegate----

//获取图片后的操作
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.viewController showLoadingWith:@"正在加载图片"];
    
    //保存到沙河路径
    if (![self saveImgWithImg:info[UIImagePickerControllerOriginalImage]]) {
        
        [self saveImgWithImg:info[UIImagePickerControllerOriginalImage]];
    }
}

- (BOOL )saveImgWithImg:(UIImage *)img
{
    //保存到沙河路径
    NSData * imageData = UIImagePNGRepresentation([AppTools imageByScalingAndCroppingWithImg:img ForSize:CGSizeMake(200, 200)]);
    NSString *path = [HCDataHelper libCachePath];
    path = [path stringByAppendingPathComponent:@"headImgV.png"];
    BOOL isOK = [imageData writeToFile:path atomically:YES];
    
    if (isOK) {
        
        [self.viewController showSuccessWith:@"图片调用成功"];
        [self.headImgVBtn setImage:img forState:UIControlStateNormal];
        self.imgPath = path;
    }
    return isOK;
}

#pragma mark ----lazy----

/** 懒加载定位管家 */
-(CLLocationManager *)locationManager{
    
    if (!_locationManager) {
        
        _locationManager = [[CLLocationManager alloc]init];
        _locationManager.delegate = self;
    }
    return _locationManager;
}

/** 懒加载 */
-(CLGeocoder *)geocoder{
    
    if (!_geocoder) {
        
        _geocoder = [[CLGeocoder alloc]init];
    }
    return _geocoder;
}

@end
