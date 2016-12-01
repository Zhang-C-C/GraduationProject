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

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    [self.window makeKeyAndVisible];
    self.window.backgroundColor = [UIColor lightGrayColor];
    
    //注册Bmob
    [Bmob registerWithAppKey:kBmobID];
    
    //设置跟试图控制器
    StartViewController *startVC = [[StartViewController alloc]init];
    BaseNavigationController *nav = [[BaseNavigationController alloc]initWithRootViewController:startVC];
    self.window.rootViewController = nav;
    
    return YES;
}

@end
