//
//  AppTools.m
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/1.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import "AppTools.h"
#import "BindPhoneViewController.h"
#import <POP.h>

@interface AppTools ()

//记录计时器时间
@property(nonatomic,assign)NSInteger time;
//发送验证码按钮上的遮盖试图
@property(nonatomic,strong)UIView *maskView;

//是否正在下载文件
@property(nonatomic,assign)BOOL isDownLoading;

//HUD
@property(nonatomic,strong)UIView *hudView;
@property(nonatomic,assign)BOOL isShow;
@property(nonatomic,strong)UIButton *showBtn;

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

+ (void)updateUserMsgWithUserName:(NSString *)userName WithNickname:(NSString *)nickName WithPassword:(NSString *)password WithMobilePhone:(NSString *)mobilePhone WithImageUrl:(NSString *)imageUrl WithSaveSucBlock:(SaveSuccess )success WithSaveError:(SaveError )saveError
{
    //保存信息
    BmobUser *buser = [BmobUser currentUser];
    
    //保存信息
    if (userName.length >0) {
        
        [buser setObject:userName forKey:@"username"];
    }
    if (nickName.length >0) {
        
        [buser setObject:nickName forKey:@"nickName"];
    }
    if (password.length >0) {
        
        [buser setObject:password forKey:@"password"];
    }
    
    if (mobilePhone.length >0) {
        
        [buser setObject:mobilePhone forKey:@"mobilePhoneNumber"];
    }
    
    if (imageUrl.length >0) {
        
        [buser setObject:imageUrl forKey:@"imageUrl"];
    }
    
    [buser updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            
            if (success) {
                success();
            }
            
        }else{
            
            if (saveError) {
                saveError(error);
            }
        }
    }];
}

+ (void)updateUserMsgWithNickName:(NSString *)nickName WithImageUrl:(NSString *)imageUrl WithSex:(NSNumber *)sex WithQM:(NSString *)qm WithSaveSucBlock:(SaveSuccess )success WithSaveError:(SaveError )saveError
{
    //保存信息
    BmobUser *buser = [BmobUser currentUser];
    
    //保存信息
    if (nickName.length >0) {
        
        [buser setObject:nickName forKey:@"nickName"];
    }
    if (imageUrl.length >0) {
        
        [buser setObject:imageUrl forKey:@"imageUrl"];
    }
    
    [buser setObject:sex forKey:@"sex"];    
    
    if (qm.length >0) {
        
        [buser setObject:qm forKey:@"qm"];
    }
    
    [buser updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        if (isSuccessful) {
            
            if (success) {
                success();
            }
            
        }else{
            
            if (saveError) {
                saveError(error);
            }
        }
    }];
}


+ (void)alertViewWithTitle:(NSString *)title WithMsg:(NSString *)msg WithSureBtn:(NSString *)sureBtn WithCancleBtn:(NSString *)cancleBtn WithVC:(UIViewController *)vc WithSureBtn:(SureBtn )sure WithCancleBtn:(CancleBtn )cancle
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    //修改标题
    NSMutableAttributedString *alertControllerStr = [[NSMutableAttributedString alloc] initWithString:title];
    [alertControllerStr addAttribute:NSForegroundColorAttributeName value:ALERTREDRGB range:NSMakeRange(0, title.length)];
    //[alertControllerStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17] range:NSMakeRange(0, title.length)];
    
    [alertVC setValue:alertControllerStr forKey:@"attributedTitle"];

    //文本内容
    NSMutableAttributedString *alertControllerMessageStr = [[NSMutableAttributedString alloc] initWithString:msg];
    [alertControllerMessageStr addAttribute:NSForegroundColorAttributeName value:ALERTREDRGB range:NSMakeRange(0, msg.length)];
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
        [sureAction setValue:ALERTREDRGB forKey:@"titleTextColor"];
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

