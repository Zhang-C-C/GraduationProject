//
//  FocusViewController.m
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/13.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import "FocusViewController.h"
#import "FocusCell.h"

static NSString *identifier = @"focusCell";

@interface FocusViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;

@end

@implementation FocusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
}

- (void)initData
{
    //获取数据
    NSString *name = [SaveDataTools sharedInstance].focusName;
    
    if (name.length >0) {
        
        NSLog(@"我的关注:%@",name);
        [self initView];
        
    }else{
        
        //添加导航栏右侧按钮
        self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"添加" target:self action:@selector(rightBtnAction)];
        
        [AppTools alertTextFieldWithVC:self WithSuccessBlock:^(NSDictionary *dic) {
            
            //保存数据
            BmobUser *user = [BmobUser currentUser];
            NSString *userName = dic[@"account"];
            [user setObject:userName forKey:@"loverName"];
            [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                
                if (!error) {
                    
                    self.navigationItem.rightBarButtonItem = nil;
                    [self showSuccessWith:@"关注成功"];
                    [SaveDataTools sharedInstance].focusName = userName;
                    [self initView];
                    
                }else{
                    
                    NSLog(@"关注失败:%@",error);
                    [self showErrorWith:@"关注失败"];
                }
            }];
        } WithError:nil];
    }
}

- (void)initView
{
    //添加表视图
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) style:UITableViewStyleGrouped];
    tableView.backgroundColor = [UIColor clearColor];
    
    tableView.rowHeight = 65;
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerNib:[UINib nibWithNibName:@"FocusCell" bundle:nil] forCellReuseIdentifier:identifier];
    
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [tableView.mj_header endRefreshing];
        [tableView reloadData];
    }];
    
    self.tableView = tableView;
    [self.view addSubview:tableView];
}

/**
 导航栏右侧按钮
 */
- (void)rightBtnAction
{
    [self initData];
}

/**
 取消关注按钮点击事件

 @param sender 按钮
 */
- (void)cacleAction:(UIButton *)sender {
    
    [AppTools alertViewWithTitle:@"提示" WithMsg:@"取消关注" WithSureBtn:@"确定" WithCancleBtn:@"取消" WithVC:self WithSureBtn:^{
        
        //保存数据
        BmobUser *user = [BmobUser currentUser];
        [user setObject:@"" forKey:@"loverName"];
        [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            
            if (!error) {
                
                [self showSuccessWith:@"取消关注"];
                [SaveDataTools sharedInstance].focusName = @"";
                [self.tableView reloadData];
                //添加导航栏右侧按钮
                self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"添加" target:self action:@selector(rightBtnAction)];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"canclFocus" object:nil];
                
            }else{
                
                NSLog(@"关注失败:%@",error);
                [self showErrorWith:@"取消失败"];
            }
        }];
        
    } WithCancleBtn:nil];
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
    if ([SaveDataTools sharedInstance].focusName.length >0 ) {
        
        self.navigationItem.rightBarButtonItem = nil;
        return 1;
        
    }else{
        
        return 0;
    }
}

//单元格内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FocusCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    cell.userName = [SaveDataTools sharedInstance].focusName;
    
    [cell.cancleBtn addTarget:self action:@selector(cacleAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

#pragma mark ----UITableViewDelegate----

//单元格点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

//头试图高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30;
}

//设置头试图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(15, 0, kScreenWidth-15, 30)];
    label.text = @"    我的关注";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:14.0];
    
    return label;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
