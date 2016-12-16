//
//  HomeViewController.h
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/12.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import "BaseViewController.h"

@interface HomeViewController : BaseViewController

/**
 添加大头针
 */
- (void)addAnnotationWithLatitude:(CLLocationDegrees )latitude Longitude:(CLLocationDegrees )longitude;

/**
 0-保密 1-男 2-女
 */
@property(nonatomic,assign)NSInteger sex;

//距离
@property(nonatomic,assign)double distance;

@end
