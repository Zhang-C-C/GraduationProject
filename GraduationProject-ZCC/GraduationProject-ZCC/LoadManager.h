//
//  LoadManager.h
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/5.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoadManager : NSObject

+ (LoadManager *)sharedInstance;

@property (nonatomic,strong)UIImageView * loadingView;
@property (nonatomic,strong)UIView * blackView;
@property (nonatomic,assign)BOOL isLoading;

/**
 *  开始loading
 */
-(void)startloading;

/**
 *  停止loading
 */
-(void)stoploading;


@end
