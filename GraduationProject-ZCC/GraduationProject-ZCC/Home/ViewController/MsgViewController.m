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
    
    //设置导航栏右侧按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"编辑" target:self action:@selector(rightBtnAction:)];
    
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
                        model.originalStr = str;
                        [self.dataList addObject:model];
                    }
                    
                    //倒序输出
                    for (int i = 0; i<self.dataList.count/2.0; i++) {
                        
                        [self.dataList exchangeObjectAtIndex:i withObjectAtIndex:array.count-1-i];
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

#pragma mark ---Action----

/**
 导航栏右侧按钮点击事件
 */
- (void)rightBtnAction:(UIButton *)btn
{
    btn.selected = !btn.selected;
    [btn setTitle:@"取消" forState:UIControlStateSelected];
    
    //编辑模式中,允许多选
    self.tableView.allowsMultipleSelectionDuringEditing = btn.selected;
    [self.tableView setEditing:btn.selected animated:YES];

    if (btn.selected) {
        
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithTitle:@"全选" target:self action:@selector(AllseleectedAction:)];
        
    } else {
        
        self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithNoramlImgae:@"back" SelectedImage:nil target:self action:@selector(backBtnAction)];
    }
}

/**
 全选按钮点击事件
 */
- (void)AllseleectedAction:(UIButton *)btn
{
    [btn setTitle:@"删除" forState:UIControlStateSelected];
    [btn setTitleColor:REDRGB forState:UIControlStateSelected];
    
    if (btn.selected) {
        
        [AppTools alertViewWithTitle:@"提示" WithMsg:@"确认全部删除?" WithSureBtn:@"确定" WithCancleBtn:@"取消" WithVC:self WithSureBtn:^{

            [self showLoadingWith:@"正在删除"];
            
            //获取所有选中的单元格
            NSArray *selectedArr = [self.tableView indexPathsForSelectedRows];
            NSMutableArray *arr = [[NSMutableArray alloc]init];
            for (NSInteger i = selectedArr.count -1; i >= 0; i--) {
                
                NSIndexPath *indexpath = [selectedArr objectAtIndex:i];
                MsgModel *model = self.dataList[indexpath.row];
                
                [arr addObject:model.originalStr];
            }
            
            //删除服务器的数据
            BmobObject *obj = [BmobObject objectWithoutDataWithClassName:@"_User" objectId:[BmobUser currentUser].objectId];
            [obj removeObjectsInArray:arr forKey:@"msgArray"];
            [obj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
               
                if (!error) {
                    
                    btn.selected = NO;
                    [self showSuccessWith:@"已删除"];
                    
                    //删除数据原数组
                    for (NSInteger i = selectedArr.count -1; i >= 0; i--) {
                        
                        NSIndexPath *indexpath = [selectedArr objectAtIndex:i];
                        MsgModel *model = self.dataList[indexpath.row];
                        [self.dataList removeObject:model];
                    }
                    [self.tableView deleteRowsAtIndexPaths:selectedArr withRowAnimation:UITableViewRowAnimationFade];
               
                }else{
                    
                    NSLog(@"%@",error);
                    [self showErrorWith:@"删除失败,请重试"];
                }
            }];
            
        } WithCancleBtn:nil];
        
    }else{
        
        btn.selected = YES;

        for (int i = 0; i <self.dataList.count; i ++) {
            
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionBottom];
        }
    }
}
/**
 返回按钮点击事件
 */
- (void)backBtnAction
{
    [self.navigationController popViewControllerAnimated:YES];
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
    if (tableView.editing) {
        
        return ;
    }
    
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

//开启编辑模式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

//删除事件操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //删除数据
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self showLoadingWith:@"正在删除"];
        
        MsgModel *model = self.dataList[indexPath.row];
        
        BmobObject *obj = [BmobObject objectWithoutDataWithClassName:@"_User" objectId:[BmobUser currentUser].objectId];
        [obj removeObjectsInArray:@[model.originalStr] forKey:@"msgArray"];
        [obj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            
            if (!error) {
                
                [self.dataList removeObject:model];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                
                [self showSuccessWith:@"已删除"];
                
            }else{
                [self showErrorWith:[NSString stringWithFormat:@"删除失败%@",error]];
                NSLog(@"删除失败:%@",error);
            }
        }];
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
