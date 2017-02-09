//
//  FriendCirleViewController.m
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 17/1/13.
//  Copyright © 2017年 诺达科技. All rights reserved.
//

#import "FriendCirleViewController.h"
#import "FriendCirleCell.h"
#import "FriendCirleModel.h"
#import "PublicViewController.h"

static NSString *identifier = @"FriendCirleCell";

@interface FriendCirleViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIView *falseNavView;//假的导航栏
@property(nonatomic,strong)UIButton *addBtn;//发布按钮
@property(nonatomic,strong)UILabel *titleLabel;//标题

@property(nonatomic,strong)NSMutableArray *dataList;

@end

@implementation FriendCirleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)initView
{
    self.navigationItem.leftBarButtonItem = nil;
    [self.view addSubview:self.tableView];
    //下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       
        [self.dataList removeAllObjects];
        [self initData];
        [self.tableView.mj_header endRefreshing];
    }];
    //上拉刷新 7
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
       
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }];
}

- (void)initData
{
    BmobQuery *query = [BmobQuery queryWithClassName:@"friendCircle"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
       
        if (!error) {
            
            for (BmobObject *obj in array) {
                
                FriendCirleModel *model = [[FriendCirleModel alloc]init];
                model.name = [obj objectForKey:@"name"];
                model.time = [[NSString stringWithFormat:@"%@",obj.createdAt] substringToIndex:19];
                model.content = [obj objectForKey:@"content"];
                model.headImgV = [obj objectForKey:@"headImgV"];
                
                //查询数组中包含某些元素的记录
                model.medias = [obj objectForKey:@"medias"];
                
                [self.dataList addObject:model];
            }
            //倒序输出数组
            NSArray* reversedArray = [[self.dataList reverseObjectEnumerator] allObjects];
            self.dataList = (NSMutableArray *)reversedArray;
            
            [self.tableView reloadData];
            
        }else{
            
            [self showErrorWith:@"获取失败!"];
        }
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initView];
    //隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES];
    [self.view addSubview:self.falseNavView];
    [self.addBtn setTitle:@"发布" forState:UIControlStateNormal];
    self.titleLabel.text = @"好友动态";
    
    //刷新
    [self.dataList removeAllObjects];
    [self initData];
    [self.tableView.mj_header beginRefreshing];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];
}

#pragma mark ----Action----

/**
 发布按钮点击事件
 */
- (void)addBtnAction
{
    PublicViewController *publicVC = [[PublicViewController alloc]init];
    publicVC.title = @"发布动态";
    [self.navigationController pushViewController:publicVC animated:YES];
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
    FriendCirleCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if (self.dataList.count >0) {
        
         cell.model = self.dataList[indexPath.row];
    }
    return cell;
}

#pragma mark ----UITableViewDelegate----

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dataList.count >0) {
        
        FriendCirleModel *model = self.dataList[indexPath.row];
        return model.cellHeight;
    }else{
        
        return 0;
    }
}

//单元格点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark----Lazy----

- (UITableView *)tableView
{
    if (!_tableView) {
        //添加表视图
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-44-64) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        [_tableView registerNib:[UINib nibWithNibName:@"FriendCirleCell" bundle:nil] forCellReuseIdentifier:identifier];
    }
    return _tableView;
}

//假的导航栏
- (UIView *)falseNavView
{
    if (!_falseNavView) {
        _falseNavView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
        //_falseNavView.backgroundColor = [UIColor lightGrayColor];
        _falseNavView.backgroundColor = [[UIColor grayColor]colorWithAlphaComponent:0.5];
    }
    return _falseNavView;
}
//发布按钮
- (UIButton *)addBtn
{
    if (!_addBtn) {
        _addBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth-64-10, 20, 50, 44)];
        
        [_addBtn addTarget:self action:@selector(addBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self.falseNavView addSubview:_addBtn];
    }
    return _addBtn;
}
//标题文字
- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth/2 -50, 20, 100, 44)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
        [self.falseNavView addSubview:_titleLabel];
    }
    return _titleLabel;
}

- (NSMutableArray *)dataList
{
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc]init];
    }
    return _dataList;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
