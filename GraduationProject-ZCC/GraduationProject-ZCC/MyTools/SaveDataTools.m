//
//  SaveDataTools.m
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/5.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import "SaveDataTools.h"

@implementation SaveDataTools

+ (instancetype)sharedInstance
{
    static SaveDataTools *tools = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        tools = [[SaveDataTools alloc]init];
    });
    return tools;
}

@end
