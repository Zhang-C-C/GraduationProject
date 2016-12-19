//
//  CalendarView.h
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/19.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^signSuccess)(void);
typedef void(^signFailure)(void);

typedef void(^getIndexSuccess)(NSInteger row);

@interface CalendarView : UIView

/**
 开始签到

 @param indexPath 单元格
 @param date 处理的日期 2016-10-10
 @param success 成功
 @param failure 失败
 */
- (void)startSignWithCell:(NSIndexPath *)indexPath WithDate:(NSString *)date WithSuccess:(signSuccess )success WithFailure:(signFailure )failure;

@property(nonatomic,copy)getIndexSuccess getRow;

- (void)setGetRow:(getIndexSuccess)getRow;

- (instancetype)initWithFrame:(CGRect)frame WithSignDays:(NSMutableArray *)signArray;

@property(nonatomic,assign)NSInteger index;

@end
