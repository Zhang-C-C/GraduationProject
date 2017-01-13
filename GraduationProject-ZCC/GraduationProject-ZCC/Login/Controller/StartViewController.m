//
//  StartViewController.m
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/1.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import "StartViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "WebViewController.h"

@interface StartViewController ()

@property(nonatomic,strong)UIImageView *showImgV;
@property(nonatomic,strong)UIButton *jumpBtn;

@property(nonatomic,assign)NSInteger second;

@end

@implementation StartViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    //安全判断是否第一次登陆
    if ([AppTools judgeIsFirstLogin]) {
        
        //加载引导页
        self.isAD = NO;
        [self initData];
        
    }else{
        
        [self initData];
    }
}

//隐藏电池条
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    }  
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
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
 广告展示
 */
- (void)addADShow
{
    self.second = 3;
    [self.view insertSubview:self.jumpBtn aboveSubview:self.showImgV];

    self.showImgV.image = [UIImage imageWithContentsOfFile:[[AppTools sharedInstance] checkIsExitWithUrl:self.adImgV]];
    
    //开启定时器
    [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeChangeAction:) userInfo:nil repeats:YES];
}

/**
 根据用户名密码登录
 
 @param userName 用户名
 @param passweod 密码
 */
- (void)loginWithAccount:(NSString *)userName WithPassword:(NSString *)passweod
{
    [self showLoadingWith:@"正在登陆"];
    //根据账号登录,可以使手机号
    [BmobUser loginInbackgroundWithAccount:userName andPassword:passweod block:^(BmobUser *user, NSError *error) {
        
        NSLog(@"根据用户名密码登录:%@",error);
        
        if (!error) {
            
            [self showSuccessWith:@"登录成功"];
            
            self.isAD ?([self addADShow]):(kRootViewController = [[MainViewController alloc]init]);
            
        }else{
            
            [self showErrorWith:[NSString stringWithFormat:@"%@",error]];
            LoginViewController *loginVC = [[LoginViewController alloc]init];
                        
            [self.navigationController pushViewController:loginVC animated:YES];
        }
    }];
}

#pragma mark ----Action----

/**
 定时器时间变化调用
 */
- (void)timeChangeAction:(NSTimer *)timer
{
    self.second --;
    
    [self.jumpBtn setTitle:[NSString stringWithFormat:@"%lds跳过",self.second] forState:UIControlStateNormal];
    if (self.second == 0) {
        
        [timer invalidate];
        timer = nil;
        
        [self jumpBtnAction];
    }
}

/**
 点击广告试图
 */
- (void)adAction
{
    WebViewController *web = [[WebViewController alloc]init];
    BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:web];
    web.title = @"广告页";
    web.adURL = self.adUrl;
    [self presentViewController:nav animated:YES completion:nil];
    
    [web setFinishShow:^{
       
        [self jumpBtnAction];
    }];
}

/**
 跳过按钮点击事件
 */
- (void)jumpBtnAction
{
    [UIView animateWithDuration:.1 animations:^{
        
        self.showImgV.alpha = 0;
        
    } completion:^(BOOL finished) {
        
        //重新设置跟试图控制器
        kRootViewController = [[MainViewController alloc]init];
        [self.showImgV removeFromSuperview];
    }];
}

#pragma mark ----Lazy----

- (UIImageView *)showImgV
{
    if (!_showImgV) {
        _showImgV = [[UIImageView alloc]initWithFrame:self.view.bounds];
        _showImgV.userInteractionEnabled = YES;
        _showImgV.alpha = 1.0;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(adAction)];
        [_showImgV addGestureRecognizer:tap];
        
        [self.view addSubview:_showImgV];
    }
    return _showImgV;
}

- (UIButton *)jumpBtn
{
    if (!_jumpBtn) {
        
        CGFloat width = 70;
        _jumpBtn = [[UIButton alloc]initWithFrame:CGRectMake(kScreenWidth -width, 20, width, kBtnHeight-10)];
        [_jumpBtn setTitle:@"3s跳过" forState:UIControlStateNormal];
        [_jumpBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _jumpBtn.layer.cornerRadius = 5;
        _jumpBtn.backgroundColor = [UIColor grayColor];
        _jumpBtn.titleLabel.font = [UIFont systemFontOfSize:12.0];
        _jumpBtn.alpha = 0.6;
        
        [_jumpBtn addTarget:self action:@selector(jumpBtnAction) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_jumpBtn];
    }
    return _jumpBtn;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
