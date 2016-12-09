//
//  PasswordView.h
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/8.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PasswordCorrect)(BOOL isCorrect);

@interface PasswordView : UIView

@property(nonatomic,copy)PasswordCorrect passwordInputCorrect;

- (void)setPasswordInputCorrect:(PasswordCorrect)passwordInputCorrect;

@property (weak, nonatomic) IBOutlet UILabel *alertLabel;

@property (weak, nonatomic) IBOutlet UINavigationBar *navbar;

+(instancetype)loadView;

@property(nonatomic,assign)BOOL isOpenTouchID;

@property (weak, nonatomic) IBOutlet UITextField *inputTf;

@property (weak, nonatomic) IBOutlet UILabel *p1;

@property (weak, nonatomic) IBOutlet UILabel *p2;

@property (weak, nonatomic) IBOutlet UILabel *p3;

@property (weak, nonatomic) IBOutlet UILabel *p4;

@property (weak, nonatomic) IBOutlet UILabel *p5;

@end
