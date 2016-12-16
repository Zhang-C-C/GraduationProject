//
//  MsgCell.m
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/15.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import "MsgCell.h"

@implementation MsgCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setModel:(MsgModel *)model
{
    _model = model;

    self.locationLabel.hidden = YES;
    
    [self.imgV sd_setImageWithURL:[NSURL URLWithString:_model.imgV]];
    self.nickName.text = _model.name;
    self.timeLabel.text = [_model.time substringToIndex:11];
    self.contentLabel.text = _model.msg;
    
    _model.isOpen ?(self.locationLabel.hidden = NO):(self.locationLabel.hidden = YES);
    
    self.detailTime.text = [_model.time substringWithRange:NSMakeRange(11, 5)];

    //定位
    self.locationLabel.text = _model.locationText;
    self.moreLabel.text = _model.moreText;
}

//- (void)setFrame:(CGRect)frame{
//    
//    frame.origin.x = 10;
//    
//    //frame.size.width -= 2* frame.origin.x;
//    
//    //设置上下间距
//    frame.size.height -=1;
//    
//    //继承父类
//    [super setFrame:frame];
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
