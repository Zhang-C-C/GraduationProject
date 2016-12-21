//
//  PopoverViewController.h
//  菜单栏展开与收起
//
//  Created by 诺达科技 on 16/10/26.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopoverViewController : UIPresentationController

/**
 *  弹出试图的frame ->如果不设置不会显示!!!
 */
@property(nonatomic,assign)CGRect presentViewFrame;

@end
