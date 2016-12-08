//
//  AppTools.m
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/1.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import "AppTools.h"
#import "BindPhoneViewController.h"

@interface AppTools ()

//记录计时器时间
@property(nonatomic,assign)NSInteger time;
//发送验证码按钮上的遮盖试图
@property(nonatomic,strong)UIView *maskView;

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

@end
