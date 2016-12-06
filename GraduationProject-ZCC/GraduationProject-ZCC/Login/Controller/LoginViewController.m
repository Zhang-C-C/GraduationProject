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
#import "PerfectViewController.h"

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
    if (userName.length == 0) {
        
        [self showErrorWith:@"请输入用户名或者手机号"];
        return ;
    }
    if (passweod.length ==0) {
        
        [self showErrorWith:@"请输入密码"];
        return ;
    }
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
            
            [AppTools alertViewWithTitle:@"登录失败" WithMsg:[NSString stringWithFormat:@"%@",error] WithSureBtn:@"重试" WithCancleBtn:@"取消" WithVC:self WithSureBtn:^{
                
                //重新发起登录
                [self loginWithAccount:self.account.text WithPassword:self.password.text];
                
            } WithCancleBtn:nil];
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

    //安全判断
    if (self.accountNotR.text.length == 0) {
        
        [self showErrorWith:@"请输入用户名"];
        return ;
    }
    if (self.passwordNotR.text.length ==0) {
        
        [self showErrorWith:@"请输入密码"];
        return ;
    }
    
    [self viewEndEniting];
    //注册账号
    BmobUser *user = [[BmobUser alloc]init];
    [user setUsername:self.accountNotR.text];
    [user setPassword:self.passwordNotR.text];
    
    [user signUpInBackgroundWithBlock:^(BOOL isSuccessful, NSError *error) {
       
        if (isSuccessful) {
            
            [self showLoadingWith:@"注册用户..."];
            
            //发起登录请求
            [BmobUser loginWithUsernameInBackground:self.accountNotR.text password:self.passwordNotR.text block:^(BmobUser *user, NSError *error) {
               
                if (!error) {
                    
                    [self showSuccessWith:@"登陆成功!"];
                    
                    //跳转到完善信息页面
                    PerfectViewController *perfectVC = [[PerfectViewController alloc]init];
                    perfectVC.title = @"完善信息";
                    perfectVC.isLogin = NO;
                    perfectVC.account = self.accountNotR.text;
                    perfectVC.password = self.passwordNotR.text;
                    [self.navigationController pushViewController:perfectVC animated:YES];
                
                }else{
                    
                    [self showErrorWith:[NSString stringWithFormat:@"%@",error]];
                }
            }];
            
        }else{
            
            [self showErrorWith:[NSString stringWithFormat:@"%@",error]];
        }
    }];
}

/**
 获取三方登录的用户信息

 @param platformType 类型
 */
- (void)getUserInfoForPlatform:(UMSocialPlatformType)platformType
{
    [[UMSocialManager defaultManager] getUserInfoWithPlatform:platformType currentViewController:self completion:^(id result, NSError *error) {
        
        if (error) {
            
            NSLog(@"三方登录失败:%@",error);
            [self showErrorWith:[NSString stringWithFormat:@"%@",error]];
            return ;
        }
        UMSocialUserInfoResponse *userInfo = result;
        UMSocialResponse *response = result;
        //发起登陆操作
        if (platformType == UMSocialPlatformType_QQ) {
            
            [self otherUserLoginWithToken:response.accessToken Withuid:response.uid WithExpirationDate:response.expiration WithuserInfo:userInfo WithType:BmobSNSPlatformQQ];

        }else if (platformType == UMSocialPlatformType_Sina){
            
            [self otherUserLoginWithToken:response.accessToken Withuid:response.uid WithExpirationDate:response.expiration WithuserInfo:userInfo WithType:BmobSNSPlatformSinaWeibo];
        }else{
            
            [self otherUserLoginWithToken:response.accessToken Withuid:response.uid WithExpirationDate:response.expiration WithuserInfo:userInfo WithType:BmobSNSPlatformWeiXin];
        }
    }];
}

/**
 发起三方登录

 @param token token
 @param uid uid
 @param date date
 */