//图片压缩到指定大小
+ (UIImage*)imageByScalingAndCroppingWithImg:(UIImage *)sourceImage ForSize:(CGSize)targetSize
{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth= width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else if (widthFactor < heightFactor)
        {
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    
    UIGraphicsBeginImageContext(targetSize); // this will crop
    
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width= scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil)
        NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

/**
 检查手机号码是否已绑定
 */
- (void)chechPhoneBindedWithVC:(UIViewController *)vc
{
    //根据用户名查询
    NSString *userName = [kUserDefaultDict objectForKey:kUserName];
    
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"_User"];
    [bquery whereKey:@"username" equalTo:userName];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        if (!error) {
            
            for (BmobObject *obj in array) {
                
                NSString *phoneNum = [obj objectForKey:@"bindedPhone"];
                if (phoneNum.length == 0) {
                    
                    //绑定手机号码页面
                    BindPhoneViewController *bindVC = [[BindPhoneViewController alloc]init];
                    [vc presentViewController:bindVC animated:YES completion:nil];
                }
            }
        }else{
            
            NSLog(@"检查手机号码是否已绑定:%@",error);
        }
    }];
}

//开启定时器
- (void)startTimerWithBtn:(UIButton *)sendBtn WithTime:(NSInteger )time
{
    self.maskView.hidden = NO;
    self.maskView.frame = sendBtn.bounds;
    [sendBtn addSubview:self.maskView];
    
    self.time = time;
    
    dispatch_queue_t queue = dispatch_queue_create("lll", DISPATCH_QUEUE_SERIAL);
    dispatch_async(queue, ^{
        
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeChangeAction:) userInfo:@{@"sendBtn":sendBtn} repeats:YES];
        [[NSRunLoop currentRunLoop] run];// 如果没有这句，doSomething将不会执行！！！
    });
}

/**
 定时器事件
 
 @param timer 定时器
 */
- (void)timeChangeAction:(NSTimer *)timer
{
    NSDictionary *dic = timer.userInfo;
    UIButton *sendSMSBtn = dic[@"sendBtn"];
    
    self.time --;
    [sendSMSBtn setTitle:[NSString stringWithFormat:@"已发送%lds",self.time] forState:UIControlStateSelected];
    if (self.time == 0) {
        
        [timer invalidate];
        timer = nil;
        
        self.time = 60;
        sendSMSBtn.selected = NO;
        [sendSMSBtn setTitle:@"请重试!" forState:UIControlStateNormal];
        self.maskView.hidden = YES;
    }
}

//查询
+ (void)queryWithClassName:(NSString *)name Key:(NSString *)key EqualTo:(NSString *)some WithSuccess:(Success )success WithErroe:(Error )erro
{
    BmobQuery *query = [BmobQuery queryWithClassName:name];
    [query whereKey:key equalTo:some];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
       
        if (!error) {
            
            if (success) {
                
                success(array);
            }
            
        }else{
            
            if (error) {
                
                erro(error);
            }
        }
    }];
}

+ (void)alertViewWithVC:(UIViewController *)vc WithSuccessBlock:(ChangeSuccess )success WithErrorBlock:(ChangeError )err
{
    //修改密码
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"修改密码" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.placeholder = @"请输入旧密码";
        textField.secureTextEntry = YES;
        textField.clearButtonMode = UITextFieldViewModeAlways;
    }];
    
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        
        textField.borderStyle = UITextBorderStyleRoundedRect;
        textField.placeholder = @"请输入新密码";
        textField.secureTextEntry = YES;
        textField.clearButtonMode = UITextFieldViewModeAlways;
    }];
    
    //取消按钮
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:nil];
    [alertVC addAction:cancle];
    
    //确定按钮
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSString *old = alertVC.textFields[0].text;
        NSString *new = alertVC.textFields[1].text;
        
        if (old.length >0 &&new.length >0) {
            
            BmobUser *user = [BmobUser currentUser];
            [user updateCurrentUserPasswordWithOldPassword:old newPassword:new block:^(BOOL isSuccessful, NSError *error) {
                
                if (isSuccessful) {
                    
                    if (success) {
                        
                        success(new);
                    }
                    
                } else {
                    
                    if (err) {
                        err(error);
                    }
                }
            }];
        }
    }];
    [alertVC addAction:sure];
    
    [vc presentViewController:alertVC animated:YES completion:nil];
}


