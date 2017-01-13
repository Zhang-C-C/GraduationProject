//
//  AppTools.h
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/1.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LocalAuthentication/LocalAuthentication.h>
#import <UserNotifications/UserNotifications.h>

//确认按钮
typedef void(^SureBtn)(void);
//取消按钮
typedef void(^CancleBtn)(void);

//保存信息成功
typedef void(^SaveSuccess)(void);
//保存信息失败
typedef void(^SaveError)(NSError *error);

//获取成功
typedef void(^Success)(NSArray *array);
//获取失败
typedef void(^Error)(NSError *error);

//修改成功
typedef void(^ChangeSuccess)(NSString *newPassword);
//修改失败
typedef void(^ChangeError)(NSError *error);

//清理成功
typedef void(^ClearSuccess)(NSString *newSize);

//保存密码
typedef void(^SavePSuccess)(NSDictionary *dic);

//保存密码
typedef void(^SaveFileSuccess)(NSMutableArray *array);

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

 mobile 手机号码
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

/**
 图片压缩到指定大小

 @param sourceImage 原图片
 @param targetSize 目标大小
 @return 新图片
 */
+ (UIImage*)imageByScalingAndCroppingWithImg:(UIImage *)sourceImage ForSize:(CGSize)targetSize;

/**
 检查手机号码是否已绑定
 @param vc 控制器
 */
- (void)chechPhoneBindedWithVC:(UIViewController *)vc;

/**
 查询某个表某一行数据

 @param name 表名字
 @param key 键
 @param some 值
 @param success 成功
 @param erro 失败
 */
+ (void)queryWithClassName:(NSString *)name Key:(NSString *)key EqualTo:(NSString *)some WithSuccess:(Success )success WithErroe:(Error )erro;

/**
 修改密码

 @param vc 控制器
 @param success 成功
 @param err 失败
 */
+ (void)alertViewWithVC:(UIViewController *)vc WithSuccessBlock:(ChangeSuccess )success WithErrorBlock:(ChangeError )err;

/**
 拿到缓存文件
 
 @return 大小
 */
+ (CGFloat )getClearCaches;

/**
 清理缓存
*/
+ (void)clearCacheFileWithBlock:(ClearSuccess )success;

/**
 判断当前版本号

 @return 是否第一次启动
 */
+ (BOOL )judgeIsFirstLogin;

/**
 获取用户的唯一标示吗

 @return 标志码
 */
+ (NSString *)getUserIdentifier;

/**
 是否支持Touch ID

 @return 是否
 */
+ (BOOL)judgeIsSupportTouchID;

/**
 是否验证成功

 @param successBlock 成功
 @param failueBlock 失败
 */
+ (void)evaluateAuthenticateWithSuccess:(SaveSuccess )successBlock Error:(SaveError )failueBlock;

/**
 保存文件到沙盒

 @param key key
 @param value value
 @param success 成功
 @param error 失败
 */
+ (void)saveDatatoPlistWithKey:(NSString *)key Value:(id )value FileName:(NSString *)fileName WithSuccess:(SaveSuccess )success Error:(SaveError )error;

/**
 读取沙河文件

 @param success 结果
 */
+ (void)getDataFromPlistWithFileName:(NSString *)fileName Success:(SavePSuccess )success;

/**
 本地推送

 @param title 标题
 @param body 副标题
 @param second 几秒之后推送
 */
+ (void)sendLocalNitificationWithTitle:(NSString *)title WithContent:(NSString *)body WithTime:(CGFloat )second WithName:(NSString *)name WithImgV:(NSString *)imgV WithBock:(SureBtn )success;

/**
 输入用户名密码

 @param vc 控制器
 @param success 成功回调
 @param cancleBlock 失败回调
 */
+ (void)alertTextFieldWithVC:(UIViewController *)vc WithSuccessBlock:(SavePSuccess )success WithError:(Error )cancleBlock;

/**
 本地文件数组

 @param fileName 文件名
 @param success 回调
 */
+ (void)getArrayFromPlistWithFileName:(NSString *)fileName Success:(SaveFileSuccess )success;

/**
 判断今天是星期几
 
 @param date 日期
 @return 星期几
 */
+ (NSInteger)firstDayInFirstWeekThisMonth:(NSDate *)date;

//获取日期详细信息
+ (NSDateComponents *)getDateComponentsFromDate:(NSDate *)date;

//求出date的这个月有多少天
+ (NSInteger)totalDaysThisMonth:(NSDate *)date;

/**
 检查是否存在
 */
- (NSString *)checkIsExitWithUrl:(NSString *)urlStr;

/**
 根据URL在子线程开始缓存视频
 
 @param urlStr url地址
 */
- (void)startCachesWithUR:(NSString *)urlStr;

@end
