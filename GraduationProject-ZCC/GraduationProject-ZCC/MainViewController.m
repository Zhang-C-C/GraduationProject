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
#import "LeftViewController.h"

@interface MainViewController ()

@property(nonatomic,strong)UIView *blackView;

@property(nonatomic,strong)LeftViewController *leftVC;

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
        
        [self chechPhoneBinded];
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
    
    //添加侧滑手势
    [self addLeftMenu];
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
                
                NSString *phoneNum = [obj objectForKey:@"bindedPhone"];
                if (phoneNum.length == 0) {
                    
                    //绑定手机号码页面
                    BindPhoneViewController *bindVC = [[BindPhoneViewController alloc]init];
                    [self presentViewController:bindVC animated:YES completion:nil];
                }
            }
        }else{
            
            NSLog(@"检查手机号码是否已绑定:%@",error);
        }
    }];
}

/**
 侧滑手势
 */
- (void)addLeftMenu
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    
    [self.view addGestureRecognizer:pan];
}

#pragma mark ----Action----

/**
 平移手势事件

 @param pan pan
 */
- (void)panAction:(UIPanGestureRecognizer *)pan
{
    NSInteger index = [pan translationInView:self.view].x;
    if (index >0) {
        
        [UIView animateWithDuration:.5 animations:^{
            
            //显示侧边栏
            self.view.transform = CGAffineTransformMakeTranslation(leftSpace, 0);
            self.leftVC.view.transform = CGAffineTransformMakeTranslation(leftSpace, 0);
            
        } completion:^(BOOL finished) {
            
            //添加蒙版
            self.blackView.hidden = NO;
        }];

    }else{
        
        //移除蒙版
        self.blackView.hidden = YES;
        [UIView animateWithDuration:.5 animations:^{
            
            self.view.transform = CGAffineTransformMakeTranslation(0, 0);
            self.leftVC.view.transform = CGAffineTransformMakeTranslation(0, 0);
        }];
    }
}

/**
 点击事件.收起侧边栏
 */
- (void)tapAction
{
    //移除蒙版
    self.blackView.hidden = YES;
    [UIView animateWithDuration:.5 animations:^{
        
        self.view.transform = CGAffineTransformMakeTranslation(0, 0);
        self.leftVC.view.transform = CGAffineTransformMakeTranslation(0, 0);
    }];
}

#pragma mark ----Lazy----

- (UIView *)blackView
{
    if (!_blackView) {
        
        _blackView = [[UIView alloc]initWithFrame:CGRectMake(leftSpace, 0, kScreenWidth-leftSpace, kScreenHeight)];
        _blackView.backgroundColor = [UIColor grayColor];
        _blackView.alpha = 0.3;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [_blackView addGestureRecognizer:tap];
        
        [[UIApplication sharedApplication].keyWindow addSubview:_blackView];
    }
    return _blackView;
}

- (LeftViewController *)leftVC
{
    if (!_leftVC) {
        _leftVC = [[LeftViewController alloc]init];
        _leftVC.view.frame = CGRectMake(-leftSpace, 0, leftSpace, kScreenHeight);
        [[UIApplication sharedApplication].keyWindow addSubview:self.leftVC.view];
    }
    return _leftVC;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
