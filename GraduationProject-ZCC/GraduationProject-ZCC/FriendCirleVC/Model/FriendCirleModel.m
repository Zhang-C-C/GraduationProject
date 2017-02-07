//
//  FriendCirleModel.m
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 17/2/7.
//  Copyright © 2017年 诺达科技. All rights reserved.
//

#import "FriendCirleModel.h"

@implementation FriendCirleModel

- (CGFloat)cellHeight
{
    if (!_cellHeight) {
        
        CGRect rect = [self.content boundingRectWithSize:CGSizeMake(kScreenWidth-20, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]} context:nil];
        
        _cellHeight = rect.size.height +120;
        self.contentHeight = rect.size.height;
        
        if (self.medias.count == 0) {
            

            
        }else{
            
            
            
        }
        
    }
    
    
    return _cellHeight;
}

@end
