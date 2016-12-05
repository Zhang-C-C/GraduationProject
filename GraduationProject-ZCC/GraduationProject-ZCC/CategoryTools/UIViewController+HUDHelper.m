//
//  UIViewController+HUDHelper.m
//  环信即时通讯
//
//  Created by 诺达科技 on 16/11/30.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import "UIViewController+HUDHelper.h"

@implementation UIViewController (HUDHelper)

- (void)showSuccessWith:(NSString *)msg
{
    [SVProgressHUD showSuccessWithStatus:msg];
    [self performSelector:@selector(dismissHUD) withObject:nil afterDelay:1];
}

- (void)showErrorWith:(NSString *)msg
{
    [SVProgressHUD showErrorWithStatus:msg];
    [self performSelector:@selector(dismissHUD) withObject:nil afterDelay:1];
}

- (void)showMsgWith:(NSString *)msg
{
    [SVProgressHUD showInfoWithStatus:msg];
    [self performSelector:@selector(dismissHUD) withObject:nil afterDelay:1];
}

- (void)showLoadingWith:(NSString *)msg
{
    [SVProgressHUD showWithStatus:msg];
    //[self performSelector:@selector(dismissHUD) withObject:nil afterDelay:1];
}

- (void)showProgressWith:(CGFloat )progress
{
    [SVProgressHUD showProgress:progress];
    [self performSelector:@selector(dismissHUD) withObject:nil afterDelay:1];
}

- (void)dismissHUD
{
    [SVProgressHUD dismiss];
}

@end
