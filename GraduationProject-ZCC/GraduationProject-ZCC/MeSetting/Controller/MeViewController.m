//
//  MeViewController.m
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/5.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import "MeViewController.h"
#import "MeHeadView.h"
#import "LoginViewController.h"

@interface MeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)MeHeadView *headView;

@end

@implementation MeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initData];
}

- (void)initView
{
    //设置按钮样式
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithNoramlImgae:@"list_selected" SelectedImage:nil target:self action:@selector(listBtnAction)];
    
    //添加表视图
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 4, kScreenWidth, kScreenHeight-4) style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor clearColor];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    self.headView = [MeHeadView loadView];
    tableView.tableHeaderView = self.headView;
    
    //添加下拉刷新
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       
        //刷新数据
        [self initData];
    }];
    
    self.tableView = tableView;
    [self.view addSubview:tableView];
}

- (void)initData
{
    //获取数据
    [self.headView showUserMsgWithSucBlock:^{
        
        //获取数据成功的操作
        [self.tableView.mj_header endRefreshing];
        
    } WithFali:^(NSError *error) {
        
        [self.tableView.mj_header endRefreshing];
        [AppTools alertViewWithTitle:@"获取个人信息失败" WithMsg:[NSString stringWithFormat:@"%@",error] WithSureBtn:@"重试" WithCancleBtn:@"取消" WithVC:self WithSureBtn:^{
            
            [self initData];
            
        } WithCancleBtn:nil];
        
    }];
}
#pragma mark ----Delegate----

#pragma mark ----UITableViewDataSource----

//单元格个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

//单元格内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return nil;
}

#pragma mark ----UITableViewDelegate----

//单元格点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark ----Action-----
/**
 导航栏左侧按钮点击事件
 */
- (void)listBtnAction
{
    [AppTools alertViewWithTitle:@"确认退出?" WithMsg:@"" WithSureBtn:@"退出" WithCancleBtn:@"取消" WithVC:self WithSureBtn:^{
        
        //退出登录,删除密码
        [BmobUser logout];
        [kUserDefaultDict removeObjectForKey:kPassword];
        
        //重新设置跟试图控制器
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:loginVC];
        kRootViewController = nav;
        
    } WithCancleBtn:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
