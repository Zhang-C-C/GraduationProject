//
//  WebViewController.h
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 17/1/13.
//  Copyright © 2017年 诺达科技. All rights reserved.
//

#import "BaseViewController.h"

typedef void(^FinishShow)(void);

@interface WebViewController : BaseViewController

//广告页面
@property(nonatomic,copy)NSString *adURL;

@property(nonatomic,copy)FinishShow finishShow;
- (void)setFinishShow:(FinishShow)finishShow;

@end
