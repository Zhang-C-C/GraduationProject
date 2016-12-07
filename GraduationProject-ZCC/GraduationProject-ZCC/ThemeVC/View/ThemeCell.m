//
//  ThemeCell.m
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/7.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import "ThemeCell.h"

@implementation ThemeCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setModel:(ThemeModel *)model
{
    _model = model;
    
    [self.imgV sd_setImageWithURL:[NSURL URLWithString:_model.url] placeholderImage:[UIImage imageNamed:@"placeholderImg"]];
    
    if ([_model.isSelected isEqualToString:[kUserDefaultDict objectForKey:kTheme]]) {
        
        self.label.text = @"正在使用";
        self.label.backgroundColor = [UIColor cyanColor];
    
    }else{
        
        self.label.text = @"立即使用";
        self.label.backgroundColor = [UIColor lightGrayColor];
    }
}

@end