- (void)otherUserLoginWithToken:(NSString *)token Withuid:(NSString *)uid WithExpirationDate:(NSDate *)date WithuserInfo:(UMSocialUserInfoResponse *)userInfo WithType:(BmobSNSPlatform )type
{
    [self showLoadingWith:@"正在登陆"];

    //得到授权信息，请按照例子来生成NSDictionary
    NSDictionary *dic = @{@"access_token":token,@"uid":uid,@"expirationDate":date};
    
    //通过授权信息注册登录
    [BmobUser loginInBackgroundWithAuthorDictionary:dic platform:type block:^(BmobUser *user, NSError *error) {
       
        if (!error) {
            
            [self showMsgWith:@"请设置用户名和密码"];
            //弹出输入框
            UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"" preferredStyle:UIAlertControllerStyleAlert];
            [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                //设置输入框的属性
                textField.borderStyle = UITextBorderStyleRoundedRect;
                //提示信息
                textField.placeholder = @"请输入用户名";
            }];
            [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.borderStyle = UITextBorderStyleRoundedRect;
                textField.secureTextEntry = YES;
                textField.placeholder = @"请输入密码";
            }];
            
            //取消按钮
            UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
                
                //保存信息
                [AppTools updateUserMsgWithUserName:nil WithNickname:userInfo.name WithPassword:nil WithMobilePhone:nil WithImageUrl:userInfo.iconurl WithSaveSucBlock:^{
                    
                    [self showSuccessWith:@"登陆成功"];
                    //跳到首页
                    kRootViewController = [[MainViewController alloc]init];
                    //保存用户的昵称
                    [kUserDefaultDict setObject:userInfo.name forKey:knickName];
                    
                } WithSaveError:^(NSError *error) {
                    
                    [self showErrorWith:[NSString stringWithFormat:@"%@",error]];
                }];
            }];
            [alertVC addAction:cancle];
            
            //确定按钮
            UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
               
                UITextField *userName = alertVC.textFields[0];
                UITextField *password = alertVC.textFields[1];
                
                NSLog(@"-------%@,%@------",userName.text,password.text);
                
                if (userName.text.length >0 &&password.text.length >0) {
                    
                    //保存信息
                    [AppTools updateUserMsgWithUserName:userName.text WithNickname:userInfo.name WithPassword:@"123456" WithMobilePhone:nil WithImageUrl:userInfo.iconurl WithSaveSucBlock:^{
                        
                        [self showSuccessWith:@"登陆成功"];
                        //保存用户名密码 ,跳到首页
                        [kUserDefaultDict setObject:userName.text forKey:kUserName];
                        [kUserDefaultDict setObject:password.text forKey:kPassword];
                        kRootViewController = [[MainViewController alloc]init];
                        //保存用户的昵称
                        [kUserDefaultDict setObject:userInfo.name forKey:knickName];
                        
                    } WithSaveError:^(NSError *error) {
                        
                        [self showErrorWith:[NSString stringWithFormat:@"%@",error]];
                    }];
                    
                }else{
                    
                    [self showErrorWith:@"请输入正确的格式"];
                }
            }];
            [alertVC addAction:sure];

            [self presentViewController:alertVC animated:YES completion:nil];
            
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
    
    [kUserDefaultDict removeObjectForKey:kUserName];
    [self getUserInfoForPlatform:UMSocialPlatformType_QQ];
}

/**
 微信登录按钮点击事件

 @param sender 按钮
 */
- (IBAction)weiChatbtnAction:(UIButton *)sender {
    
    [kUserDefaultDict removeObjectForKey:kUserName];
    [self getUserInfoForPlatform:UMSocialPlatformType_WechatSession];
}

/**
 新浪微博登录按钮点击事件

 @param sender 按钮
 */
- (IBAction)sinaBtnAction:(UIButton *)sender {
    
    [kUserDefaultDict removeObjectForKey:kUserName];
    [self getUserInfoForPlatform:UMSocialPlatformType_Sina];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
