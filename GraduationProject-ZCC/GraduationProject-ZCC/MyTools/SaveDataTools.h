//
//  SaveDataTools.h
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/5.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SaveDataTools : NSObject

+ (instancetype)sharedInstance;

@property(nonatomic,copy)NSString *nickName;
@property(nonatomic,copy)NSString *qmString;
@property(nonatomic,strong)NSNumber *sex;
@property(nonatomic,copy)NSString *imgPath;
@property(nonatomic,copy)NSString *phoneNum;

@end
