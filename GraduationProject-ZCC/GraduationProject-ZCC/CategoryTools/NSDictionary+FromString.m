//
//  NSDictionary+FromString.m
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/16.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import "NSDictionary+FromString.h"

@implementation NSDictionary (FromString)

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    
    if (jsonString == nil) {
        
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
    
    if(err) {
        
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}

@end
