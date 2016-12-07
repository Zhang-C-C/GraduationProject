//
//  ThemeCell.h
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/7.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThemeModel.h"

@interface ThemeCell : UICollectionViewCell

@property(nonatomic,strong)ThemeModel *model;

@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *label;

@end
