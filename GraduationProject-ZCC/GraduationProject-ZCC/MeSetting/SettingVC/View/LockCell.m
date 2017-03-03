//
//  LockCell.m
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/8.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import "LockCell.h"
#import "PasswordViewController.h"

@implementation LockCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    
    self.leftLabel.hidden = NO;
    self.SwitchBtn.hidden = NO;
    
    self.reset.hidden = YES;
    
    if (indexPath.section == 0) {
        
        self.leftLabel.text = @"开启touch ID 指纹解锁";
        [AppTools getDataFromPlistWithFileName:kTouchIDFile Success:^(NSDictionary *dic) {
            
            if ([dic[[BmobUser currentUser].username] boolValue]) {
                
                [self openPasswordLock];
                [self.SwitchBtn setOn:YES];
            }
        }];
        
    }else if (indexPath.section == 1){
        
        self.leftLabel.text = @"开启密码锁";
        [AppTools getDataFromPlistWithFileName:kPasswordFile Success:^(NSDictionary *dic) {
            
            NSString *pass = dic[kPasswordName];
            if (pass.length == 5) {
               
                [self openPasswordLock];
                [self.SwitchBtn setOn:YES];
            }
        }];
        
    }else if (indexPath.section == 2){
        
        self.leftLabel.hidden = YES;
        self.SwitchBtn.hidden = YES;
        
        self.reset.hidden = NO;
    }
}

- (IBAction)SwitchAction:(UISwitch *)sender {
    
    if (self.indexPath.section == 0) {
        
        if ([AppTools judgeIsSupportTouchID]) {
            
            if (!sender.isOn) {
                
                [AppTools alertViewWithTitle:@"关闭Touch ID?" WithMsg:@"在您启动App时不需要验证密码" WithSureBtn:@"关闭" WithCancleBtn:@"取消" WithVC:self.viewController WithSureBtn:^{
                    
                    //保存信息
                    [AppTools saveDatatoPlistWithKey:[BmobUser currentUser].username Value:@(NO) FileName:kTouchIDFile WithSuccess:^{
                        
                        [[AppTools sharedInstance]showHUDViewWithType:CCSuccessType WithText:@"已关闭"];
                        //[self.viewController showSuccessWith:@"已关闭"];
                        [sender setOn:NO animated:YES];
                        
                    } Error:^(NSError *error) {
                        
                        [[AppTools sharedInstance]showHUDViewWithType:CCErrorType WithText:@"关闭失败,请重试"];
                        //[self.viewController showErrorWith:@"关闭失败,请重试"];
                        [sender setOn:YES animated:YES];
                    }];
                    
                } WithCancleBtn:^{
                    
                    [sender setOn:YES animated:YES];
                }];
                
            }else{
                
                [AppTools alertViewWithTitle:@"启用Touch ID?" WithMsg:@"在您启动App时需要验证密码" WithSureBtn:@"启用" WithCancleBtn:@"取消" WithVC:self.viewController WithSureBtn:^{
        
                    //保存信息
                    [AppTools saveDatatoPlistWithKey:[BmobUser currentUser].username Value:@(YES) FileName:kTouchIDFile WithSuccess:^{
                        
                        [[AppTools sharedInstance]showHUDViewWithType:CCSuccessType WithText:@"已开启"];
                        //[self.viewController showSuccessWith:@"已开启"];
                        [sender setOn:YES animated:YES];
                        
                    } Error:^(NSError *error) {
                       
                        [[AppTools sharedInstance]showHUDViewWithType:CCErrorType WithText:@"开启失败,请重试"];
                        //[self.viewController showErrorWith:@"开启失败,请重试"];
                        [sender setOn:NO animated:YES];
                    }];
                    
                } WithCancleBtn:^{
                    
                    [sender setOn:NO animated:YES];
                }];
            }
            
        }else{
            
            [sender setOn:NO animated:YES];
            //[self.viewController showErrorWith:@"您的设备不支持Touch ID"];
            [[AppTools sharedInstance]showHUDViewWithType:CCErrorType WithText:@"您的设备不支持Touch ID"];

            
            return ;
        }
        
    }else if (self.indexPath.section == 1){
        
        if (!sender.isOn) {
            
            [AppTools alertViewWithTitle:@"关闭密码锁?" WithMsg:@"在您启动App时不需要验证密码" WithSureBtn:@"关闭" WithCancleBtn:@"取消" WithVC:self.viewController WithSureBtn:^{
                
                //保存信息
                [AppTools saveDatatoPlistWithKey:kPasswordName Value:@"N" FileName:kPasswordFile WithSuccess:^{
                    
                    [sender setOn:NO animated:YES];
                    
                } Error:^(NSError *error) {
                   
                    [[AppTools sharedInstance]showHUDViewWithType:CCErrorType WithText:@"关闭失败,请重试"];
                    //[self.viewController showErrorWith:@"关闭失败,请重试"];
                }];

            } WithCancleBtn:^{
                
                [sender setOn:YES animated:YES];
            }];
            
        }else{
            
            [AppTools alertViewWithTitle:@"启用密码锁?" WithMsg:@"在您启动App时需要验证密码" WithSureBtn:@"启用" WithCancleBtn:@"取消" WithVC:self.viewController WithSureBtn:^{
                
                PasswordViewController *passwordVC = [[PasswordViewController alloc]init];
                [[AppDelegate sharedAppDelegate] pushViewController:passwordVC WithTitle:@"设置解锁密码"];
                
                //未设置密码时
                [sender setOn:NO animated:YES];
                
            } WithCancleBtn:^{
                
                [sender setOn:NO animated:YES];
            }];
        }
    }
}

/**
 开启密码锁的提示信息
 */
- (void)openPasswordLock
{
    [AppTools getDataFromPlistWithFileName:@"alert.plist" Success:^(NSDictionary *dic) {
       
        if (![[dic objectForKey:@"alert"] boolValue]) {
            
            [AppTools alertViewWithTitle:@"提示" WithMsg:@"您已开启密码锁,在'首页'-'我页面'-'点击屏幕左上角即可以进入保护模式',一般人我告诉他^_^" WithSureBtn:@"我知道了" WithCancleBtn:nil WithVC:self.viewController WithSureBtn:^{
                
                //保存此消息
                [AppTools saveDatatoPlistWithKey:@"alert" Value:@(YES) FileName:@"alert.plist" WithSuccess:^{
                    
                } Error:^(NSError *error) {
                    
                }];
                
            } WithCancleBtn:nil];
        }
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
