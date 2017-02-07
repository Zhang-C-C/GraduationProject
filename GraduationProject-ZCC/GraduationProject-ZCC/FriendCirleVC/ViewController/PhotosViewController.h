//
//  PhotosViewController.h
//  UI高级-03-九宫格图片
//
//  Created by wangjin on 16/7/6.
//  Copyright © 2016年 wangjin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotosViewControllerDelegate <NSObject>

//传递图片资源
-(void)returnSelectedPhotos:(NSArray *)photos;

@end

@interface PhotosViewController : UIViewController

@property(nonatomic, weak) id<PhotosViewControllerDelegate> delegate;//设置代理属性

@property(nonatomic, strong) NSArray *selcetPhotos;

@end

