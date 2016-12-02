//
//  MianViewController.m
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/1.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import "MainViewController.h"
#import "BindPhoneViewController.h"
#import "LoginViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self initView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [AppTools alertViewWithTitle:@"确认退出?" WithMsg:@"" WithSureBtn:@"退出" WithCancleBtn:@"取消" WithVC:self WithSureBtn:^{
        
        //退出登录,删除密码
        [BmobUser logout];
        [kUserDefaultDict removeObjectForKey:kPassword];
        
        //重新设置跟试图控制器
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:loginVC];
        kRootViewController = nav;
        
    } WithCancleBtn:nil];
}

- (void)initView
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [self chechPhoneBinded];
    });
}

/**
 检查手机号码是否已绑定
 */
- (void)chechPhoneBinded
{
    //根据用户名查询
    NSString *userName = [kUserDefaultDict objectForKey:kUserName];

    BmobQuery *bquery = [BmobQuery queryWithClassName:@"_User"];
    [bquery whereKey:@"username" equalTo:userName];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
       
        if (!error) {
            
            for (BmobObject *obj in array) {
                
                NSString *phoneNum = [obj objectForKey:@"mobilePhoneNumber"];
                if (phoneNum.length == 0) {
                    
                    //绑定手机号码页面
                    BindPhoneViewController *bindVC = [[BindPhoneViewController alloc]init];
                    [self presentViewController:bindVC animated:YES completion:nil];
                }
            }
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
