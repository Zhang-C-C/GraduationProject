//
//  AppDelegate.h
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/1.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

+ (instancetype)sharedAppDelegate;

/**
 推出控制器

 @param viewController 控制器
 */
- (void)pushViewController:(UIViewController *)viewController WithTitle:(NSString *)title;

@end

