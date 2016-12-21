//
//  PresentViewController.m
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/21.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import "PresentViewController.h"
#import "AboutUSViewController.h"
#import "SafeViewController.h"

static NSString *identifier = @"presentCell";

@interface PresentViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong)NSArray *titles;

@end

@implementation PresentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.backgroundColor = [UIColor clearColor];
    
    [self initData];
}

- (void)initData
{
    self.titles = @[@"账号安全",@"关于我们",@"退出登录"];
}

#pragma mark ----Delegate----

#pragma mark ----UITableViewDataSource----

//单元格个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titles.count;
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
    }
    cell.textLabel.text = self.titles[indexPath.row];
    
    if (indexPath.row == 2) {
        
        cell.textLabel.textColor = REDRGB;
    }
    
    return cell;
}

#pragma mark ----UITableViewDelegate----

//单元格点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //发送通知关闭控制器
    [[NSNotificationCenter defaultCenter] postNotificationName:@"dismissVC" object:nil];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row == 0) {
        
        //账号安全
        SafeViewController *safeVC = [[SafeViewController alloc]init];
        [[AppDelegate sharedAppDelegate] pushViewController:safeVC WithTitle:@"账号安全"];
        
    }else if (indexPath.row == 1){
        
        //关于我们
        AboutUSViewController *aboutVC = [[AboutUSViewController alloc]init];
        [[AppDelegate sharedAppDelegate] pushViewController:aboutVC WithTitle:@"关于我们"];
        
    }else if (indexPath.row == 2){
        
        //退出登录
        [AppTools alertViewWithTitle:@"确认退出?" WithMsg:@"" WithSureBtn:@"退出" WithCancleBtn:@"取消" WithVC:kRootViewController WithSureBtn:^{
            
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