/**
 拿到缓存文件

 @return 大小
 */
+ (CGFloat )getClearCaches
{
    NSArray *array = [HCDataHelper GetFilesName:[HCDataHelper libCachePath]];
    CGFloat sizeOfCaches;
    
    for (NSString *fileName in array) {
        
        NSString *filePath = [[HCDataHelper libCachePath] stringByAppendingPathComponent:fileName];
        //计算大小
        sizeOfCaches += [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil].fileSize;
    }
    //B K M
    //CGFloat size = sizeOfCaches/1024.0/1024.0;
    CGFloat size = sizeOfCaches/1024.0;
    if (size <= 0.5) {
        size = 0.00;
    }
    return size;
}

/**
 清理缓存

 */
+ (void)clearCacheFileWithBlock:(ClearSuccess )success
{
    NSArray *array = [HCDataHelper GetFilesName:[HCDataHelper libCachePath]];
    __block CGFloat sizeOfCaches;
        
    //异步清理缓存
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        for (NSString *fileName in array) {
            
            NSString *filePath = [[HCDataHelper libCachePath] stringByAppendingPathComponent:fileName];
            
            if (![fileName isEqualToString:[kUserDefaultDict objectForKey:kTheme]]) {
                
                //清除文件
                [[NSFileManager defaultManager] removeItemAtPath:filePath error:nil];
            }
            //计算大小
            sizeOfCaches += [[NSFileManager defaultManager] attributesOfItemAtPath:filePath error:nil].fileSize;
        }
        if (sizeOfCaches/1024.0 <=0.5) {
            
            
        }
    });
    CGFloat size = sizeOfCaches/1024.0;
    if (size <= 0.5) {
        size = 0.00;
    }
    if (success) {
        success([NSString stringWithFormat:@"%.2f KB",size]);
    }
}

+ (BOOL )judgeIsFirstLogin
{
    NSDictionary* infoDict =[[NSBundle mainBundle] infoDictionary];
    NSString* versionNum =[infoDict objectForKey:@"CFBundleShortVersionString"];
    NSString *saveVersion = [kUserDefaultDict objectForKey:kVersion];
    
    if(saveVersion && [versionNum isEqualToString:saveVersion]) {
        
        //不是第一次使用这个版本
        return NO;
        
    }else{
        
        [kUserDefaultDict setObject:versionNum forKey:kVersion];
        [kUserDefaultDict synchronize];
        return YES;
    }
}

+ (NSString *)getUserIdentifier
{
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970]*1000;
    double i = time;      //NSTimeInterval返回的是double类型
    NSString * uniqueString = [NSString stringWithFormat:@"%.f",i];
    
    return uniqueString;
}

+ (BOOL)judgeIsSupportTouchID
{
    LAContext* context = [[LAContext alloc] init];
    NSError* error = nil;
    if (![context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        
        return NO;
    }else{
        
        return YES;
    }
}

+ (void)evaluateAuthenticateWithSuccess:(SaveSuccess )successBlock Error:(SaveError )failueBlock
{
    LAContext *context = [[LAContext alloc]init];
    NSError *error = nil;
    NSString *title = @"请验证已有指纹";
    
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        
        //支持指纹验证
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:title reply:^(BOOL success, NSError * _Nullable error) {
            
            if (success) {
                
                if (successBlock) {
                    successBlock();
                }
                
            }else{
                
                if (failueBlock) {
                    failueBlock(error);
                }
            }
        }];
    }
}

+ (void)saveDatatoPlistWithKey:(NSString *)key Value:(id )value FileName:(NSString *)fileName WithSuccess:(SaveSuccess )success Error:(SaveError )error
{
    //保存到plist文件
    NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
    [dic setObject:value forKey:key];
    
    NSString *caches = [HCDataHelper libCachePath];
    NSString *path = [caches stringByAppendingPathComponent:fileName];
    
    BOOL isOk = [dic writeToFile:path atomically:YES];
    
    if (isOk) {
        
        if (success) {
            success();
        }
        
    }else{
        
        if (error) {
            error(nil);
        }
    }
}

