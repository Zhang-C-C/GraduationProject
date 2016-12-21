//
//  PopoverAnimator.h
//  菜单栏展开与收起
//
//  Created by 诺达科技 on 16/10/26.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface PopoverAnimator : NSObject <UIViewControllerTransitioningDelegate,UIViewControllerAnimatedTransitioning>

#warning ----如果不设置不会显示!!! 提供了两个通知...
/**
 *  设置弹出试图的frame
 */
@property(nonatomic,assign)CGRect presentedFrame;

@end
