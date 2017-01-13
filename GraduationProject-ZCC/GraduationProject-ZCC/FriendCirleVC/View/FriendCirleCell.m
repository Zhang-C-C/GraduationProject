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