+ (void)saveArraytoPlistWithValue:(id )value FileName:(NSString *)fileName WithSuccess:(SaveSuccess )success Error:(SaveError )error
{
    //保存到plist文件
    NSMutableArray *array = [[NSMutableArray alloc]init];
    [array addObject:value];
    
    NSString *caches = [HCDataHelper libCachePath];
    NSString *path = [caches stringByAppendingPathComponent:fileName];
    
    BOOL isOk = [array writeToFile:path atomically:YES];
    
    if (isOk) {
        
        if (success) {
            success();
        }
        
    }else{
        
        if (error) {
            error(nil);
        }
    }
}

+ (void)getArrayFromPlistWithFileName:(NSString *)fileName Success:(SaveFileSuccess )success
{
    NSString *path = [[HCDataHelper libCachePath]stringByAppendingPathComponent:fileName];
    
    NSMutableArray *array = [NSMutableArray arrayWithContentsOfFile:path];
    NSLog(@"------%@----",array);
    
    if (success) {
        success(array);
    }
}

+ (void)getDataFromPlistWithFileName:(NSString *)fileName Success:(SavePSuccess )success
{
    NSString *path = [[HCDataHelper libCachePath]stringByAppendingPathComponent:fileName];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    NSLog(@"------%@----",dic);
    
    if (success) {
        success(dic);
    }
}

+ (void)sendLocalNitificationWithTitle:(NSString *)title WithContent:(NSString *)body WithTime:(CGFloat )second WithName:(NSString *)name WithImgV:(NSString *)imgV WithBock:(SureBtn )success
{
    //使用UNUserNotificationCenter来管理通知
    UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
    
    //创建包含待通知内容的UNMutableNotificationContent对象
    UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
    
    content.title = [NSString localizedUserNotificationStringForKey:title arguments:nil];
    content.body = [NSString localizedUserNotificationStringForKey:body arguments:nil];
    content.sound = [UNNotificationSound defaultSound];
    
    //在 alertTime 后推送本地推送
    second == 0?(second = 0.1):(second = second);
    UNTimeIntervalNotificationTrigger* trigger = [UNTimeIntervalNotificationTrigger triggerWithTimeInterval:second repeats:NO];
    
    UNNotificationRequest* request = [UNNotificationRequest requestWithIdentifier:@"FiveSecond" content:content trigger:trigger];
    
    //添加推送成功后的处理！
    [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
        
        if (error) {
            
            NSLog(@"推送失败:%@",error);
        
        }else{
            
            NSLog(@"推送成功");
            
            //先去读取
            BmobUser *user = [BmobUser currentUser];
            BmobObject *obj = [BmobObject objectWithoutDataWithClassName:@"_User" objectId:[user objectId]];
            
            //转为json 数据
            NSError *error = nil;

            //保存位置信息
            NSString *talatitude = [[SaveDataTools sharedInstance].TaAddressDic objectForKey:@"latitude"];
            NSString *talongitude = [[SaveDataTools sharedInstance].TaAddressDic objectForKey:@"longitude"];
            
            NSDictionary *dict = @{@"msg":body,@"time":[NSString stringWithFormat:@"%@",[NSDate date]],@"imgV":imgV,@"name":name,@"talatitude":talatitude,@"talongitude":talongitude};
            
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
            NSString *str = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            
            if (error || str.length == 0) {
                
                NSLog(@"转为json失败:%@",error);
                return ;
            }
            
            [obj addObjectsFromArray:@[str] forKey:@"msgArray"];
            [obj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                
                if (!error) {
                    
                    NSLog(@"提交成功");
                
                    if (success) {
                        success();
                    }
                    
                }else{
                    
                    
                    NSLog(@"提交:%@",error);
                }
                
            }];
           
        }
    }];
}

