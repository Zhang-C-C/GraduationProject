//
//  AppDelegate.m
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/1.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import "AppDelegate.h"
#import "StartViewController.h"

#define kBmobID @"9566251bffe6cac91c8f35d21abbb199"
#define kUMengAppKey @"584111fd310c9374c400007e"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    self.window.backgroundColor = [UIColor lightGrayColor];
    
    //注册友盟
    [self uMengShare];
    //注册Bmob
    [Bmob registerWithAppKey:kBmobID];
    
    //设置跟试图控制器
    StartViewController *startVC = [[StartViewController alloc]init];
    BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:startVC];
    self.window.rootViewController = nav;
    
    return YES;
}

/**
 友盟相关设置
 */
- (void)uMengShare
{
    //打开调试日志
    [[UMSocialManager defaultManager] openLog:YES];
    [[UMSocialManager defaultManager]setUmSocialAppkey:kUMengAppKey];

    //设置微信的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wxdc1e388c3822c80b" appSecret:@"3baf1193c85774b3fd9d18447d76cab0" redirectURL:@"http://mobile.umeng.com/social"];
    
    //设置分享到QQ互联的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"100424468"  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    
    //设置新浪的appKey和appSecret
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"3363372238"  appSecret:@"73fd22b1ea01183b3b8bfc1184bda874" redirectURL:@"http://www.baidu.com"];
}

//支持所有iOS系统
- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        //其他如支付等SDK的回调
    }
    return result;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey, id> *)options
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url];
    if (!result) {
        // 其他如支付等SDK的回调
    }
    return result;
}

+ (instancetype)sharedAppDelegate{
    return (AppDelegate *)[UIApplication sharedApplication].delegate;
}

//推出控制器
- (void)pushViewController:(UIViewController *)viewController
{
    @autoreleasepool
    {
        if ([self.window.rootViewController isKindOfClass:[MainViewController class]]) {
            
            MainViewController *mainVC = (MainViewController *)self.window.rootViewController;
            [mainVC tapAction];
        }
        viewController.hidesBottomBarWhenPushed = YES;
        [[self navigationViewController] pushViewController:viewController animated:YES];
    }
}

// 获取当前活动的navigationcontroller
- (UINavigationController *)navigationViewController
{
    if ([self.window.rootViewController isKindOfClass:[UINavigationController class]])
    {
        return (UINavigationController *)self.window.rootViewController;
    
    }else if ([self.window.rootViewController isKindOfClass:[UITabBarController class]]){
       
        UIViewController *selectVc = [((UITabBarController *)self.window.rootViewController) selectedViewController];
        
        if ([selectVc isKindOfClass:[UINavigationController class]]){
            
            return (UINavigationController *)selectVc;
        }
    }
    return nil;
}

@end
