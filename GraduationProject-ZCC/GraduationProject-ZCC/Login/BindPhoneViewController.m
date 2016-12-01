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
    self.sendSMSBtn.layer.cornerRadius = 5;
    self.sendSMSBtn.clipsToBounds = YES;
    self.sendSMSBtn.layer.borderColor = [UIColor redColor].CGColor;
    self.sendSMSBtn.layer.borderWidth = 2;
    
}

#pragma mark ----Action----

/**
 发送验证码按钮点击事件

 @param sender 按钮
 */
- (IBAction)sendSMSBtnAction:(UIButton *)sender {
    

    }


/**
 完成按钮点击事件
 */
- (IBAction)finishBtnAction {
    
    if (self.sms.text.length == 0) {
        
        [self showErrorWith:@"请输入验证码"];
        return ;
    }
    //绑定手机号码
    [BmobSMS verifySMSCodeInBackgroundWithPhoneNumber:self.phoneNum.text andSMSCode:self.sms.text resultBlock:^(BOOL isSuccessful, NSError *error) {
        
        if (isSuccessful) {
            //修改绑定手机
            BmobUser *buser = [BmobUser currentUser];
            buser.mobilePhoneNumber = self.phoneNum.text;
            
            [buser setObject:[NSNumber numberWithBool:YES] forKey:@"mobilePhoneNumberVerified"];
            [buser setObject:self.phoneNum.text forKey:@"mobilePhoneNumber"];
            
            [buser updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    
                    NSLog(@"%@",buser);
                    
                    [self showSuccessWith:@"绑定成功"];
                    [kUserDefaultDict setObject:@(NO) forKey:kBindPhone];
                    
                    [self dismissViewControllerAnimated:YES completion:nil];
                    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
