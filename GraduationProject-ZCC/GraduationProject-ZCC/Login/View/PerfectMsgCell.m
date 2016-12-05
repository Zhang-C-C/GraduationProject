//
//  PerfectMsgCell.m
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/2.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import "PerfectMsgCell.h"

@implementation PerfectMsgCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sexChangedNote:) name:@"sureBtn" object:nil];
}

- (void)sexChangedNote:(NSNotification *)note
{
    NSInteger index = [[note.userInfo objectForKey:@"row"] integerValue];
    if (index == 0) {
        
        self.sexLabel.text = @"保密";
        
    }else if (index == 1){
        
        self.sexLabel.text = @"男";
        
    }else if (index == 2){
        
       self.sexLabel.text = @"女";
    }
}

- (void)setIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    self.inPutView.hidden = YES;
    self.QMTextView.hidden = YES;
    self.leftlabel.hidden = NO;
    self.sexLabel.hidden = YES;
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            self.leftlabel.text = @"用户名";
            self.inPutView.hidden = NO;
            
        }else if (indexPath.row == 1){
            
            self.leftlabel.text = @"性别";
            self.sexLabel.hidden = NO;
        }
        
    }else if (indexPath.section == 1){
        
        //个性签名
        self.leftlabel.hidden = YES;
        self.QMTextView.hidden = NO;
        
        
    }else if (indexPath.section == 2){
        
        if (indexPath.row == 0) {
            
            self.topLabel.text = @"手机号";
            self.imgV.image = [UIImage imageNamed:@"phone"];
            
        }else if (indexPath.row == 1){
            
            self.topLabel.text = @"微信";
            self.imgV.image = [UIImage imageNamed:@"wechat"];
            
        }else if (indexPath.row == 2){
            
            self.topLabel.text = @"腾讯QQ";
            self.imgV.image = [UIImage imageNamed:@"QQ-1"];
            
        }else if (indexPath.row == 3){
            
            self.topLabel.text = @"新浪微博";
            self.imgV.image = [UIImage imageNamed:@"sina"];
        }
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
