//
//  SafeViewController.m
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/8.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import "SafeViewController.h"
#import "LoginViewController.h"

static NSString *identifier = @"cell";

@interface SafeViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation SafeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

- (void)initView
{
    //添加表视图
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor clearColor];
    //tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [self.view addSubview:tableView];
}

#pragma mark ----Delegate----

#pragma mark ----UITableViewDataSource----

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//单元格个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

//单元格内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    if (indexPath.row == 0) {
        
        cell.textLabel.text = @"AppUser";
        BmobUser *user = [BmobUser currentUser];
        
        cell.detailTextLabel.textColor = [UIColor whiteColor];
        cell.detailTextLabel.text = user.username;
        
    }else if (indexPath.row == 1) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.textLabel.text = @"修改登录密码";
    }
    return cell;
}

#pragma mark ----UITableViewDelegate----

//单元格点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 1) {
        
        [AppTools alertViewWithVC:self WithSuccessBlock:^(NSString *newPassword) {
            
            //用新密码登录
            [BmobUser loginInbackgroundWithAccount:[BmobUser currentUser].username andPassword:newPassword block:^(BmobUser *user, NSError *error) {
                
                if (error) {
                    
                    [self showErrorWith:@"使用新密码登录失败,请重试!"];
                    [BmobUser logout];
                    //重新设置跟试图控制器
                    LoginViewController *loginVC = [[LoginViewController alloc]init];
                    BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:loginVC];
                    kRootViewController = nav;
                    
                }else {
                    
                    [self showSuccessWith:@"密码修改成功"];
                    //保存用户名密码
                    [kUserDefaultDict setObject:user.username forKey:kUserName];
                    [kUserDefaultDict setObject:newPassword forKey:kPassword];
                }
            }];
            
        } WithErrorBlock:^(NSError *error) {
           
            [self showErrorWith:[NSString stringWithFormat:@"%@",error]];
        }];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"当前登录账号";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
