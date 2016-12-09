//
//  PasswordViewController.m
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/8.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import "PasswordViewController.h"

@interface PasswordViewController ()

@property(nonatomic,assign)NSInteger index;

@property(nonatomic,copy)NSString *pt1;
@property(nonatomic,copy)NSString *pt2;
@property(nonatomic,copy)NSString *pt3;
@property(nonatomic,copy)NSString *pt4;
@property(nonatomic,copy)NSString *pt5;

@end

@implementation PasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     [self initView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextDidChangeNote:) name:UITextFieldTextDidChangeNotification object:nil];
}

- (void)initView
{
    [self.inputTf becomeFirstResponder];
    //隐藏光标
    self.inputTf.tintColor = [UIColor clearColor];
}

- (void)textFieldTextDidChangeNote:(NSNotification *)note
{
    self.index = self.inputTf.text.length;
    
    if (self.index == 0) {
        
        self.p1.hidden = YES;
        self.p2.hidden = YES;
        self.p3.hidden = YES;
        self.p4.hidden = YES;
        self.p5.hidden = YES;
        
    }else if (self.index== 1) {
        
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
        
        [AppTools alertViewWithTitle:@"提示" WithMsg:@"密码已设置" WithSureBtn:@"确认" WithCancleBtn:@"再改改" WithVC:self WithSureBtn:^{
            
            //保存密码
            [AppTools saveDatatoPlistWithKey:kPasswordName Value:self.inputTf.text FileName:kPasswordFile WithSuccess:^{
                
                [self.inputTf resignFirstResponder];
                [self.navigationController popViewControllerAnimated:YES];
                
            } Error:^(NSError *error) {
                
                [self showErrorWith:@"保存失败,请重试"];
            }];
            
        } WithCancleBtn:nil];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
