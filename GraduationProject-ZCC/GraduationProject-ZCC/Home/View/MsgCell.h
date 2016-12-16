//
//  MsgCell.h
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/15.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MsgModel.h"

@interface MsgCell : UITableViewCell

@property(nonatomic,strong)MsgModel *model;

//头像
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
//昵称
@property (weak, nonatomic) IBOutlet UILabel *nickName;
//内容
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
//日期
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
//定位信息
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
//时间
@property (weak, nonatomic) IBOutlet UILabel *detailTime;
// <<< 和>>> 切换
@property (weak, nonatomic) IBOutlet UILabel *moreLabel;

@end
