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
        
        if (self.medias.count == 1) {
            
            _cellHeight +=200;
            
        }else if (self.medias.count > 1){
            
            if (self.medias.count <=3) {
                
                _cellHeight += 100;
                
            }else if (self.medias.count >3 &&self.medias.count <=6) {
                
                _cellHeight += 200;
                
            }else if (self.medias.count >6 &&self.medias.count <=9) {
                
                _cellHeight += 300;
            }
        }
    }
    return _cellHeight;
}

@end
