//
//  FriendCirleCell.h
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 17/1/13.
//  Copyright © 2017年 诺达科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FriendCirleModel.h"

@interface FriendCirleCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *mediaView;

@property(nonatomic,strong)FriendCirleModel *model;
@property (weak, nonatomic) IBOutlet UIImageView *headImgV;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *content;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topSpace;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *mediaHeight;

//点赞
@property (weak, nonatomic) IBOutlet UIButton *zan;

@end
