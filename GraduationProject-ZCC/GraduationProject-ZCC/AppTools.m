//
//  AppTools.m
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/1.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import "AppTools.h"

@interface AppTools ()

@end

@implementation AppTools

+ (instancetype)sharedInstance
{
    static AppTools *tools = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        tools = [[AppTools alloc]init];
    });
    return tools;
}

+ (void)alertViewWithTitle:(NSString *)title WithMsg:(NSString *)msg WithSureBtn:(NSString *)sureBtn WithCancleBtn:(NSString *)cancleBtn WithVC:(UIViewController *)vc WithSureBtn:(SureBtn )sure WithCancleBtn:(CancleBtn )cancle
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    if (cancleBtn.length >0) {
        
        //取消按钮
        UIAlertAction *cancleAction = [UIAlertAction actionWithTitle:cancleBtn style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
            if (cancle) {
                cancle();
            }
        }];
        [alertVC addAction:cancleAction];
    }
    
    if (sureBtn.length >0) {
        
        //确认按钮
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:sureBtn style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            if (sure) {
                sure();
            }
            
        }];
        [alertVC addAction:sureAction];
    }
    
    [vc presentViewController:alertVC animated:YES completion:nil];
}


@end
