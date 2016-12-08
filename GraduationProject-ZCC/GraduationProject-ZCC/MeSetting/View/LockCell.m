//
//  LockCell.m
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/8.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import "LockCell.h"

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
        [AppTools getDataFromPlistWithFileName:kTouchIDFile Success:^{
           
            [self.SwitchBtn setOn:YES];
        }];
        
    }else if (indexPath.section == 1){
        
        self.leftLabel.text = @"开启密码锁";
    
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
                    
                    [AppTools saveDatatoPlistWithKey:[BmobUser currentUser].username Value:@(NO) FileName:kTouchIDFile WithSuccess:^{
                        
                        [self.viewController showSuccessWith:@"已关闭"];
                        [sender setOn:NO animated:YES];
                        
                    } Error:^(NSError *error) {
                        
                        [self.viewController showErrorWith:@"关闭失败,请重试"];
                        [sender setOn:YES animated:YES];
                    }];
                    
                } WithCancleBtn:^{
                    
                    [sender setOn:YES animated:YES];
                }];
                
            }else{
                
                [AppTools alertViewWithTitle:@"启用Touch ID?" WithMsg:@"在您启动App时需要验证密码" WithSureBtn:@"启用" WithCancleBtn:@"取消" WithVC:self.viewController WithSureBtn:^{
        
                    [AppTools saveDatatoPlistWithKey:[BmobUser currentUser].username Value:@(YES) FileName:kTouchIDFile WithSuccess:^{
                        
                        [self.viewController showSuccessWith:@"已开启"];
                        [sender setOn:YES animated:YES];
                        
                    } Error:^(NSError *error) {
                       
                        [self.viewController showErrorWith:@"开启失败,请重试"];
                        [sender setOn:NO animated:YES];
                    }];
                    
                } WithCancleBtn:^{
                    
                    [sender setOn:NO animated:YES];
                }];
            }
            
        }else{
            
            [sender setOn:NO animated:YES];
            [self.viewController showErrorWith:@"您的设备不支持Touch ID"];
            
            return ;
        }
        
    }else if (self.indexPath.section == 1){
        
        if (!sender.isOn) {
            
            [AppTools alertViewWithTitle:@"关闭密码锁?" WithMsg:@"在您启动App时不需要验证密码" WithSureBtn:@"关闭" WithCancleBtn:@"取消" WithVC:self.viewController WithSureBtn:^{
                
                [sender setOn:NO animated:YES];
                
            } WithCancleBtn:^{
                
                [sender setOn:YES animated:YES];
            }];
            
        }else{
            
            [AppTools alertViewWithTitle:@"启用密码锁?" WithMsg:@"在您启动App时需要验证密码" WithSureBtn:@"启用" WithCancleBtn:@"取消" WithVC:self.viewController WithSureBtn:^{
                
                
                
                [sender setOn:YES animated:YES];
                
            } WithCancleBtn:^{
                
                [sender setOn:NO animated:YES];
            }];
        }
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
