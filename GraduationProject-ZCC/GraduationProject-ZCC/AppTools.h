//
//  AppTools.h
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/1.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SureBtn)(void);

typedef void(^CancleBtn)(void);

@interface AppTools : NSObject

+ (instancetype)sharedInstance;

/**
 弹出系统弹窗
 
 @param title 标题
 @param msg 内容
 @param sureBtn 确认按钮 如果不命名,不会创建
 @param cancleBtn 取消按钮 如果不命名,不会创建
 @param vc 当前控制器
 @param sure 确认点击事件block
 @param cancle 取消点击事件block
 */
+ (void)alertViewWithTitle:(NSString *)title WithMsg:(NSString *)msg WithSureBtn:(NSString *)sureBtn WithCancleBtn:(NSString *)cancleBtn WithVC:(UIViewController *)vc WithSureBtn:(SureBtn )sure WithCancleBtn:(CancleBtn )cancle;


/**
 判断手机号码是否符合规则

 mobile
*/
+ (BOOL)isValidateMobile:(NSString *)mobile;

/**
 计时器开启

 @param sendBtn 发送验证码的按钮
 @param time 总时间
 */
- (void)startTimerWithBtn:(UIButton *)sendBtn WithTime:(NSInteger )time;

@end
