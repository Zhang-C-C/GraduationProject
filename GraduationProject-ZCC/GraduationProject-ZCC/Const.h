//
//  Const.h
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/1.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#ifndef Const_h
#define Const_h

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

//偏好设置
#define kUserDefaultDict [NSUserDefaults standardUserDefaults]
//版本号
#define kVersion @"versionAtNow"
//用户名
#define kUserName @"userName"
//密码
#define kPassword @"userPassword"
//三方登录的昵称
#define knickName @"nickName"
//主题名字
#define kTheme @"themeSelected"
//切换主题的通知名字
#define kThemeChange @"themeChanged"

//跟试图控制器
#define kRootViewController [UIApplication sharedApplication].keyWindow.rootViewController

#define REDRGB [UIColor colorWithRed:136 / 255.0 green:34 / 255.0  blue:15 / 255.0  alpha:1.0]
#define ALERTREDRGB [UIColor colorWithRed:235 / 255.0 green:79 / 255.0  blue:60 / 255.0  alpha:1.0]

#define rgbColor(r, g, b, a) [UIColor colorWithRed:(r) / 255.0 green:(g) / 255.0  blue:(b) / 255.0  alpha:a]

//按钮的宽高
#define kBtnHeight 35
#define kBtnWidth 240

#define kTouchIDFile @"lock.plist"
#define kPasswordFile @"password.plist"
#define kPasswordName @"passwordName"

#endif /* Const_h */
