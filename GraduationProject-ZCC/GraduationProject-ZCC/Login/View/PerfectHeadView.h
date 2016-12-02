//
//  PerfectHeadView.h
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/2.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PerfectHeadView : UIView

+ (instancetype)loadView;


@property (weak, nonatomic) IBOutlet UIButton *locationBtn;

@property (weak, nonatomic) IBOutlet UIButton *headImgVBtn;

@end
