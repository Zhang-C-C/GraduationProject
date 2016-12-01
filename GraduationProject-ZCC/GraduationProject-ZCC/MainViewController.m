//
//  MianViewController.m
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/1.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import "MainViewController.h"
#import "BindPhoneViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

- (void)initView
{
    //安全判断,如果没有绑定弹出
    if ([[kUserDefaultDict objectForKey:kBindPhone] boolValue]) {
        
        //绑定手机号码页面
        BindPhoneViewController *bindVC = [[BindPhoneViewController alloc]init];
        [self presentViewController:bindVC animated:YES completion:nil];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
