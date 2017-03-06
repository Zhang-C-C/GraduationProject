//
//  DetailAddressViewController.m
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/15.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import "DetailAddressViewController.h"

@interface DetailAddressViewController ()<UITableViewDelegate,UITableViewDataSource,BMKGeoCodeSearchDelegate>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSArray *keys;

@property(nonatomic,strong)BMKGeoCodeSearch *mySearch;
@property(nonatomic,assign)double mylatitude;
@property(nonatomic,assign)double mylongitude;
@property(nonatomic,strong)NSArray *myAddresss;

@property(nonatomic,strong)BMKGeoCodeSearch *taSearch;
@property(nonatomic,assign)double talatitude;
@property(nonatomic,assign)double talongitude;
@property(nonatomic,strong)NSArray *taAddresss;

@end

@implementation DetailAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initData];
    [self initView];
}

- (void)initData
{
    self.keys = @[@"街道号码",@"街道名称",@"区县名称",@"城市名称",@"省份名称"];
    
    self.mylatitude = [[[SaveDataTools sharedInstance].myAddressDic objectForKey:@"latitude"] doubleValue];
    self.mylongitude = [[[SaveDataTools sharedInstance].myAddressDic objectForKey:@"longitude"] doubleValue];
    [self startGeoCodeWithSeacher:self.mySearch latitude:self.mylatitude longitude:self.mylongitude];
    
    self.talatitude = [[[SaveDataTools sharedInstance].TaAddressDic objectForKey:@"latitude"] doubleValue];
    self.talongitude = [[[SaveDataTools sharedInstance].TaAddressDic objectForKey:@"longitude"] doubleValue];
    [self startGeoCodeWithSeacher:self.taSearch latitude:self.talatitude longitude:self.talongitude];
}

/**
 根据经纬度计算位置

 @param latitude 经度
 @param longitude 纬度
 */
- (void)startGeoCodeWithSeacher:(BMKGeoCodeSearch *)seacher latitude:(double )latitude longitude:(double )longitude
{
    //反地理编码
    CLLocationCoordinate2D pt = (CLLocationCoordinate2D){latitude, longitude};
    BMKGeoCodeSearch *search = seacher;
    search.delegate = self;
    BMKReverseGeoCodeOption *option = [[BMKReverseGeoCodeOption alloc]init];
    option.reverseGeoPoint = pt;
    BOOL isOk = [search reverseGeoCode:option];
    
    if (isOk) {
        
        NSLog(@"反地理编码成功");
    }else{
        
        NSLog(@"反地理编码失败");
    }
}

- (void)initView
{
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self initData];
    }];
    [self.view addSubview:self.tableView];
}

#pragma mark ----Delegate----

#pragma mark ----UITableViewDataSource----

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

//单元格个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.keys.count;
}

//单元格内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"addressCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"addressCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.textColor = [UIColor whiteColor];

    
    if (indexPath.section == 0) {
        
        cell.textLabel.text = self.keys[indexPath.row];
        cell.detailTextLabel.text = self.taAddresss[indexPath.row];
        
    }else if (indexPath.section == 1){
        
        cell.textLabel.text = self.keys[indexPath.row];
        cell.detailTextLabel.text = self.myAddresss[indexPath.row];
    }
    
    return cell;
}

#pragma mark ----UITableViewDelegate----

//头试图高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

//设置头试图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, kScreenWidth-15, 30)];
    
    label.textColor = [UIColor lightGrayColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:14.0];
    
    section == 0?(label.text = @"     Ta的位置"):(label.text = @"     我的位置");
    
    return label;
}

#pragma mark----BMKGeoCodeSearchDelegate-----

//反地理编码
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    [self showLoadingWith:@"查询中"];
    
    if (searcher == self.mySearch) {
        
        [[AppTools sharedInstance]showHUDViewWithType:CCSuccessType WithText:@"查询成功"];
        //[self showSuccessWith:@"查询完成"];
        [self dismissHUD];
        
        //登录用户的的位置信息
        self.myAddresss = @[result.addressDetail.streetNumber,result.addressDetail.streetName,result.addressDetail.district,result.addressDetail.city,result.addressDetail.province];
        
        NSIndexSet *set = [[NSIndexSet alloc]initWithIndex:1];
        [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
        
    }else if (searcher == self.taSearch){
        
        [[AppTools sharedInstance]showHUDViewWithType:CCSuccessType WithText:@"查询成功"];
        //[self showSuccessWith:@"查询完成"];
        [self dismissHUD];
        
        //关注用户的位置信息
        self.taAddresss = @[result.addressDetail.streetNumber,result.addressDetail.streetName,result.addressDetail.district,result.addressDetail.city,result.addressDetail.province];
        NSIndexSet *set = [[NSIndexSet alloc]initWithIndex:0];
        [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
    }
    
    [self.tableView.mj_header endRefreshing];
}

#pragma mark ----lazy----

- (UITableView *)tableView
{
    if (!_tableView) {
        //添加表视图
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
        _tableView.backgroundColor = [UIColor clearColor];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (BMKGeoCodeSearch *)mySearch
{
    if (!_mySearch) {
        _mySearch = [[BMKGeoCodeSearch alloc]init];
    }
    return _mySearch;
}

- (BMKGeoCodeSearch *)taSearch
{
    if (!_taSearch) {
        _taSearch = [[BMKGeoCodeSearch alloc]init];
    }
    return _taSearch;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
