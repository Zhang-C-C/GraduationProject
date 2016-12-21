//
//  SettingCollectionReusableView.m
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/21.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import "SettingCollectionReusableView.h"
#import "SignViewController.h"
#import "PerfectViewController.h"

@implementation SettingCollectionReusableView

- (void)awakeFromNib {
    [super awakeFromNib];
}


- (IBAction)headBtnAction {
    
    //跳转到完善信息页面
    PerfectViewController *perfectVC = [[PerfectViewController alloc]init];
    perfectVC.isLogin = YES;
    perfectVC.user = self.user;
    
    [[AppDelegate sharedAppDelegate] pushViewController:perfectVC WithTitle:@"修改信息"];
}

- (IBAction)signBtnAction:(UIButton *)sender {
    
    //我的签到
    SignViewController *signVC = [[SignViewController alloc]init];
    [[AppDelegate sharedAppDelegate] pushViewController:signVC WithTitle:@"签到"];
}

- (IBAction)nickNameBtnAction {
    
    //跳转到完善信息页面
    PerfectViewController *perfectVC = [[PerfectViewController alloc]init];
    perfectVC.isLogin = YES;
    perfectVC.user = self.user;
    
    [[AppDelegate sharedAppDelegate] pushViewController:perfectVC WithTitle:@"修改信息"];
}

@end
