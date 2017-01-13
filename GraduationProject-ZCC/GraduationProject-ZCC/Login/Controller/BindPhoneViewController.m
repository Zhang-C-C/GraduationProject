//
//  BindPhoneViewController.m
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/1.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import "BindPhoneViewController.h"

@interface BindPhoneViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneNum;

@property (weak, nonatomic) IBOutlet UITextField *sms;

@property (weak, nonatomic) IBOutlet UIButton *sendSMSBtn;

@end

@implementation BindPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initView];
}

- (void)initView
{
       
}

#pragma mark ----Action----

/**
 发送验证码按钮点击事件

 @param sender 按钮
 */
- (IBAction)sendSMSBtnAction:(UIButton *)sender {
    
    //安全判断手机号码
    if ([AppTools isValidateMobile:self.phoneNum.text]) {
      
        //UI变化
        sender.selected = !sender.selected;
        //开启定时器
        sender.selected?[[AppTools sharedInstance]startTimerWithBtn:sender WithTime:60]:0;
        
        //获取验证码
        [BmobSMS requestSMSCodeInBackgroundWithPhoneNumber:self.phoneNum.text andTemplate:@"测试SMS" resultBlock:^(int number, NSError *error) {
            
            if (!error) {
                
                [self showSuccessWith:@"发送成功,请注意查收"];
                
            }else{
                
                [self showErrorWith:[NSString stringWithFormat:@"%@",error]];
            }
        }];
    
    }else{
        
        [self showErrorWith:@"请输入正确的手机号码"];
    }
}

/**
 完成按钮点击事件
 */
- (IBAction)finishBtnAction {
    
    if (![AppTools isValidateMobile:self.phoneNum.text]) {
        
        [self showErrorWith:@"请输入正确的手机号码"];
        return ;
    }
    if (self.sms.text.length == 0) {
        
        [self showErrorWith:@"请输入验证码"];
        return ;
    }
    //绑定手机号码
    [BmobSMS verifySMSCodeInBackgroundWithPhoneNumber:self.phoneNum.text andSMSCode:self.sms.text resultBlock:^(BOOL isSuccessful, NSError *error) {
        
        if (isSuccessful) {
            //修改绑定手机
            BmobUser *buser = [BmobUser currentUser];
            
            //保存信息
            //[buser setObject:[NSNumber numberWithBool:YES] forKey:@"mobilePhoneNumberVer"];
            [buser setObject:self.phoneNum.text forKey:@"bindedPhone"];
            
            [buser updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    
                    if ([self.title isEqualToString:@"绑定手机号"]) {
                        
                        [self showSuccessWith:@"绑定手机号码成功"];
                        [self dismissViewControllerAnimated:YES completion:nil];
                    
                    }else{
                        
                        [self showSuccessWith:@"修改手机号码成功"];
                        [self.navigationController popViewControllerAnimated:YES];
                        [SaveDataTools sharedInstance].phoneNum = self.phoneNum.text;
                    }
                    
                }else{
                    
                    [self showErrorWith:[NSString stringWithFormat:@"%@",error]];
                }
            }];
            
        }else{
            
            [self showErrorWith:[NSString stringWithFormat:@"%@",error]];
            NSLog(@"%@",error);
        }
    }];
}

/**
 取消按钮点击事件
 */
- (IBAction)cancleBtnAction {
    
    [AppTools alertViewWithTitle:@"拒绝我?" WithMsg:@"绑定手机号后可以使用手机号码登录" WithSureBtn:@"那绑定吧" WithCancleBtn:@"不绑定了" WithVC:self WithSureBtn:nil WithCancleBtn:^{
       
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

#pragma mark ----Lazy----


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
