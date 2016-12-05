//
//  BaseViewController.m
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/1.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initNavBtn];
    [self initBackground];
}

#pragma mark ----Init----

- (void)initNavBtn
{
    //设置返回按钮的样式
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithNoramlImgae:@"back" SelectedImage:nil target:self action:@selector(backBtnAction:)];
}

- (void)initBackground
{
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundImg-1.jpg"]];
}

#pragma mark ----Action----

/**
 导航栏返回按钮点击事件

 @param back 按钮
 */
- (void)backBtnAction:(UIButton *)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
