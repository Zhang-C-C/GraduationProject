//
//  PLockViewController.m
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/8.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import "PLockViewController.h"
#import "PasswordViewController.h"
#import "PasswordView.h"

@interface PLockViewController ()

@end

@implementation PLockViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.isTouchID) {
        
        [AppTools evaluateAuthenticateWithSuccess:^{
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        } Error:^(NSError *error) {
            
            if (self.isPassword) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                   
                    //加载密码锁页面
                    PasswordView *pView = [PasswordView loadView];
                    pView.isOpenTouchID = YES;
                    [pView setPasswordInputCorrect:^(BOOL isCorrect) {
                       
                        if (isCorrect) {
                            
                            [self dismissViewControllerAnimated:YES completion:nil];
                        
                        }else{
                            
                            [self dismissVC];
                        }
                    }];
                    
                    [self.view addSubview:pView];
                });
                
            }else{
                
                [self dismissVC];
            }
        }];
        
    }else{
        
        //加载密码锁页面
        PasswordView *pView = [PasswordView loadView];
        pView.isOpenTouchID = NO;
        [pView setPasswordInputCorrect:^(BOOL isCorrect) {
            
            if (isCorrect) {
                
                [self dismissViewControllerAnimated:YES completion:nil];
                
            }else{
                
                [self dismissVC];
            }
        }];
        [self.view addSubview:pView];
    }
}

/**
 退出登录
 */
- (void)dismissVC
{
    [self dismissViewControllerAnimated:YES completion:^{
        
        [self showSuccessWith:@"解锁密码错误,请重新登录"];
        //重新设置跟试图控制器
        [kUserDefaultDict removeObjectForKey:kPassword];
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:loginVC];
        kRootViewController = nav;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
