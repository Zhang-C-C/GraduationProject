//
//  LoadManager.m
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/5.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import "LoadManager.h"

@implementation LoadManager

static  LoadManager*_instance = nil;
+ (LoadManager *)sharedInstance
{
    @synchronized(_instance)
    {
        if (_instance == nil)
        {
            _instance = [[LoadManager alloc] init];
        }
        return _instance;
    }
}

-(void)loading{
    
    _isLoading = YES;
    self.blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    self.blackView.backgroundColor = [UIColor clearColor];
    [[[UIApplication sharedApplication].delegate window] addSubview:self.blackView];
    
    UIView *black = [[UIView alloc] initWithFrame:self.blackView.frame];
    black.backgroundColor = [UIColor blackColor];
    black.alpha = 0.5;
    [self.blackView addSubview:black];
    
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeLoad)];
    [self.blackView addGestureRecognizer:tap];
    
    
    NSMutableArray *array = [[NSMutableArray alloc] initWithObjects:[UIImage imageNamed:@"load1"],[UIImage imageNamed:@"load2"],[UIImage imageNamed:@"load3"],[UIImage imageNamed:@"load4"],[UIImage imageNamed:@"load5"],[UIImage imageNamed:@"load6"],[UIImage imageNamed:@"load7"],nil];
    
    
    
    
    self.loadingView = [[UIImageView alloc] initWithFrame:CGRectMake(kScreenWidth/2 - 25, kScreenHeight/2 - 25, 50, 50)];
    self.loadingView.animationImages = array; //动画图片数组
    self.loadingView.animationDuration = 0.5; //执行一次完整动画所需的时长
    self.loadingView.animationRepeatCount = 0;  //动画重复次数 0表示无限次，默认为0
    [self.blackView addSubview:self.loadingView];
    
}


-(void)startloading{
    if (!_isLoading) {
        [self loading];
    }
    [self.loadingView startAnimating];
    
}

-(void)stoploading{
    
    [self.blackView removeFromSuperview];
    _isLoading = NO;
}

-(void)removeLoad{
    
    [self stoploading];
}


@end
