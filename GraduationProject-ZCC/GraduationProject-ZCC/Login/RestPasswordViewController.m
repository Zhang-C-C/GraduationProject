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

#pragma mark ----Action----

/**
 发送验证码按钮点击事件

 @param sender 按钮
 */
- (IBAction)smsSMSBtnAction:(UIButton *)sender {
    
}

/**
 完成按钮点击事件
 */
- (IBAction)finishBtnAction {
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
