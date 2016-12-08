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
    //self.navigationController.navigationBar.hidden = YES;

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
    //设置表视图的偏移量
    //[self setupTableViewInset];
}

- (void)initData
{
    self.array = @[@"账号安全",@"个性主题",@"清理缓存",@"关于我们"];
    
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

- (void)setupTableViewInset
{
    if([self respondsToSelector:@selector(automaticallyAdjustsScrollViewInsets)]){
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        
        UIEdgeInsets insets = self.tableView.contentInset;
        
        insets.top = self.navigationController.navigationBar.bounds.size.height;
        
        self.tableView.contentInset =insets;
        
        self.tableView.scrollIndicatorInsets = insets;
    }
    
    self.tableView.frame = CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height);
}

#pragma mark ----Delegate----

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if (velocity.y >0) {
        
        [UIView animateWithDuration:.5 animations:^{
            
            //self.navigationController.navigationBar.hidden = YES;
        }];
        
    }else{
        
        [UIView animateWithDuration:.5 animations:^{
            
            //self.navigationController.navigationBar.hidden = NO;
        }];
    }
}

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
    
    if (indexPath.row == 2) {
        
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
        safeVC.title = @"账号安全";
        [[AppDelegate sharedAppDelegate] pushViewController:safeVC];
        
    }else if (indexPath.row == 1){
        
        ThemeViewController *themeVC = [[ThemeViewController alloc]init];
        themeVC.title = @"个性主题";
        [[AppDelegate sharedAppDelegate] pushViewController:themeVC];
        
    }else if (indexPath.row == 2){
        
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
        
    }else if (indexPath.row == 3){
        
        AboutUSViewController *aboutVC = [[AboutUSViewController alloc]init];
        aboutVC.title = @"关于我们";
        [[AppDelegate sharedAppDelegate] pushViewController:aboutVC];
    }
}

#pragma mark ----Action-----

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
