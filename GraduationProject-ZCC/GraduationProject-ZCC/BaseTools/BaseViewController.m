//
//  BaseViewController.m
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/1.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()<UIGestureRecognizerDelegate>

@property(nonatomic,strong)UIImageView *imgV;

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置返回按钮的样式
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithNoramlImgae:@"back" SelectedImage:nil target:self action:@selector(backBtnAction:)];
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    [self initBackground];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(initBackground) name:kThemeChange object:nil];
}

#pragma mark ----Init----

/**
 设置App主题
 */
- (void)initBackground
{
    //根据名字检索图片文件
    NSString *fileName = [kUserDefaultDict objectForKey:kTheme];
    if (fileName.length >0 &&[SaveDataTools isFileExist:fileName]) {
        
        NSString *caches = [HCDataHelper libCachePath];
        NSString *path = [caches stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",fileName]];
        NSData *data = [NSData dataWithContentsOfFile:path];
        UIImage *img = [UIImage imageWithData:data];
       
        self.imgV.image = img;
        
    }else{
        
        self.imgV.image = [UIImage imageNamed:@"backgroundImg.jpg"];
    }
    [self.view sendSubviewToBack:self.imgV];
}

#pragma mark ----Action----

/**
 导航栏返回按钮点击事件

 @param back 按钮
 */
- (void)backBtnAction:(UIButton *)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

/**
 移除通知
 */
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark ----Lazy----

- (UIImageView *)imgV
{
    if (!_imgV) {
        _imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _imgV.contentMode = UIViewContentModeScaleToFill;
        //添加一层蒙版
        UIView *blackView = [[UIView alloc]initWithFrame:_imgV.frame];
        blackView.backgroundColor = [UIColor blackColor];
        blackView.alpha = 0.3;
        [_imgV addSubview:blackView];
        
        [self.view addSubview:_imgV];
    }
    return _imgV;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
