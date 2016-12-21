//
//  SettingCollectionReusableView.h
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/21.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingCollectionReusableView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIButton *headBtn;//头像
@property (weak, nonatomic) IBOutlet UIButton *signBtn;//签到
@property (weak, nonatomic) IBOutlet UILabel *qmLabel;//签名
@property (weak, nonatomic) IBOutlet UIButton *nickNameBtn;//昵称

@property(nonatomic,strong)BmobObject *user;//保存的用户信息,用于完善信息页面

@end
