//
//  LeftViewController.m
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/6.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import "LeftViewController.h"
#import "ThemeViewController.h"

@interface LeftViewController ()

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

- (void)initView
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeContactAdd];
    btn.frame = CGRectMake(100, 100, 80, 80);
 
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.view.clipsToBounds = YES;
    [self.view addSubview:btn];
}

- (void)btnAction
{
    ThemeViewController *themeVC = [[ThemeViewController alloc]init];
    themeVC.title = @"个性主题";
    [[AppDelegate sharedAppDelegate] pushViewController:themeVC];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    //[[AppDelegate sharedAppDelegate] pushViewController:[[BaseViewController alloc]init]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
