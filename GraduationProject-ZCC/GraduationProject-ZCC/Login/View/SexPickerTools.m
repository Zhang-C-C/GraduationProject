//
//  SexPickerTools.m
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/5.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import "SexPickerTools.h"

@interface SexPickerTools ()

@property(nonatomic,assign)NSInteger selectedRow;

@end

@implementation SexPickerTools

+ (instancetype)loadSexPickerView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"SexPickerTools" owner:nil options:nil] lastObject];
}

#pragma mark ----Delegate----

#pragma mark ----UIPickerViewDataSource----

//有几个表盘
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

//每个表盘有几个选项
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return 3;
}

#pragma mark ----UIPickerViewDelegate----

//显示内容
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSArray *arr = @[@"保密",@"男",@"女"];
    return arr[row];
}

//自定义样式大小
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor clearColor]];
        pickerLabel.textColor = [UIColor whiteColor];
    }
    pickerLabel.text=[self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

//点击事件
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectedRow = row;
}

#pragma mark ----Action----

/**
 取消按钮点击事件
 */
- (IBAction)cancleBtnAction {
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"cancleBtn" object:nil];
}

/**
 确认按钮点击事件
 */
- (IBAction)sureBtnAction {

    [[NSNotificationCenter defaultCenter] postNotificationName:@"sureBtn" object:nil userInfo:@{@"row":@(self.selectedRow)}];
}

//移除通知
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
