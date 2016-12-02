//
//  PerfectViewController.m
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/2.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

//完善信息的控制器
#import "PerfectViewController.h"
#import "PerfectHeadView.h"
#import "PerfectMsgCell.h"

static NSString *identifier = @"perfectMsgCell";

@interface PerfectViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation PerfectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

- (void)initView
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    
    tableView.rowHeight = 49;
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor clearColor];
    //设置表视图头试图
    tableView.tableHeaderView = [PerfectHeadView loadView];
    
    //[tableView registerNib:[UINib nibWithNibName:@"PerfectMsgCell" bundle:nil] forCellReuseIdentifier:identifier];
    
    [tableView registerClass:[PerfectMsgCell class] forCellReuseIdentifier:identifier];
    
    [self.view addSubview:tableView];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithSize:CGSizeMake(50, 50) Title:@"跳过" target:self action:@selector(skipAction)];
}

//保存密码,并跳转到首页
- (void)skipToRootVC
{
    //保存用户名密码
    [kUserDefaultDict setObject:self.account forKey:kUserName];
    [kUserDefaultDict setObject:self.password forKey:kPassword];
    //重新设置跟试图控制器
    kRootViewController = [[MainViewController alloc]init];
}

#pragma mark ----Action----

/**
 跳过按钮
 */
- (void)skipAction
{
    [self skipToRootVC];
}

#pragma mark ----Delegate----
#pragma mark ----UITableViewDataSource----

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

//单元格个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        
        return 2;
    
    }else if (section == 1){
        
        return 1;
    }else{
        
        return 4;
    }
    return 0;
}

//单元格内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        
        PerfectMsgCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"PerfectMsgCell" owner:nil options:nil] lastObject];
        cell.indexPath = indexPath;
        
        return cell;
    }
    
    PerfectMsgCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"PerfectMsgCell" owner:nil options:nil] firstObject];
    cell.indexPath = indexPath;
    
    return cell;
}

#pragma mark ----UITableViewDelegate----

//单元格点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

//尾试图高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 30;
}

//头试图高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

//尾试图的文字
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        
        return @"签名";
    }else if (section == 1){
        
        return @"账号绑定";
    }
    return @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
