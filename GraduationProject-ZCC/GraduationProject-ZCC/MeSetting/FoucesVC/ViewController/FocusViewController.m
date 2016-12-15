//
//  FocusViewController.m
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/13.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import "FocusViewController.h"

@interface FocusViewController ()

@end

@implementation FocusViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self initData];
}

- (void)initData
{
    //获取数据
    NSString *name = [SaveDataTools sharedInstance].focusName;
    
    if (name.length >0) {
        
        
        
    }else{
        
        [AppTools alertTextFieldWithVC:self WithSuccessBlock:^(NSDictionary *dic) {
            
            //保存数据
            BmobUser *user = [BmobUser currentUser];
            NSString *userName = dic[@"account"];
            [user setObject:userName forKey:@"loverName"];
            [user updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                
                if (!error) {
                    
                    [self showSuccessWith:@"关注成功"];
                    
                }else{
                    
                    NSLog(@"关注失败:%@",error);
                    [self showErrorWith:@"关注失败"];
                }
            }];
        } WithError:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
