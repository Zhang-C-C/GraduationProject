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

//定时器时间
@property(nonatomic,assign)NSInteger time;

@end

@implementation BindPhoneViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.time = 10;

    [self initView];
}

- (void)initView
{
       
}

//开启定时器
- (void)startTimer
{
    dispatch_queue_t queue = dispatch_queue_create("lll", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
       
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeChangeAction:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] run];// 如果没有这句，doSomething将不会执行！！！
    });
}

#pragma mark ----Action----

/**
 定时器事件

 @param timer 定时器
 */
- (void)timeChangeAction:(NSTimer *)timer
{
    self.time --;
    [self.sendSMSBtn setTitle:[NSString stringWithFormat:@"已发送%lds",self.time] forState:UIControlStateSelected];
    if (self.time == 0) {
        
        [timer invalidate];
        timer = nil;

        self.time = 60;
        self.sendSMSBtn.selected = NO;
        [self.sendSMSBtn setTitle:@"请重试!" forState:UIControlStateNormal];
    }
}

/**
 发送验证码按钮点击事件

 @param sender 按钮
 */
- (IBAction)sendSMSBtnAction:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    //开启定时器
    sender.selected?[self startTimer]:0;
    
    return ;
    
    
    //安全判断手机号码
    if ([AppTools isValidateMobile:self.phoneNum.text]) {
      
        
        
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
            [buser setObject:[NSNumber numberWithBool:YES] forKey:@"mobilePhoneNumberVer"];
            [buser setObject:self.phoneNum.text forKey:@"mobilePhoneNumber"];
            
            [buser updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                if (isSuccessful) {
                    
                    [self showSuccessWith:@"绑定手机号码成功"];
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
