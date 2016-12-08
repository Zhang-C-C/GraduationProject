//
//  MeHeadView.m
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/5.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import "MeHeadView.h"
#import "PerfectViewController.h"

@implementation MeHeadView

+ (instancetype)loadView
{
    return [[[NSBundle mainBundle]loadNibNamed:@"MeHeadView" owner:nil options:nil] lastObject];
}

- (void)showUserMsgWithSucBlock:(SucBlock )success WithFali:(falBlock )failBlock
{
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"_User"];
    [bquery whereKey:@"username" equalTo:[BmobUser currentUser].username];
    
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
       
        if (error) {
            
            if (failBlock) {
                failBlock(error);
            }
            return ;
        }
        if (success) {
            success();
        }
        
        if (![array isKindOfClass:[NSNull class]]) {
            
            for (BmobObject *obj in array) {
                
                self.user = obj;
                
                //安全判断
                if (![[obj objectForKey:@"nickName"] isKindOfClass:[NSNull class]]) {
                    
                    self.nickName.text = [obj objectForKey:@"nickName"];
                }
                
                self.qmLabel.text = [obj objectForKey:@"qm"];
                [self.headBtn sd_setImageWithURL:[NSURL URLWithString:[obj objectForKey:@"imageUrl"]] forState:UIControlStateNormal];
            }
        }        
    }];
}

#pragma mark ----Action----

/**
 点击时跳转
 */
- (IBAction)hiddenBtnAction {
    
    //跳转到完善信息页面
    PerfectViewController *perfectVC = [[PerfectViewController alloc]init];
    perfectVC.isLogin = YES;
    perfectVC.user = self.user;
    
    [[AppDelegate sharedAppDelegate] pushViewController:perfectVC WithTitle:@"修改信息"];
}

/**
 头像点击事件
 */
- (IBAction)headBtnAction {
    
    
}

@end
