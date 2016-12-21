//
//  PopoverViewController.m
//  菜单栏展开与收起
//
//  Created by 诺达科技 on 16/10/26.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import "PopoverViewController.h"

@implementation PopoverViewController

/**
 *  试图将要布局时调用
 */
- (void)containerViewWillLayoutSubviews
{
    //关闭VC的通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(closeAction) name:@"dismissVC" object:nil];
    
    //重新设置大小
    self.presentedViewController.view.frame = self.presentViewFrame;
  
    //添加蒙版
    UIView *blackView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    blackView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.2];
    
    //添加手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(closeAction)];
    [blackView addGestureRecognizer:tap];
    
    [self.containerView insertSubview:blackView atIndex:0];
}

/**
 * 关闭控制器
 */
- (void)closeAction
{
    [self.presentedViewController dismissViewControllerAnimated:YES completion:nil];
}

// 下面这几个方法,监听Modal控制器时的各种状态
- (void)presentationTransitionWillBegin
{
    //NSLog(@"presentationTransitionWillBegin");
    [self.containerView addSubview:self.presentedView]; // 因为是自定义转场动画,所以添加视图的工作也需要自行实现
}

- (void)dismissalTransitionDidEnd:(BOOL)completed
{
    //NSLog(@"dismissalTransitionDidEnd");
    [self.presentedView removeFromSuperview]; // 因为是自定义转场动画,所以移除视图的工作也需要自行实现
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
