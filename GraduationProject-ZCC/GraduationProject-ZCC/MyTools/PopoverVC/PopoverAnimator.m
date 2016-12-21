//
//  PopoverAnimator.m
//  菜单栏展开与收起
//
//  Created by 诺达科技 on 16/10/26.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import "PopoverAnimator.h"
#import "PopoverViewController.h"

@interface PopoverAnimator ()

/**
 *  监听展开还是收起的状态
 */
@property(nonatomic,assign)BOOL isPresent;

@end

@implementation PopoverAnimator

#pragma mark ----UIViewControllerTransitioningDelegate----
//设置谁来负责专场动画
- (UIPresentationController *)presentationControllerForPresentedViewController:(UIViewController *)presented presentingViewController:(UIViewController *)presenting sourceViewController:(UIViewController *)source
{
    PopoverViewController *popoverVC = [[PopoverViewController alloc]initWithPresentedViewController:presented presentingViewController:presenting];
    popoverVC.presentViewFrame = self.presentedFrame;
    return popoverVC;
}

//负责展示动画
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    self.isPresent = YES;
    
    //发送通知,展示试图
    [[NSNotificationCenter defaultCenter]postNotificationName:@"showMenu" object:nil
     ];
    return self;
}

//消失动画
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    self.isPresent = NO;
    //发送通知,关闭试图
    [[NSNotificationCenter defaultCenter]postNotificationName:@"closeMenu" object:nil
     ];
    return self;
}

//动画时长
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext
{
    return 0.3;
}

//动画样式 ->核心代码 如果想要修改动画样式,来这里修改即可
- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext
{
    if (self.isPresent) {
        
        //展开
        UIView *toView = [transitionContext viewForKey:UITransitionContextToViewKey];
        toView.transform = CGAffineTransformMakeScale(1.0, 0.0);
        
        //添加到容器 ->必须要有
        [[transitionContext containerView]addSubview:toView];
        
        //设置锚点
        toView.layer.anchorPoint = CGPointMake(0.5, 0);
        
        //执行动画
        [UIView animateWithDuration:.5 animations:^{
            
            toView.transform = CGAffineTransformIdentity;
            
        } completion:^(BOOL finished) {
            
            //告诉系统动画执行完毕
            [transitionContext completeTransition:YES];
        }];
        
    }else{
        
        UIView *fromView = [transitionContext viewForKey:UITransitionContextFromViewKey];
        [UIView animateWithDuration:0.5 animations:^{
            
            fromView.transform = CGAffineTransformMakeScale(1.0, 0.00001);
            
        } completion:^(BOOL finished) {
            
            [transitionContext completeTransition:YES];
        }];
    }
}

@end
