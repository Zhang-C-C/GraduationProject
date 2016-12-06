//
//  AppTools.h
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/1.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import <Foundation/Foundation.h>

//确认按钮
typedef void(^SureBtn)(void);
//取消按钮
typedef void(^CancleBtn)(void);

//保存信息成功
typedef void(^SaveSuccess)(void);
//保存信息失败
typedef void(^SaveError)(NSError *error);

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

/**
 更新用户信息

 @param userName 用户名
 @param nickName 昵称
 @param password 密码
 @param mobilePhone 手机号
 @param imageUrl 头像url
 @param success 保存成功
 @param saveError 保存失败
 */
+ (void)updateUserMsgWithUserName:(NSString *)userName WithNickname:(NSString *)nickName WithPassword:(NSString *)password WithMobilePhone:(NSString *)mobilePhone WithImageUrl:(NSString *)imageUrl WithSaveSucBlock:(SaveSuccess )success WithSaveError:(SaveError )saveError;

/**
 更新用户信息

 @param nickName 昵称
 @param imageUrl 头像地址
 @param sex 性别
 @param qm 签名
 @param success 成功
 @param saveError 失败
 */
+ (void)updateUserMsgWithNickName:(NSString *)nickName WithImageUrl:(NSString *)imageUrl WithSex:(NSNumber *)sex WithQM:(NSString *)qm WithSaveSucBlock:(SaveSuccess )success WithSaveError:(SaveError )saveError;

//图片压缩到指定大小
+ (UIImage*)imageByScalingAndCroppingWithImg:(UIImage *)sourceImage ForSize:(CGSize)targetSize;

@end
