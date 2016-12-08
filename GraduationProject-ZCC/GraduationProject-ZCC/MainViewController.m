//
//  MianViewController.m
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/1.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import "MainViewController.h"
#import "BindPhoneViewController.h"
#import "LoginViewController.h"
#import "MeViewController.h"

@interface MainViewController ()

@property(nonatomic,strong)UIView *blackView;

@end

@implementation MainViewController

+ (void)initialize
{
    //设置标签栏按钮的选中未选中文字
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:REDRGB} forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]} forState:UIControlStateNormal];
    
    //设置导航栏透明
//    baseNav.navigationBar.barTintColor = [UIColor redColor];
//    baseNav.navigationBar.tintColor = [UIColor whiteColor];
    
//    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundImg-1.jpg"]]];
//    [[UINavigationBar appearance]setTintColor:[UIColor whiteColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
        
    [self initView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [[AppTools sharedInstance] chechPhoneBindedWithVC:self];
    });
}

- (void)initView
{
    //添加子控制器
    MeViewController *meVC = [[MeViewController alloc]init];
    BaseViewController *baseVC = [[BaseViewController alloc]init];
    
    NSArray *vcs = @[meVC,baseVC];
    NSArray *titles = @[@"我",@"Test"];
    NSArray *normalImgs = @[@"me_normal",@"me_normal"];
    NSArray *selectedImg = @[@"me_selected",@"me_selected"];
    for (int i = 0; i< vcs.count; i ++) {
        
        UIViewController *vc = vcs[i];
        vc.title = titles[i];
        
        BaseNavigationController *baseNav = [[BaseNavigationController alloc]initWithRootViewController:vc];
            
        //设置按钮图片
        baseNav.tabBarItem.image = [UIImage imageNamed:normalImgs[i]];
        baseNav.tabBarItem.selectedImage = [UIImage imageNamed:selectedImg[i]];

        [self addChildViewController:baseNav];
    }
    //设置标签栏样式
    self.tabBar.barStyle = UIBarStyleBlack;
    self.tabBar.alpha = 0.7;
}

#pragma mark ----Action----


#pragma mark ----Lazy----


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