+ (void)alertTextFieldWithVC:(UIViewController *)vc WithSuccessBlock:(SavePSuccess )success WithError:(Error )cancleBlock
{
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"提示" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertVC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        //设置输入框的属性
        textField.borderStyle = UITextBorderStyleRoundedRect;
        //提示信息
        textField.placeholder = @"请输入对方用户名";
        textField.clearButtonMode = UITextFieldViewModeAlways;
    }];
    
    //取消按钮
    UIAlertAction *cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        
        if (cancleBlock) {
            cancleBlock(nil);
        }
        
    }];
    [alertVC addAction:cancle];
    
    //确定按钮
    UIAlertAction *sure = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        UITextField *userName = alertVC.textFields[0];
        
        if (userName.text.length >0) {
            
            if (success) {
                
                success(@{@"account":userName.text});
            }
            
        }else{
            
        }
    }];
    [alertVC addAction:sure];
    
    [vc presentViewController:alertVC animated:YES completion:nil];
}

/**
 判断今天是星期几
 
 @param date 日期
 @return 星期几
 */
+ (NSInteger)firstDayInFirstWeekThisMonth:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    [calendar setFirstWeekday:1];
    NSDateComponents *comp = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    comp.day = 1;
    NSDate *firstDayOfMonthDate = [calendar dateFromComponents:comp];
    NSUInteger firstWeekday = [calendar ordinalityOfUnit:NSCalendarUnitWeekday inUnit:NSCalendarUnitWeekOfMonth forDate:firstDayOfMonthDate];
    return firstWeekday-1;
}

//获取日期详细信息
+ (NSDateComponents *)getDateComponentsFromDate:(NSDate *)date
{
    NSDateComponents *component = [[NSCalendar currentCalendar] components:
                                   (NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay) fromDate:date];
    return component;
}

//求出date的这个月有多少天
+ (NSInteger)totalDaysThisMonth:(NSDate *)date
{
    NSRange range = [[NSCalendar currentCalendar] rangeOfUnit:NSCalendarUnitDay inUnit:NSCalendarUnitMonth forDate:date];
    return range.length;
}


+(NSInteger)getDaysFrom:(NSDate *)serverDate To:(NSDate *)endDate
{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    [gregorian setFirstWeekday:2];
    
    //去掉时分秒信息
    NSDate *fromDate;
    NSDate *toDate;
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&fromDate interval:NULL forDate:serverDate];
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&toDate interval:NULL forDate:endDate];
    NSDateComponents *dayComponents = [gregorian components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:0];
    
    return dayComponents.day;
}

+ (BOOL)clearCacheWithFilePath:(NSString *)path{
    
    //拿到path路径的下一级目录的子文件夹
    NSArray *subPathArr = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:nil];
    
    NSString *filePath = nil;
    
    NSError *error = nil;
    
    for (NSString *subPath in subPathArr)
    {
        filePath = [path stringByAppendingPathComponent:subPath];
        
        //删除子文件夹
        [[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
        if (error) {
            return NO;
        }
    }
    return YES;
}

/**
 检查是否存在
 */
- (NSString *)checkIsExitWithUrl:(NSString *)urlStr
{
    //检查是否已经存在文件
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches/video.plist"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:path];
    
    if ([dic allKeys].count >0) {
        
        NSString *filePath = [NSString stringWithFormat:@"%@",dic[urlStr]];
        
        if (![filePath isEqualToString:@"(null)"]) {
            
            //拼接新地址
            NSArray *arr = [filePath componentsSeparatedByString:@"/"];
            NSString *videoName = arr.lastObject;
            NSString *newStr = [path stringByReplacingOccurrencesOfString:@"video.plist" withString:videoName];
            NSLog(@"已存在:%@",newStr);
            
            return newStr;
            
        }else{
            
            //开始缓存
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self startCachesWithUR:urlStr];
            });
            return nil;
        }
        
    }else{
        
        //开始缓存
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self startCachesWithUR:urlStr];
        });
        return nil;
    }
    return nil;
}

/**
 根据URL在子线程开始缓存视频
 
 @param urlStr url地址
 */
