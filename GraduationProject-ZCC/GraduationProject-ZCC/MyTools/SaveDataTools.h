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

//判断文件是否已经在沙盒中已经存在？
+ (BOOL)isFileExist:(NSString *)fileName;

//关注对象的名字
@property(nonatomic,copy)NSString *focusName;
//关注对象的头像
@property(nonatomic,copy)NSString *imgV;

@end
