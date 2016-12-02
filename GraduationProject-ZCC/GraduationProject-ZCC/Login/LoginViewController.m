//
//  LoginViewController.m
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/1.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import "LoginViewController.h"
#import "BindPhoneViewController.h"
#import "RestPasswordViewController.h"

@interface LoginViewController ()<UITextFieldDelegate>

//登录框宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginViewWidth;

//注册框与登录框的间隔,根据不同屏幕确定
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *spaceConstraint;

//登录框中心线约束,位移动画的参数
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginViewConstarint;

//有无账号距离左侧的距离
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *accountBtnConstraint;

//记录距离
@property(nonatomic,assign)CGFloat space;

//登录相关
@property (weak, nonatomic) IBOutlet UITextField *account;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UIView *loginView;


//注册相关
@property (weak, nonatomic) IBOutlet UITextField *accountNotR;
@property (weak, nonatomic) IBOutlet UITextField *passwordNotR;
@property (weak, nonatomic) IBOutlet UIView *registerView;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self viewEndEniting];
}

- (void)initData
{
    //计算偏移距离
    self.space = (kScreenWidth -self.loginViewWidth.constant)/2;
    self.spaceConstraint.constant = self.space;
    self.accountBtnConstraint.constant = self.space;
    
    //自动登录
    NSString *userName = [kUserDefaultDict objectForKey:kUserName];
    NSString *password = [kUserDefaultDict objectForKey:kPassword];
    
    if (userName && password) {
        
        self.account.text = userName;
        self.password.text = password;
        [self loginWithAccount:userName WithPassword:password];
        
    }else if (userName){
        
        self.account.text = userName;
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
            //保存用户名密码
            [kUserDefaultDict setObject:self.account.text forKey:kUserName];
            [kUserDefaultDict setObject:self.password.text forKey:kPassword];
            
            //重新设置跟试图控制器
            kRootViewController = [[MainViewController alloc]init];
            
        }else{
            
            [self showErrorWith:[NSString stringWithFormat:@"%@",error]];
        }
    }];
}

//结束编辑
- (void)viewEndEniting
{
    [self.view endEditing:YES];
    [UIView animateWithDuration:.5 animations:^{
        
        self.loginView.transform = CGAffineTransformIdentity;
        self.registerView.transform = CGAffineTransformIdentity;
    }];
}

#pragma mark ----Delegate----

#pragma mark ----UITextFieldDelegate----

//将要开始编辑
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    [UIView animateWithDuration:.5 animations:^{
        
        self.loginView.transform = CGAffineTransformMakeTranslation(0, -40);
        self.registerView.transform = CGAffineTransformMakeTranslation(0, -40);
    }];
    return YES;
}

#pragma mark ----Action----

/**
 无账号/有账号按钮点击事件

 @param sender 按钮
 */
- (IBAction)changeViewBtnAction:(UIButton *)sender {
    
    [self.view endEditing:YES];
    sender.selected = !sender.selected;
    //弹出与收起注册框
    sender.selected?(self.loginViewConstarint.constant = - (self.space +self.loginViewWidth.constant)):(self.loginViewConstarint.constant = 0);
    [UIView animateWithDuration:.5 animations:^{
        
        //放大缩小动画的实现
        sender.selected?(self.loginView.transform = CGAffineTransformMakeScale(0.5, 0.5)):(self.loginView.transform = CGAffineTransformIdentity);
        sender.selected?(self.registerView.transform = CGAffineTransformIdentity):(self.registerView.transform = CGAffineTransformMakeScale(0.5, 0.5));
        
        [self.view layoutIfNeeded];
    }];
}

/**
 登录按钮点击事件

 @param sender 按钮
 */
- (IBAction)loginBtnAction:(UIButton *)sender {
    
    [self viewEndEniting];
    //根据账号登录,可以使手机号
    [self loginWithAccount:self.account.text WithPassword:self.password.text];
}

/**
 忘记密码按钮点击事件
 */
- (IBAction)resetPasswordBtnAction {
    
    //键盘消失
    [self viewEndEniting];
    //弹出新界面
    RestPasswordViewController *restVC = [[RestPasswordViewController alloc]init];
    restVC.title = @"忘记密码";
    [self.navigationController pushViewController:restVC animated:YES];
}

/**
 注册按钮点击事件

 @param sender 按钮
 */
- (IBAction)registerBtnAction:(UIButton *)sender {
    
    [self viewEndEniting];
    //注册账号
    BmobUser *user = [[BmobUser alloc]init];
    [user setUsername:self.accountNotR.text];
    [user setPassword:self.passwordNotR.text];
    
    [user signUpInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
       
        if (isSuccessful) {
            
            [self showSuccessWith:@"注册用户成功"];
            
            //发起登录请求
            [BmobUser loginWithUsernameInBackground:self.accountNotR.text password:self.passwordNotR.text block:^(BmobUser *user, NSError *error) {
               
                if (!error) {
                    
                    [self showSuccessWith:@"登陆成功!"];
                    
                    //保存用户名密码
                    [kUserDefaultDict setObject:self.accountNotR.text forKey:kUserName];
                    [kUserDefaultDict setObject:self.passwordNotR.text forKey:kPassword];

                    //重新设置跟试图控制器
                    kRootViewController = [[MainViewController alloc]init];
                
                }else{
                    
                    [self showErrorWith:[NSString stringWithFormat:@"%@",error]];
                }
            }];
            
        }else{
            
            [self showErrorWith:[NSString stringWithFormat:@"%@",error]];
        }
    }];
}

#pragma mark ----三方登录按钮点击事件----

/**
 QQ登录按钮点击事件

 @param sender 按钮
 */
- (IBAction)qqBtnAction:(UIButton *)sender {
    
    
    
}

/**
 微信登录按钮点击事件

 @param sender 按钮
 */
- (IBAction)weiChatbtnAction:(UIButton *)sender {
    
}

/**
 新浪微博登录按钮点击事件

 @param sender 按钮
 */
- (IBAction)sinaBtnAction:(UIButton *)sender {
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
