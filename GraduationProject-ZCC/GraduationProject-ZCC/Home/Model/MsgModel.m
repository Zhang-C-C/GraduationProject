//
//  MsgModel.m
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/15.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import "MsgModel.h"

#define space 80

@implementation MsgModel

- (instancetype)initWithDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        
        self.imgV = dic[@"imgV"];
        self.name = dic[@"name"];
        self.time = dic[@"time"];
        self.msg = dic[@"msg"];
        self.talongitude = dic[@"talongitude"];
        self.talatitude = dic[@"talatitude"];
        self.mylatitude = dic[@"mylatitude"];
        self.mylongitude = dic[@"mylongitude"];
        self.isOpen = NO;
        self.locationText = @"获取信息中...";
        self.moreText = @">>>";
    }
    return self;
}

- (double)cellHeight
{
    if (!_cellHeight) {
        
        _cellHeight = space;
        
        CGRect rect = [self.msg boundingRectWithSize:CGSizeMake(300, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]} context:nil];
        
        rect.size.height <= 20 ? (_cellHeight += 20): (_cellHeight += rect.size.height);
    }
    return _cellHeight;
}

@end
