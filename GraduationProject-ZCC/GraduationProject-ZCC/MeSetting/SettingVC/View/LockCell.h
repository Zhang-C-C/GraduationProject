//
//  LockCell.h
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/8.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LockCell : UITableViewCell

@property(nonatomic,strong)NSIndexPath *indexPath;

@property (weak, nonatomic) IBOutlet UILabel *leftLabel;

@property (weak, nonatomic) IBOutlet UISwitch *SwitchBtn;
@property (weak, nonatomic) IBOutlet UILabel *reset;

@end
