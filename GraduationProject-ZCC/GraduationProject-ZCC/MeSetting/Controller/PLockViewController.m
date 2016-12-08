//
//  PLockViewController.m
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/8.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import "PLockViewController.h"

@interface PLockViewController ()

@end

@implementation PLockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [AppTools evaluateAuthenticateWithSuccess:^{
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    } Error:^(NSError *error) {
       
        //加载密码锁页面
        
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
