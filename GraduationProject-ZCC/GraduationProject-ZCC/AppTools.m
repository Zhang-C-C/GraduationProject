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
    
    //修改标题
    NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:title];
    [alertControllerStr addAttribute:NSForegroundColorAttributeName value:REDRGB range:NSMakeRange(0, title.length)];
    //[alertControllerStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, title.length)];
    
    [alertVC setValue:alertControllerStr forKey:@"attributedTitle"];

    //文本内容
    NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:msg];
    [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:REDRGB range:NSMakeRange(0, msg.length)];
    //[alertControllerMessageStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:20] range:NSMakeRange(0, msg.length)];
    
    [alertVC setValue:alertControllerMessageStr forKey:@"attributedMessage"];
    
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
        [sureAction setValue:REDRGB forKey:@"titleTextColor"];
        [alertVC addAction:sureAction];
    }
    [vc presentViewController:alertVC animated:YES completion:nil];
}

/**
 *  判断手机号码是否符合规则
 */
+ (BOOL)isValidateMobile:(NSString *)mobile
{
    mobile = [mobile stringByReplacingOccurrencesOfString:@" " withString:@""];
    if (mobile.length != 11)
    {
        return NO;
    }else{
        
        //移动号段正则表达式
        NSString *CM_NUM = @"^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
        //联通号段正则表达式
        NSString *CU_NUM = @"^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
        
        //电信号段正则表达式
        NSString *CT_NUM = @"^((133)|(153)|(177)|(18[0,1,9]))\\d{8}$";
        NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
        BOOL isMatch1 = [pred1 evaluateWithObject:mobile];
        NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
        BOOL isMatch2 = [pred2 evaluateWithObject:mobile];
        NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
        BOOL isMatch3 = [pred3 evaluateWithObject:mobile];
        
        if (isMatch1 || isMatch2 || isMatch3) {
            return YES;
        }else{
            return NO;
        }
    }
}
@end
