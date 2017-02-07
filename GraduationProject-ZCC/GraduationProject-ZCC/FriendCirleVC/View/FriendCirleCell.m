//
//  FriendCirleCell.m
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 17/1/13.
//  Copyright © 2017年 诺达科技. All rights reserved.
//

#import "FriendCirleCell.h"

@implementation FriendCirleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    //self.mediaView.hidden = YES;
}

- (void)setModel:(FriendCirleModel *)model
{
    _model = model;
    
    self.name.text = _model.name;
    self.content.text = _model.content;
    self.time.text = _model.time;
    
    [self.headImgV sd_setImageWithURL:[NSURL URLWithString:_model.headImgV] placeholderImage:[UIImage imageNamed:@"headBackImgV"]];
    
    if (_model.medias.count == 0) {
        
        self.mediaView.hidden = YES;
        self.topSpace.constant = _model.contentHeight;
        
        
    }else{
        
        
    }
    
}

#pragma mark ----Override----

- (void)setFrame:(CGRect)frame
{
    frame.origin.y +=10;
    frame.size.height -=10;
    
    [super setFrame:frame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
