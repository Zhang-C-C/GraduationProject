//
//  BaseNavigationController.m
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/1.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
}

+ (void)initialize
{
    UINavigationBar* bar = [UINavigationBar appearance];
    
    //[bar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
    [bar setAlpha:0.1];
    //[bar setTintColor:REDRGB];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
