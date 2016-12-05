//
//  UIBarButtonItem+CustomButton.m
//  环信即时通讯
//
//  Created by 诺达科技 on 16/11/30.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import "UIBarButtonItem+CustomButton.h"

@implementation UIBarButtonItem (CustomButton)

+(instancetype)itemWithSize:(CGSize )size Title:(NSString*)title target:(id)target action:(SEL)action{
    
    //添加左侧按钮
    UIButton* button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.frame = CGRectMake(0, 0, size.width, size.height);
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    return [[self alloc]initWithCustomView:button];
}

+ (instancetype )itemWithSize:(CGSize)size imgae:(NSString *)imageName target:(id)target action:(SEL)action
{
    //设置返回按钮的样式
    UIButton * button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    //偏移按钮位置
    [button setImageEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
    
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *leftBarItem = [[UIBarButtonItem alloc]initWithCustomView:button];
    
    return leftBarItem;
}

@end
