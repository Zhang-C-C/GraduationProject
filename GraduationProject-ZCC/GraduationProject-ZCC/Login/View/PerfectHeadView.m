//
//  PerfectHeadView.m
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/2.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import "PerfectHeadView.h"

@implementation PerfectHeadView

+ (instancetype)loadView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"PerfectHeadView" owner:nil options:nil] lastObject];
}

#pragma mark ----Action----

/**
 定位按钮点击事件

 @param sender 按钮
 */
- (IBAction)locationBtnAction:(UIButton *)sender {
    
    
}

/**
 头像按钮点击事件

 @param sender 按钮
 */
- (IBAction)headBtnAction:(UIButton *)sender {
    
    
    
}



@end
