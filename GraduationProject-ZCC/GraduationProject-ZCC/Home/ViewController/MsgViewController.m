//
//  MsgViewController.m
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/15.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import "MsgViewController.h"
#import "MsgCell.h"
#import "MsgModel.h"

@interface MsgViewController ()<UITableViewDelegate,UITableViewDataSource,BMKGeoCodeSearchDelegate>

@property(nonatomic,strong)NSMutableArray *dataList;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSIndexPath *indexPath;


@property(nonatomic,strong)BMKGeoCodeSearch *taSearch;

@end

@implementation MsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
}

- (void)initData
{
    [self showLoadingWith:@"正在同步"];
    
    self.dataList = [[NSMutableArray alloc]init];
    
    //查询数组中包含某些元素的记录
    BmobQuery *query1 = [BmobQuery queryWithClassName:@"_User"];
    NSArray *array = @[@"P1"];
    [query1 whereKey:@"msgArray" notContainedIn:array];
    
    [query1 findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        if (error) {
        
            [self showErrorWith:@"同步失败"];
            NSLog(@"%@",error);
        
        } else {
        
            [self showSuccessWith:@"同步成功"];
            [self.tableView.mj_header endRefreshing];
            for (BmobObject *obj in array) {
            
                if ([[obj objectForKey:@"username"] isEqualToString:[BmobUser currentUser].username]) {
                    
                    NSArray *array = [obj objectForKey:@"msgArray"];
                    
                    for (NSString *str in array) {
                        
                        NSDictionary *dic = [[NSDictionary alloc]init];
                        dic = [dic dictionaryWithJsonString:str];
                        
                        MsgModel *model = [[MsgModel alloc]initWithDic:dic];
                        [self.dataList addObject:model];
                        [self.tableView reloadData];
                    }
                }
            }
        }
    }];
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

#pragma mark ----Delegate----

#pragma mark ----UITableViewDataSource----

//单元格个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataList.count;
}

//单元格内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MsgCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"MsgCell" owner:nil options:nil] firstObject];
    cell.model = self.dataList[indexPath.row];
    
    return cell;
}

#pragma mark ----UITableViewDelegate----

//单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MsgModel *model = self.dataList[indexPath.row];
    double height = [model cellHeight];
    model.isOpen ?(height += 50):(height);
    
    return height;
}

//单元格点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.indexPath = indexPath;
    
    MsgModel *model = self.dataList[indexPath.row];
    model.isOpen = !model.isOpen;
    model.isOpen ?(model.moreText = @"<<<"):(model.moreText = @">>>");
    
    if (model.isOpen) {
        
        if ([model.talatitude doubleValue] == 0.0) {
            
            model.locationText = @"未获取到当时的位置信息";
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            
        }else{
            
            if (![model.locationText containsString:@"Ta"]) {
                
                //开始定位
                [self startGeoCodeWithSeacher:self.taSearch latitude:[model.talatitude doubleValue] longitude:[model.talongitude doubleValue]];
                
            }else{
                
                model.locationText = model.locationText;
                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        }
        
    }else{
        
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark----BMKGeoCodeSearchDelegate-----

//反地理编码
- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKReverseGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    if (error) {
        
        [self showErrorWith:@"查询出错,请稍后重试"];
        return ;
    }
    
    NSLog(@"查询结果是:%@",result.address);
    MsgModel *model = self.dataList[self.indexPath.row];
    
    model.locationText = [NSString stringWithFormat:@"%@ Ta在'%@'附近",[model.time substringToIndex:20],result.address];
    
    [self.tableView reloadRowsAtIndexPaths:@[self.indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark ---Lazy----

- (UITableView *)tableView
{
    if (!_tableView) {
        //添加表视图
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerNib:[UINib nibWithNibName:@"MsgCell" bundle:nil] forCellReuseIdentifier:@"msgCell"];
        
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
           
            [self initData];
        }];
        
        [self.view addSubview:_tableView];
    }
    return _tableView;
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
