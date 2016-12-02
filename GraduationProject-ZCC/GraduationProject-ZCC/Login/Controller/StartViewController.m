//
//  StartViewController.m
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/1.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import "StartViewController.h"
#import "LoginViewController.h"

@interface StartViewController ()

@end

@implementation StartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self initData];
}

- (void)initData
{
    //自动登录
    NSString *userName = [kUserDefaultDict objectForKey:kUserName];
    NSString *password = [kUserDefaultDict objectForKey:kPassword];
    
    if (userName && password) {
        
        [self loginWithAccount:userName WithPassword:password];
        
    }else{
        
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
}

/**
 根据用户名密码登录
 
 @param userName 用户名
 @param passweod 密码
 */
- (void)loginWithAccount:(NSString *)userName WithPassword:(NSString *)passweod
{
    //根据账号登录,可以使手机号
    [BmobUser loginInbackgroundWithAccount:userName andPassword:passweod block:^(BmobUser *user, NSError *error) {
        
        if (!error) {
            
            [self showSuccessWith:@"登录成功"];
            //重新设置跟试图控制器
            kRootViewController = [[MainViewController alloc]init];
            
        }else{
            
            [self showErrorWith:[NSString stringWithFormat:@"%@",error]];
            LoginViewController *loginVC = [[LoginViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:YES];
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
