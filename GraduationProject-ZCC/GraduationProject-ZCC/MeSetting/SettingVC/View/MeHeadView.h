//
//  MeHeadView.h
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/5.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SucBlock)(void);
typedef void(^falBlock)(NSError *error);

@interface MeHeadView : UIView

+ (instancetype)loadView;

/**
 加载用户信息
 */
- (void)showUserMsgWithSucBlock:(SucBlock )success WithFali:(falBlock )failBlock;

//头像
@property (weak, nonatomic) IBOutlet UIButton *headBtn;
//昵称
@property (weak, nonatomic) IBOutlet UILabel *nickName;
//资料完善度
@property (weak, nonatomic) IBOutlet UILabel *perfectNumLabel;
//显示签名
@property (weak, nonatomic) IBOutlet UILabel *qmLabel;

@property(nonatomic,strong)BmobObject *user;

@end
