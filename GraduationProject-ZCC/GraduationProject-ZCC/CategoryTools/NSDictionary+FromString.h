//
//  NSDictionary+FromString.h
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/16.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (FromString)

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;

@end
