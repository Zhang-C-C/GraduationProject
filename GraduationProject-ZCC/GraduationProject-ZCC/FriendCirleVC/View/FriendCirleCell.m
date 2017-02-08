//
//  FriendCirleCell.m
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 17/1/13.
//  Copyright © 2017年 诺达科技. All rights reserved.
//

#import "FriendCirleCell.h"

@interface FriendCirleCell ()

@property(nonatomic,strong)UIImageView *imgV;

@end

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
        
        self.imgV.hidden = YES;
        self.mediaView.hidden = YES;
        self.topSpace.constant = _model.contentHeight;
        
    }else if(_model.medias.count == 1){
        
        self.mediaView.hidden = NO;
        self.topSpace.constant = 210;
        
        self.imgV.hidden = NO;
        NSString *img = _model.medias[0];
        [self.imgV sd_setImageWithURL:[NSURL URLWithString:img] placeholderImage:[UIImage imageNamed:@""]];
        [self.mediaView addSubview:self.imgV];
        
    }else{
        
        self.mediaView.hidden = NO;
        self.topSpace.constant = 190;
        
        self.imgV.hidden = YES;
        
        //创建数组
        
        
        
        
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

#pragma mark ----Lazy----

- (UIImageView *)imgV
{
    if (!_imgV) {
        _imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200,200)];
        
    }
    return _imgV;
}


@end
