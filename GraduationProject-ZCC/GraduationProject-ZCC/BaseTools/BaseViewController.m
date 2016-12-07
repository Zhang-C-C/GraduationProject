//
//  BaseViewController.m
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/1.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import "BaseViewController.h"
#import "HCDataHelper.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //设置返回按钮的样式
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithNoramlImgae:@"back" SelectedImage:nil target:self action:@selector(backBtnAction:)];

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
        self.view.backgroundColor = [UIColor colorWithPatternImage:img];
        
    }else{
        
        self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"backgroundImg-1.jpg"]];
    }
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
