//
//  UIViewController+HUDHelper.h
//  环信即时通讯
//
//  Created by 诺达科技 on 16/11/30.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SVProgressHUD.h>

@interface UIViewController (HUDHelper)

//提示信息

- (void)showSuccessWith:(NSString *)msg;

- (void)showErrorWith:(NSString *)msg;

- (void)showMsgWith:(NSString *)msg;

- (void)showLoadingWith:(NSString *)msg;

- (void)showProgressWith:(CGFloat )progress;

@end
