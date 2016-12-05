//
//  PerfectViewController.h
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/2.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import "BaseViewController.h"

@interface PerfectViewController : BaseViewController

//安全判断,用于隐藏绑定信息 默认值为0 
@property(nonatomic,assign)BOOL isLogin;

@property(nonatomic,copy)NSString *account;
@property(nonatomic,copy)NSString *password;

@end
