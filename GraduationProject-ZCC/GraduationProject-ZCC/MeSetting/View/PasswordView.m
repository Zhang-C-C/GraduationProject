//
//  PasswordView.m
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/8.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import "PasswordView.h"

@interface PasswordView ()

@property(nonatomic,assign)NSInteger count;

@property(nonatomic,assign)NSInteger index;

@property(nonatomic,copy)NSString *password;

@end

@implementation PasswordView

+ (instancetype)loadView
{
    return [[[NSBundle mainBundle]loadNibNamed:@"PasswordView" owner:nil options:nil] firstObject];
}

- (void)setIsOpenTouchID:(BOOL)isOpenTouchID
{
    _isOpenTouchID = isOpenTouchID;
    
    self.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [self.inputTf becomeFirstResponder];
    self.count = 3;
    self.tintColor = [UIColor clearColor];
    self.navbar.hidden = _isOpenTouchID;
    
    //读取密码
    [AppTools getDataFromPlistWithFileName:kPasswordFile Success:^(NSDictionary *dic) {
       
        self.password = [dic objectForKey:kPasswordName];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChangeNote) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)textFieldTextDidChangeNote
{
    self.index = self.inputTf.text.length;
    
    NSLog(@";;;;;%ld",self.index);
    
    if (self.index == 0) {
        
        self.p1.hidden = YES;
        self.p2.hidden = YES;
        self.p3.hidden = YES;
        self.p4.hidden = YES;
        self.p5.hidden = YES;
        
    }else if (self.index == 1) {
        
        self.p1.hidden = NO;
        self.p2.hidden = YES;
        self.p3.hidden = YES;
        self.p4.hidden = YES;
        self.p5.hidden = YES;
        
    }else if (self.index == 2){
        
        self.p1.hidden = NO;
        self.p2.hidden = NO;
        self.p3.hidden = YES;
        self.p4.hidden = YES;
        self.p5.hidden = YES;
        
    }else if (self.index == 3){
        
        self.p1.hidden = NO;
        self.p2.hidden = NO;
        self.p3.hidden = NO;
        self.p4.hidden = YES;
        self.p5.hidden = YES;
        
    }else if (self.index == 4){
        
        self.p1.hidden = NO;
        self.p2.hidden = NO;
        self.p3.hidden = NO;
        self.p4.hidden = NO;
        self.p5.hidden = YES;
        
    }else if (self.index == 5){
        
        self.p1.hidden = NO;
        self.p2.hidden = NO;
        self.p3.hidden = NO;
        self.p4.hidden = NO;
        self.p5.hidden = NO;
        
        if (self.password == self.inputTf.text) {
            
            if (_passwordInputCorrect) {
                
                _passwordInputCorrect(YES);
            }
            
            [self.viewController showSuccessWith:@"密码正确"];
            [self removeFromSuperview];
            
        }else{
            
            self.count --;
            self.alertLabel.text = [NSString stringWithFormat:@"请输入密码,解锁App,您有%ld次输入密码的机会",self.count];
             
            if (self.count == 0) {
                
                if (_passwordInputCorrect) {
                    _passwordInputCorrect(NO);
                    [self removeFromSuperview];
                }
                return ;
            }
            
            self.inputTf.text = nil;
            self.p1.hidden = YES;
            self.p2.hidden = YES;
            self.p3.hidden = YES;
            self.p4.hidden = YES;
            self.p5.hidden = YES;
            
            [AppTools alertViewWithTitle:@"提示" WithMsg:[NSString stringWithFormat:@"您还有%ld次输入密码的机会",self.count] WithSureBtn:@"重新输入" WithCancleBtn:@"" WithVC:self.viewController WithSureBtn:^{
                
            } WithCancleBtn:nil];
        }
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
