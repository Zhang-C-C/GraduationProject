//
//  UIBarButtonItem+CustomButton.h
//  环信即时通讯
//
//  Created by 诺达科技 on 16/11/30.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (CustomButton)

/**
 创建文字按钮

 @param title 文字
 @param target 目标
 @param action 事件
 @return 按钮
 */
+(instancetype)itemWithTitle:(NSString*)title target:(id)target action:(SEL)action;

/**
 创建UIBarItem对象

 @param normal 默认图片
 @param selectedImg 选中图片
 @param target 目标
 @param action 事件
 @return 按钮
 */
+ (instancetype )itemWithNoramlImgae:(NSString *)normal SelectedImage:(NSString *)selectedImg target:(id)target action:(SEL)action;

@end
