//
//  FocusCell.m
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/15.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import "FocusCell.h"

@implementation FocusCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setUserName:(NSString *)userName
{
    _userName = userName;
    
    //根据用户名查询数据
    [AppTools queryWithClassName:@"_User" Key:@"username" EqualTo:_userName WithSuccess:^(NSArray *array) {
        
        NSLog(@"根据用户名查询数据:%@",array);
        for (BmobObject *obj in array) {
            
            NSString *imgName = [obj objectForKey:@"imageUrl"];
            [self.imgV sd_setImageWithURL:[NSURL URLWithString:imgName]];
            self.nickname.text = [obj objectForKey:@"nickName"];
            self.qmLabel.text = [obj objectForKey:@"qm"];
        }
        
    } WithErroe:^(NSError *error) {
       
        NSLog(@"根据用户名查询数据:%@",error);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
