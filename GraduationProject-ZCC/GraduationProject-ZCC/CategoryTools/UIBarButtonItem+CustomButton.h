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
 创建一个UIBarButtonItem对象

 @param size 大小
 @param title 文字
 @param target 目标
 @param action 点击事件
 @return 对象
 */
+(instancetype)itemWithSize:(CGSize )size Title:(NSString*)title target:(id)target action:(SEL)action;

/**
 创建一个UIBarButtonItem对象
 
 @param size 大小
 @param imageName 图片
 @param target 目标
 @param action 点击事件
 @return 对象
 */
+ (instancetype )itemWithSize:(CGSize)size imgae:(NSString *)imageName target:(id)target action:(SEL)action;

@end
