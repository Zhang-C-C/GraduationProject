//
//  FocusCell.h
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/15.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FocusCell : UITableViewCell

@property(nonatomic,copy)NSString *userName;

@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *nickname;
@property (weak, nonatomic) IBOutlet UILabel *qmLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancleBtn;

@end
