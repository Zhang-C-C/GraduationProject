//
//  SettingCell.m
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/21.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import "SettingCell.h"

@implementation SettingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    
    if (_indexPath.row == 0) {
        
        self.imgV.image = [UIImage imageNamed:@"theme"];
        self.title.text = @"个性主题";
        
    }else if (_indexPath.row == 1) {
        
        self.imgV.image = [UIImage imageNamed:@"focus"];
        self.title.text = @"我的关注";
    }
}

@end
