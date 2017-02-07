//
//  FriendCirleModel.h
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 17/2/7.
//  Copyright © 2017年 诺达科技. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendCirleModel : NSObject

@property(nonatomic,copy)NSString *headImgV;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *time;
//文字内容
@property(nonatomic,copy)NSString *content;

@property(nonatomic,strong)NSMutableArray *medias;

@property(nonatomic,assign)CGFloat contentHeight;
@property(nonatomic,assign)CGFloat cellHeight;

@end
