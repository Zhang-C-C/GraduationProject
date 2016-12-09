//
//  LockViewController.m
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/8.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import "LockViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "LockCell.h"

static NSString *identifier = @"lockCell";

@interface LockViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation LockViewController

/*
 //验证密码
 [AppTools evaluateAuthenticateWithSuccess:^{
 
 //重新设置跟试图控制器
 kRootViewController = [[MainViewController alloc]init];
 
 } Error:^(NSError *error) {
 
 NSLog(@"错误信息%@",error);
 }];
 */

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self initView];
}

- (void)initView
{
    //添加表视图
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor clearColor];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    
    [tableView registerNib:[UINib nibWithNibName:@"LockCell" bundle:nil] forCellReuseIdentifier:identifier];
    [self.view addSubview:tableView];
}

#pragma mark ----Delegate----

#pragma mark ----UITableViewDataSource----

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

//单元格个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

//单元格内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LockCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.indexPath = indexPath;
    
    return cell;
}

#pragma mark ----UITableViewDelegate----

//单元格点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0 && indexPath.section == 2) {
        
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
        NSLog(@"点击了重置密码");
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        
        return @"开启后,可使用Touch ID指纹解锁App";
    }else{
        
        return @"";
    }
    return @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
