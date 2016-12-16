//
//  AppDelegate.m
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/1.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import "AppDelegate.h"
#import "StartViewController.h"
#import <UserNotifications/UserNotifications.h>

#define kBmobID @"9566251bffe6cac91c8f35d21abbb199"
#define kUMengAppKey @"584111fd310c9374c400007e"
#define kBaiduMap @"GmMh5AqZfOAYt1hllOkck9w03zxn3tfH"

@interface AppDelegate ()<UNUserNotificationCenterDelegate>

@property(nonatomic,assign)int count;

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
    //注册本地推送
    [self registerLocalNotification];
    //注册百度地图
    [self registerBaiduMap];
    
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

/**
 百度地图注册相关
 */
- (void)registerBaiduMap
{
    BMKMapManager *manager = [[BMKMapManager alloc]init];
    BOOL ret = [manager start:kBaiduMap generalDelegate:nil];
    if (!ret) {
        
        [self.window.rootViewController showErrorWith:@"百度地图管家启动失败"];
    }
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

//本地推送
- (void)registerLocalNotification
{
    // 使用 UNUserNotificationCenter 来管理通知
    UNUserNotificationCenter *center = [UNUserNotificationCenter currentNotificationCenter];
    //监听回调事件
    center.delegate = self;
    
    //iOS 10 使用以下方法注册，才能得到授权
    [center requestAuthorizationWithOptions:(UNAuthorizationOptionAlert +UNAuthorizationOptionSound) completionHandler:^(BOOL granted, NSError * _Nullable error) {
                              
          if (granted) {
              
              //NSLog(@"已授权");
              
          }else{
              
              NSLog(@"授权失败error:%@",error);
          }
      }];
    
    //获取当前的通知设置，UNNotificationSettings 是只读对象，不能直接修改，只能通过以下方法获取
    [center getNotificationSettingsWithCompletionHandler:^(UNNotificationSettings * _Nonnull settings) {
        
        //NSLog(@"%@",settings);
    }];
}

#pragma mark - UNUserNotificationCenterDelegate
//在展示通知前进行处理，即有机会在展示通知前再修改通知内容。
-(void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler{
    
    //1. 处理通知
    
    
    //2. 处理完成后条用 completionHandler ，用于指示在前台显示通知的形式
    completionHandler(UNNotificationPresentationOptionSound);
}

//推出控制器
- (void)pushViewController:(UIViewController *)viewController WithTitle:(NSString *)title
{
    @autoreleasepool
    {
        viewController.hidesBottomBarWhenPushed = YES;
        viewController.title = title;
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

/*
UIBackgroundTaskIdentifier taskId;

//进入后台
- (void)applicationDidEnterBackground:(UIApplication *)application
{
    NSLog(@"进入后台");
    //开启一个后台任务 ->让程序一直运行
    taskId = [application beginBackgroundTaskWithExpirationHandler:^{
        
        //结束指定的任务
        [application endBackgroundTask:taskId];
    }];

     [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerAction:) userInfo:nil repeats:YES];
}

//计时器事件
- (void)timerAction:(NSTimer *)timer {
    self.count++;
    
    if (self.count % 500 == 0) {
        UIApplication *application = [UIApplication sharedApplication];
        //结束旧的后台任务
        [application endBackgroundTask:taskId];
        
        //开启一个新的后台
        taskId = [application beginBackgroundTaskWithExpirationHandler:NULL];
    }
}
*/

@end
