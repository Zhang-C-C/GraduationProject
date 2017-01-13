//
//  FriendCirleViewController.m
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 17/1/13.
//  Copyright © 2017年 诺达科技. All rights reserved.
//

#import "FriendCirleViewController.h"
#import "FriendCirleCell.h"

static NSString *identifier = @"FriendCirleCell";

@interface FriendCirleViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIView *falseNavView;//假的导航栏
@property(nonatomic,strong)UIButton *addBtn;//发布按钮
@property(nonatomic,strong)UILabel *titleLabel;//标题

@end

@implementation FriendCirleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

- (void)initView
{
    self.navigationItem.leftBarButtonItem = nil;
    [self.view addSubview:self.tableView];
    //下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       
        [self.tableView.mj_header endRefreshing];
    }];
    //上拉刷新
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
       
        [self.tableView.mj_footer endRefreshing];
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }];
    
    

    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //隐藏导航栏
    [self.navigationController setNavigationBarHidden:YES];
    [self.view addSubview:self.falseNavView];
    [self.addBtn setTitle:@"发布" forState:UIControlStateNormal];

    
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
- (void)addBTnAction
{
    
}

#pragma mark ----Delegate----

#pragma mark ----UITableViewDataSource----

//单元格个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

//单元格内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FriendCirleCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    return cell;
}

#pragma mark ----UITableViewDelegate----

//单元格点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark----Lazy----

- (UITableView *)tableView
{
    if (!_tableView) {
        //添加表视图
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64-44) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        
        _tableView.rowHeight = 280;
        
        [_tableView registerNib:[UINib nibWithNibName:@"FriendCirleCell" bundle:nil] forCellReuseIdentifier:identifier];
    }
    return _tableView;
}

//假的导航栏
- (UIView *)falseNavView
{
    if (!_falseNavView) {
        _falseNavView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 64)];
        _falseNavView.backgroundColor = [UIColor clearColor];
        
    }
    return _falseNavView;
}

- (UIButton *)addBtn
{
    if (!_addBtn) {
        _addBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, kScreenWidth-64-10, 50, 64)];
        
        [_addBtn addTarget:self action:@selector(addBTnAction) forControlEvents:UIControlStateNormal];
        [self.falseNavView addSubview:_addBtn];
    }
    return _addBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
