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

//原始数据(服务器存储的),用于删除消息中心
@property(nonatomic,copy)NSString *originalStr;

//头像
@property(nonatomic,copy)NSString *imgV;
//消息体
@property(nonatomic,copy)NSString *msg;
//昵称
@property(nonatomic,copy)NSString *name;
//时间
@property(nonatomic,copy)NSString *time;

//是否点击单元格
@property(nonatomic,assign)BOOL isOpen;
//定位信息文本内容
@property(nonatomic,copy)NSString *locationText;
// <<<和>>>
@property(nonatomic,copy)NSString *moreText;

//关注人的经纬度
@property(nonatomic,copy)NSString *talatitude;
@property(nonatomic,copy)NSString *talongitude;

//用于计算单元格的高度
@property(nonatomic,assign)double cellHeight;

@end
