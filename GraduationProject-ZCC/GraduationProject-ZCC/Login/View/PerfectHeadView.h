//
//  PerfectHeadView.h
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/2.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PerfectHeadView : UIView

//从nib加载
+ (instancetype)loadView;

//定位按钮
@property (weak, nonatomic) IBOutlet UIButton *locationBtn;
//头像按钮
@property (weak, nonatomic) IBOutlet UIButton *headImgVBtn;

//图片本地路径
@property(nonatomic,copy)NSString *imgPath;

/**
 定位信息
 */
- (void)getLocationMsg;

@end
