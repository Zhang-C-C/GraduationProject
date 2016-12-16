//
//  MsgModel.h
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/15.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MsgModel : NSObject

- (instancetype)initWithDic:(NSDictionary *)dic;
//原始数据,用户删除
@property(nonatomic,copy)NSString *originalStr;

@property(nonatomic,copy)NSString *imgV;
@property(nonatomic,copy)NSString *msg;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *time;

//是否点击单元格
@property(nonatomic,assign)BOOL isOpen;
@property(nonatomic,copy)NSString *locationText;
@property(nonatomic,copy)NSString *moreText;

@property(nonatomic,copy)NSString *talatitude;
@property(nonatomic,copy)NSString *talongitude;
@property(nonatomic,copy)NSString *mylatitude;
@property(nonatomic,copy)NSString *mylongitude;

@property(nonatomic,assign)double cellHeight;

@end
