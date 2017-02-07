//
//  SignViewController.m
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/19.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import "SignViewController.h"

#import "CalendarView.h"

static NSString *identifier = @"cell";

@interface SignViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIView *tableHeadView;
@property(nonatomic,strong)UIImageView *headImgV;
@property(nonatomic,strong)CalendarView *calendarView;
@property(nonatomic,strong)UIButton *signBtn;
@property(nonatomic,strong)UILabel *signLabel;
//签到日期数组
@property(nonatomic,strong)NSMutableArray *signDaysArr;

@end

@implementation SignViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initView];
    [self getSignDay];
}

- (void)initView
{
    [self.tableHeadView addSubview:self.signBtn];
    [self.tableHeadView addSubview:self.signLabel];
    //添加表视图头试图
    self.tableView.tableHeaderView = self.tableHeadView;
}

- (void)getSignDay
{
    //[self showLoadingWith:@"正在同步信息"];
    
    self.signDaysArr = [[NSMutableArray alloc]init];
    
    //查询数组中包含某些元素的记录
    BmobQuery *query1 = [BmobQuery queryWithClassName:@"_User"];
    NSArray *array = @[@"P1"];
    [query1 whereKey:@"signdays" notContainedIn:array];
    
    [query1 findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        if (!error) {
            
            //[self showSuccessWith:@"同步完成"];
            
            for (BmobObject *obj in array) {
                
                if ([[obj objectForKey:@"username"] isEqualToString:[BmobUser currentUser].username]) {
                    
                    NSArray *array = [obj objectForKey:@"signDays"];
                    
                    for (NSString *str in array) {
                        
                        [self.signDaysArr addObject:str];
                        [self judgeTodayisSign];
                    }
                }
            }
            
        }else{
            
            [self showErrorWith:@"获取签到日期失败"];
        }
    }];
}

- (void)judgeTodayisSign
{
    NSString *today = [[NSString stringWithFormat:@"%@",[NSDate date]] substringToIndex:10];
    for (NSString *day in self.signDaysArr) {
        
        if ([day isEqualToString:today]) {
            
            self.signBtn.selected = YES;
            [self.signBtn setTitle:@"已签到" forState:UIControlStateSelected];
        }
    }
}

#pragma mark ----Action----

/**
 立即签到按钮点击事件

 @param btn 按钮
 */
- (void)signBtnAction:(UIButton *)btn
{
    //查询当前日期是第几个单元格
    if (!btn.selected) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathWithIndex:self.calendarView.index];
        
        NSString *time = [[NSString stringWithFormat:@"%@",[NSDate date]] substringToIndex:10];
        [self.calendarView startSignWithCell:indexPath WithDate:time WithSuccess:^{
            
            btn.selected = !btn.selected;
            [btn setTitle:@"已签到" forState:UIControlStateSelected];
            
        } WithFailure:^{
            
            [self showErrorWith:@"签到失败,请重试"];
        }];
        
    }else{
        
        [self showMsgWith:@"已签到"];
    }
}

#pragma mark ----Delegate----

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offsetY = scrollView.contentOffset.y;    
    if (offsetY < 0) {
        
        self.headImgV.frame = CGRectMake(offsetY/2, offsetY, kScreenWidth- offsetY, self.tableHeadView.frame.size.height -offsetY);
    }
}

#pragma mark ----UITableViewDataSource----

//单元格个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

//单元格内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.backgroundColor = [UIColor clearColor];
    }
    if (indexPath.row == 0) {
        
        //添加日历
        [cell.contentView addSubview:self.calendarView];
    }
    return cell;
}

#pragma mark ----UITableViewDelegate----

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        return 450;
    }
    return 0;
}

//单元格点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark----Lazy----

- (UITableView *)tableView
{
    if (!_tableView) {
        //添加表视图
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor clearColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [self.view addSubview:_tableView];
    }
    return _tableView;
}

- (UIView *)tableHeadView
{
    if (!_tableHeadView) {
        _tableHeadView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight *0.2)];
        UIImageView *imgV = [[UIImageView alloc]initWithFrame:_tableHeadView.bounds];
        imgV.image = [UIImage imageNamed:@"headBackImgV.jpg"];
        imgV.alpha = 0.5;
        self.headImgV = imgV;
        
        [_tableHeadView addSubview:imgV];
    }
    return _tableHeadView;
}

- (CalendarView *)calendarView
{
    if (!_calendarView) {
        _calendarView = [[CalendarView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 450) WithSignDays:self.signDaysArr];
    }
    return _calendarView;
}

- (UIButton *)signBtn
{
    if (!_signBtn) {
        CGFloat width = 100;
        _signBtn = [[UIButton alloc]initWithFrame:CGRectMake((kScreenWidth-width)/2, self.tableHeadView.frame.size.height/2 -20, width, kBtnHeight)];
        [_signBtn setTitle:@"立即签到" forState:UIControlStateNormal];
        [_signBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        _signBtn.layer.cornerRadius = 10;
        _signBtn.backgroundColor = [UIColor orangeColor];
        
        [_signBtn addTarget:self action:@selector(signBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _signBtn;
}

- (UILabel *)signLabel
{
    if (!_signLabel) {
        CGFloat width = 250;
        _signLabel = [[UILabel alloc]initWithFrame:CGRectMake((kScreenWidth -width)/2, CGRectGetMaxY(self.signBtn.frame), width, kBtnHeight)];
        _signLabel.text = @"今日已有124367人签到";
        _signLabel.font = [UIFont systemFontOfSize:14.0];
        _signLabel.textAlignment = NSTextAlignmentCenter;
        _signLabel.textColor = [UIColor blackColor];
    }
    return _signLabel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
