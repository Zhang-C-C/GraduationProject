//
//  RestPasswordViewController.m
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/1.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import "RestPasswordViewController.h"

@interface RestPasswordViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneNum;

@property (weak, nonatomic) IBOutlet UITextField *sms;

@property (weak, nonatomic) IBOutlet UITextField *password;

@property (weak, nonatomic) IBOutlet UIButton *sendSMSBtn;

//定时器时间
@property(nonatomic,assign)NSInteger time;
//遮盖试图
@property(nonatomic,strong)UIView *maskView;

@end

@implementation RestPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

- (void)initView
{
    [AppTools alertViewWithTitle:@"抱歉" WithMsg:@"此功能暂时无法使用,我们正在完善自己..." WithSureBtn:@"确认" WithCancleBtn:nil WithVC:self WithSureBtn:^{
        
        [self.navigationController popViewControllerAnimated:YES];
        
    } WithCancleBtn:nil];
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
        self.maskView.hidden = YES;
    }
}

/**
 发送验证码按钮点击事件

 @param sender 按钮
 */
- (IBAction)smsSMSBtnAction:(UIButton *)sender {
    
    //安全判断手机号码
    if ([AppTools isValidateMobile:self.phoneNum.text]) {
        
        //UI变化
        sender.selected = !sender.selected;
        //开启定时器
        sender.selected?[self startTimer]:0;
        self.maskView.hidden = NO;
        [sender addSubview:self.maskView];
        
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
    
}

#pragma mark ----Lazy----

- (UIView *)maskView
{
    if (!_maskView) {
        _maskView = [[UIView alloc]initWithFrame:self.sendSMSBtn.bounds];
        _maskView.backgroundColor = [UIColor grayColor];
        _maskView.alpha = 0.5;
    }
    return _maskView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
