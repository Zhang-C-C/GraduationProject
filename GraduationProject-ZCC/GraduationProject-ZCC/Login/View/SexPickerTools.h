//
//  SexPickerTools.h
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/5.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SexPickerTools : UIView <UIPickerViewDataSource,UIPickerViewDelegate>

+ (instancetype)loadSexPickerView;

//容器
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end
