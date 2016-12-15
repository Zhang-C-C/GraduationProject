//
//  MeViewController.m
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/5.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import "MeViewController.h"
#import "MeHeadView.h"
#import "ThemeViewController.h"
#import "SafeViewController.h"
#import "AboutUSViewController.h"
#import "PLockViewController.h"
#import "FocusViewController.h"

static NSString *identifier = @"cell";

@interface MeViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)MeHeadView *headView;

@property(nonatomic,strong)NSArray *array;

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
    //添加表视图
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
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
    
    //添加退出登录按钮
    [self addLogoutBtn];
    
    //设置导航栏的左侧按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithNoramlImgae:@"" SelectedImage:@"" target:self action:@selector(leftBtnAction)];
}

- (void)initData
{
    self.array = @[@"账号安全",@"个性主题",@"我的关注",@"清理缓存",@"关于我们"];
    
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

- (void)addLogoutBtn
{
    UIButton *logout = [[UIButton alloc]initWithFrame:CGRectMake((kScreenWidth-kBtnWidth)/2, kScreenHeight-kBtnHeight-144, kBtnWidth, kBtnHeight)];
    [logout setBackgroundColor:REDRGB];
    logout.layer.cornerRadius = 5;
    [logout setTitle:@"退出当前账号" forState:UIControlStateNormal];
    [logout setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [logout addTarget:self action:@selector(logoutBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tableView addSubview:logout];
}



#pragma mark ----Delegate----


#pragma mark ----UITableViewDataSource----

//单元格个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.array.count;
}

//单元格内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.textColor = [UIColor whiteColor];
    }
    cell.textLabel.text = self.array[indexPath.row];
    
    if (indexPath.row == 3) {
        
        CGFloat size = [AppTools getClearCaches];
        NSString *text = nil;
        size >= 1024.0?(text = [NSString stringWithFormat:@"%.2fMB",size/1024.0]):(text =  [NSString stringWithFormat:@"%.2fKB",size]);
        cell.detailTextLabel.text = text;
    }
    return cell;
}

#pragma mark ----UITableViewDelegate----

//单元格点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        
        SafeViewController *safeVC = [[SafeViewController alloc]init];
        [[AppDelegate sharedAppDelegate] pushViewController:safeVC WithTitle:@"账号安全"];
        
    }else if (indexPath.row == 1){
        
        ThemeViewController *themeVC = [[ThemeViewController alloc]init];
        [[AppDelegate sharedAppDelegate] pushViewController:themeVC WithTitle:@"个性主题"];
        
    }else if (indexPath.row == 2){
     
        //我的关注
        FocusViewController *focuesVC = [[FocusViewController alloc]init];
        [[AppDelegate sharedAppDelegate] pushViewController:focuesVC WithTitle:@"我的关注"];
        
    }else if (indexPath.row == 3){
        
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        if ([cell.detailTextLabel.text isEqualToString:@"0.00 KB"]) {
            
            [self showMsgWith:@"无需清理"];
            return ;
        }
        [AppTools alertViewWithTitle:@"确认清理?" WithMsg:@"清理缓存" WithSureBtn:@"确定" WithCancleBtn:@"取消" WithVC:self WithSureBtn:^{
            
            [self showLoadingWith:@"正在清理"];
            //清理缓存
            [AppTools clearCacheFileWithBlock:^(NSString *newSize) {
               
                cell.detailTextLabel.text = newSize;
                [self showSuccessWith:@"清理完成"];
            }];
            
        } WithCancleBtn:nil];
        
    }else if (indexPath.row == 4){
        
        AboutUSViewController *aboutVC = [[AboutUSViewController alloc]init];
        [[AppDelegate sharedAppDelegate] pushViewController:aboutVC WithTitle:@"关于我们"];
    }
}

#pragma mark ----Action-----

- (void)leftBtnAction
{
    //弹出密码验证页面
    PLockViewController *plockVC = [[PLockViewController alloc]init];
    
    [AppTools getDataFromPlistWithFileName:kTouchIDFile Success:^(NSDictionary *dic) {
        
        if ([dic[[BmobUser currentUser].username] boolValue]) {
            
            plockVC.isTouchID = YES;
        }
    }];
    
    [AppTools getDataFromPlistWithFileName:kPasswordFile Success:^(NSDictionary *dic) {
       
        if ([dic[kPasswordName] length] == 5) {
            
            plockVC.isPassword = YES;
        }
    }];
    
    if (plockVC.isTouchID || plockVC.isPassword) {
        
        [self presentViewController:plockVC animated:YES completion:nil];
    }
}

/**
 退出登录按钮
 */
- (void)logoutBtnAction
{
    [AppTools alertViewWithTitle:@"确认退出?" WithMsg:@"" WithSureBtn:@"退出" WithCancleBtn:@"取消" WithVC:self WithSureBtn:^{
        
        //退出登录,删除密码 和主题
        [BmobUser logout];
        [kUserDefaultDict removeObjectForKey:kPassword];
        [kUserDefaultDict removeObjectForKey:kTheme];
        
        [self showSuccessWith:@"已退出"];
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
