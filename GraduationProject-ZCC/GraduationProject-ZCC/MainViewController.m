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

@end

@implementation MainViewController

+ (void)initialize
{
    //设置标签栏按钮的选中未选中文字
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:REDRGB} forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]} forState:UIControlStateNormal];
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
        
        [self chechPhoneBinded];
    });
}

- (void)initView
{
    //添加子控制器
    MeViewController *meVC = [[MeViewController alloc]init];
    
    NSArray *vcs = @[meVC];
    NSArray *titles = @[@"我"];
    NSArray *normalImgs = @[@"me_normal"];
    NSArray *selectedImg = @[@"me_selected"];
    for (int i = 0; i< vcs.count; i ++) {
        
        UIViewController *vc = vcs[i];
        vc.title = titles[i];
        
        BaseNavigationController *baseNav = [[BaseNavigationController alloc]initWithRootViewController:vc];
        
        //设置按钮图片
        baseNav.tabBarItem.image = [UIImage imageNamed:normalImgs[i]];
        baseNav.tabBarItem.selectedImage = [UIImage imageNamed:selectedImg[i]];

        [self addChildViewController:baseNav];
    }
}

/**
 检查手机号码是否已绑定
 */
- (void)chechPhoneBinded
{
    //根据用户名查询
    NSString *userName = [kUserDefaultDict objectForKey:kUserName];

    BmobQuery *bquery = [BmobQuery queryWithClassName:@"_User"];
    [bquery whereKey:@"username" equalTo:userName];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
       
        if (!error) {
            
            for (BmobObject *obj in array) {
                
                NSString *phoneNum = [obj objectForKey:@"mobilePhoneNumber"];
                if (phoneNum.length == 0) {
                    
                    //绑定手机号码页面
                    BindPhoneViewController *bindVC = [[BindPhoneViewController alloc]init];
                    [self presentViewController:bindVC animated:YES completion:nil];
                }
            }
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
