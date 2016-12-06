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

/**
 性别显示

 @param note 字典
 */
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

/**
 显示
 
 @param indexPath 单元格
 */
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

//数据接收
- (void)setObj:(BmobObject *)obj
{
    _obj = obj;
    
    //昵称显示
    NSString *nickName = [obj objectForKey:@"nickName"];
    NSString *qm = [obj objectForKey:@"qm"];
    if (nickName.length >0) {
        
        self.inPutView.text = nickName;
    }
    if (qm.length >0) {
        
        self.QMTextView.text = qm;
    }
    
    //性别显示
    NSNumber *num = [obj objectForKey:@"sex"];
    if ([num integerValue] == 0) {
        
        self.sexLabel.text = @"保密";
        
    }else if ([num integerValue] == 1){
        
        self.sexLabel.text = @"男";
        
    }else if ([num integerValue] == 2){
        
        self.sexLabel.text = @"女";
    }
    //绑定信息显示
    if (self.indexPath.section == 2){
        
        if (self.indexPath.row == 0) {
            
            //手机号码
            [self showPhoneMsg];
            
        }else{
            
            NSDictionary *dic = [self.obj objectForKey:@"authData"];
            NSArray *allKeys = [dic allKeys];
            
            NSString *key = nil;
            NSString *key2 = nil;
            NSString *key3 = nil;
            
            if (allKeys.count == 1) {
                
                key = allKeys[0];
                [self showUsrMsgWith:key];
                
            }else if (allKeys.count == 2){
                
                key = allKeys[0];
                [self showUsrMsgWith:key];
                
                key2 = allKeys[1];
                [self showUsrMsgWith:key2];
                
            }else if (allKeys.count == 3){
                
                key = allKeys[0];
                [self showUsrMsgWith:key];
                
                key2 = allKeys[1];
                [self showUsrMsgWith:key2];
                
                key3 = allKeys[2];
                [self showUsrMsgWith:key3];
            }
        }
    }
}

/**
 手机绑定情况
 */
- (void)showPhoneMsg
{
    self.topLabel.text = @"手机号";
    self.imgV.image = [UIImage imageNamed:@"phone"];
    
    NSString *phone = [self.obj objectForKey:@"bindedPhone"];
    
    if (phone.length >0) {
        self.bottomLabel.hidden = NO;
        self.bottomLabel.text = phone;
        self.rightLabel.text = @"已绑定";
        self.rightLabel.textColor = REDRGB;
    }else{
        self.bottomLabel.hidden = YES;
        self.rightLabel.text = @"立即绑定";
        self.rightLabel.textColor = [UIColor whiteColor];
    }
}

/**
 根据绑定的不同信息进行显示

 @param key :类型
 */
- (void)showUsrMsgWith:(NSString *)key
{
    if ([key isEqualToString:@"qq"] && self.indexPath.row == 2) {
        
        //QQ
        [self showBindingMsgWithType:@"腾讯QQ" WithImg:@"QQ-1"];
        
    }else if ([key isEqualToString:@"weibo"] && self.indexPath.row == 3){
        
        //微博
        [self showBindingMsgWithType:@"微博" WithImg:@"sina"];
        
    }else if ([key isEqualToString:@"weixin"] && self.indexPath.row == 1){
        
        //微信
        [self showBindingMsgWithType:@"微信" WithImg:@"wechat"];
    }
}

/**
 三方绑定相关显示
 */
- (void)showBindingMsgWithType:(NSString *)type WithImg:(NSString *)imgName
{
    self.topLabel.text = type;
    self.imgV.image = [UIImage imageNamed:imgName];
    
    self.bottomLabel.hidden = NO;
    self.bottomLabel.text = [kUserDefaultDict objectForKey:knickName];
    self.rightLabel.text = @"已绑定";
    self.rightLabel.textColor = REDRGB;
}

/**
 移除通知
 */
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
