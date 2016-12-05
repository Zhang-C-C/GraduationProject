//
//  PerfectMsgCell.h
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/2.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PerfectMsgCell : UITableViewCell 

//==== NormalCell
//左侧文字展示
@property (weak, nonatomic) IBOutlet UILabel *leftlabel;

//右侧输入框,根据情况隐藏
@property (weak, nonatomic) IBOutlet UITextView *inPutView;

//个性签名输入View
@property (weak, nonatomic) IBOutlet UITextView *QMTextView;
//性别
@property (weak, nonatomic) IBOutlet UILabel *sexLabel;


//==== BindingCell
//头像
@property (weak, nonatomic) IBOutlet UIImageView *imgV;

@property (weak, nonatomic) IBOutlet UILabel *topLabel;

@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;

@property (weak, nonatomic) IBOutlet UILabel *rightLabel;

//===== 传递数据
@property(nonatomic,strong)NSIndexPath *indexPath;

@end