- (void)startCachesWithUR:(NSString *)urlStr
{
    //关闭视频下载 !
    if (!self.isDownLoading) {
        
        NSLog(@"当前有任务正在下载...");
        return ;
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //1.创建会话管理者
        AFHTTPSessionManager *manager =[AFHTTPSessionManager manager];
        
        NSURL *url = [NSURL URLWithString:urlStr];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSURLSessionDownloadTask *download = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
            
            //开始下载
            self.isDownLoading = YES;
            
            //监听下载进度
            NSLog(@"已下载:%f",1.0 *downloadProgress.completedUnitCount / downloadProgress.totalUnitCount);
            
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            
            NSString *fullPath = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:response.suggestedFilename];
            return [NSURL fileURLWithPath:fullPath];
            
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            
            //下载完成
            self.isDownLoading = NO;
            
            //保存到沙河路径 以网址为key, 地址为value
            NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Library/Caches"];
            NSString *files = [path stringByAppendingPathComponent:@"video.plist"];
            
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithContentsOfFile:files];
            
            if ([dic allKeys].count == 0) {
                
                NSLog(@"不存在创建");
                dic = [[NSMutableDictionary alloc]init];
            }else{
                
                NSLog(@"已存在");
            }
            
            if ([NSString stringWithFormat:@"%@",filePath].length >0) {
                
                [dic setObject:[[NSString stringWithFormat:@"%@",filePath] substringFromIndex:7] forKey:urlStr];
            }
            
            BOOL isSave = [dic writeToFile:files atomically:YES];
            
            if (isSave) {
                
                NSLog(@"已保存");
                NSLog(@"最终地址filePath:%@",filePath);
            }
        }];
        
        //3.执行Task
        [download resume];
    });
}

#pragma mark ---Lazy----
- (UIView *)maskView
{
    if (!_maskView) {
        _maskView = [[UIView alloc]init];
        _maskView.backgroundColor = [UIColor grayColor];
        _maskView.alpha = 0.5;
    }
    return _maskView;
}

#pragma mark ---NewHUD----

- (void)showHUDViewWithType:(CCShowType )type WithText:(NSString *)text
{
    if (self.isShow) {
        
        return ;
    }
    self.isShow = YES;
    
    [self.showBtn setTitle:text forState:UIControlStateNormal];
    if (type == CCSuccessType) {
        
        [self.showBtn setImage:[UIImage imageNamed:@"success"] forState:UIControlStateNormal];
        [self.showBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
    }else if (type == CCErrorType){
        
        [self.showBtn setImage:[UIImage imageNamed:@"error"] forState:UIControlStateNormal];
        [self.showBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        
    }else if (type == CCMsgType){
        
        [self.showBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
    [self.hudView addSubview:self.showBtn];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.hudView];
    [[UIApplication sharedApplication].keyWindow bringSubviewToFront:self.hudView];
    
    POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
    //开始的位置
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGFloat height = 64;
    CGFloat x = 0;
    CGFloat startY = -height;
    animation.fromValue = [NSValue valueWithCGRect:CGRectMake(x, startY, width, height)];
    //最终的位置
    CGFloat endY = 0;
    animation.toValue = [NSValue valueWithCGRect:CGRectMake(x, endY, width, height)];
    //延时
    animation.beginTime = CACurrentMediaTime() +0.1;
    
    //设置振幅
    animation.springBounciness = 8;
    animation.springSpeed = 10;
    
    //添加动画
    [self.hudView pop_addAnimation:animation forKey:@"spring"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [UIView animateWithDuration:.3 animations:^{
            
            self.hudView.frame = CGRectMake(0, -64, [UIScreen mainScreen].bounds.size.width, 64);
            self.isShow = NO;
        }];
    });
}

- (UIView *)hudView
{
    if (!_hudView) {
        _hudView = [[UIView alloc]initWithFrame:CGRectMake(0, -64, [UIScreen mainScreen].bounds.size.width, 64)];
        _hudView.backgroundColor = [UIColor whiteColor];
    }
    return _hudView;
}

- (UIButton *)showBtn
{
    if (!_showBtn) {
        _showBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 30, self.hudView.frame.size.width, 30)];
        _showBtn.imageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _showBtn;
}

@end
