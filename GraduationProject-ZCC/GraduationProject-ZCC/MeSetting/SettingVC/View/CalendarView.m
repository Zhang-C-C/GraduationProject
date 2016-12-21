//
//  CalendarView.m
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/19.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import "CalendarView.h"

#define kScreenW [UIScreen mainScreen].bounds.size.width
#define kScreenH [UIScreen mainScreen].bounds.size.height
#define kWidth [UIScreen mainScreen].bounds.size.width
#define kHeight 44
#define kBottomH 350

static NSString *identifier = @"collectionCell";

@interface CalendarView ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

//底部视图
@property(nonatomic,strong)UIView *topView;
//日期显示
@property(nonatomic,strong)UILabel *middleLabel;
//记录日期
@property(nonatomic,strong)NSDate *date;
//集合试图
@property(nonatomic,strong)UICollectionView *collection;
//保存1-31
@property(nonatomic,strong)NSMutableArray *arr;
//保存待办
@property(nonatomic,strong)NSMutableArray *dataList;
//记录日期
@property(nonatomic,strong)NSMutableArray *dateArray;
//记录点击单元格的次数
@property(nonatomic,strong)NSIndexPath *indexPath;
//签到日期数组
@property(nonatomic,strong)NSMutableArray *signDaysArr;

@end

@implementation CalendarView

- (instancetype)initWithFrame:(CGRect)frame WithSignDays:(NSMutableArray *)signArray
{
    self = [super initWithFrame:frame];
    if (self) {
    
        self.backgroundColor = [UIColor clearColor];
        
        self.signDaysArr = [[NSMutableArray alloc]initWithArray:signArray];
        self.date = [NSDate date];
        [self initView];
        [self initData];
    }
    return self;
}

- (void)initView
{
    [self addTopView];
    
    [self addBottomView];
}

- (void)initData
{
    NSInteger total = [AppTools totalDaysThisMonth:self.date];
    self.arr = [[NSMutableArray alloc]init];
    
    //记录日期1-31
    for (int i = 1; i <= total; i++) {
        
        NSString *index = [NSString stringWithFormat:@"%d",i];
        [self.arr addObject:index];
    }
    
    //请求签到日期
    [self getSignDay];
}

- (void)getSignDay
{
    self.signDaysArr = [[NSMutableArray alloc]init];
    
    //查询数组中包含某些元素的记录
    BmobQuery *query1 = [BmobQuery queryWithClassName:@"_User"];
    NSArray *array = @[@"P1"];
    [query1 whereKey:@"signdays" notContainedIn:array];
    
    [query1 findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        if (!error) {
            
            for (BmobObject *obj in array) {
                
                if ([[obj objectForKey:@"username"] isEqualToString:[BmobUser currentUser].username]) {
                    
                    NSArray *array = [obj objectForKey:@"signDays"];
                    
                    for (NSString *str in array) {
                        
                        [self.signDaysArr addObject:str];
                        [self.collection reloadData];
                    }
                }
            }
            
        }else{
            
            [self.viewController showErrorWith:@"获取签到日期失败"];
        }
    }];
}

/**
 添加顶部view
 */
- (void)addTopView
{
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake((kScreenW-kWidth)/2, 0, kWidth, kHeight)];
    topView.backgroundColor = [UIColor clearColor];
    
    //左侧按钮
    UIButton *leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 80, kHeight)];
    [leftBtn setTitle:@"上一月" forState:UIControlStateNormal];
    [leftBtn addTarget:self action:@selector(lastMonthAction) forControlEvents:UIControlEventTouchUpInside];
    
    //右侧按钮
    UIButton *rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(topView.frame) -80 -(kScreenW -topView.frame.size.width)/2, 0, 80, kHeight)];
    [rightBtn setTitle:@"下一月" forState:UIControlStateNormal];
    [rightBtn addTarget:self action:@selector(nextMonthAction) forControlEvents:UIControlEventTouchUpInside];
    
    //中间日期显示
    UILabel *middleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 80, kHeight)];
    middleLabel.center = CGPointMake(kWidth /2, kHeight/2);
    NSString *time = [NSString stringWithFormat:@"%@",[NSDate date]];
    middleLabel.text = [time substringToIndex:7];
    middleLabel.textAlignment = NSTextAlignmentCenter;
    
    [topView addSubview:middleLabel];
    [topView addSubview:rightBtn];
    [topView addSubview:leftBtn];
    [self addSubview:topView];
    self.topView = topView;
    self.middleLabel = middleLabel;
}

/**
 添加底部view
 */
- (void)addBottomView
{
    UIView *bottomView = [[UIView alloc]initWithFrame:CGRectMake((kScreenW-kWidth)/2, CGRectGetMaxY(self.topView.frame), kWidth, kBottomH)];
    bottomView.backgroundColor = [UIColor clearColor];
    
    //添加星期
    NSArray *arr = @[@"日",@"一",@"二",@"三",@"四",@"五",@"六"];
    for (int i = 0; i < 7; i++) {
        
        UILabel *day = [[UILabel alloc]initWithFrame:CGRectMake(i*kWidth/7, 0, kWidth/7, kHeight)];
        day.text = arr[i];
        day.textAlignment = NSTextAlignmentCenter;
        day.textColor = [UIColor greenColor];
        
        [bottomView addSubview:day];
    }
    
    //添加集合试图
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(kWidth/9, kWidth/9);
    layout.minimumLineSpacing = 5;
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, kHeight, kWidth, kBottomH) collectionViewLayout:layout];
    collectionView.backgroundColor = [UIColor clearColor];
    
    collectionView.delegate = self;
    collectionView.dataSource = self;
    
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:identifier];
    
    [bottomView addSubview:collectionView];
    [self addSubview:bottomView];
    self.collection = collectionView;
}

/**
 开始签到操作

 @param indexPath 单元格
 */
- (void)startSignWithCell:(NSIndexPath *)indexPath WithDate:(NSString *)date WithSuccess:(signSuccess )success WithFailure:(signFailure )failure
{
    [self.viewController showLoadingWith:@"正在签到"];

    //数组中添加数据
    BmobObject *obj = [BmobObject objectWithoutDataWithClassName:@"_User" objectId:[BmobUser currentUser].objectId];
    
    [obj addObjectsFromArray:@[date] forKey:@"signDays"];
    
    [obj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
       
        if (!error ) {
            
            [self.viewController showSuccessWith:@"签到成功"];
            //比如 2016-12-15
            [self.dataList addObject:date];
            [self.collection reloadData];
            if (success) {
                success();
            }
            
        }else {
            
            NSLog(@"签到失败:%@",error);

            if (failure) {
                failure();
            }
        }
    }];
}

#pragma mark ---Delegate----

#pragma mark ----UICollectionViewDataSource----

//单元格个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [AppTools totalDaysThisMonth:self.date] + [AppTools firstDayInFirstWeekThisMonth:self.date];
}

//单元格内容
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    cell.userInteractionEnabled = YES;
    
    //复用问题解决
    for (UIView *subView in cell.contentView.subviews) {
        
        if ([subView isKindOfClass:[UILabel class]] ||[subView isKindOfClass:[UIButton class]]) {
            [subView removeFromSuperview];
        }
    }
    
    if (indexPath.row+1 <= [AppTools firstDayInFirstWeekThisMonth:self.date]) return cell ;
    
    //添加label显示日期
    UILabel *dayLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, cell.contentView.frame.size.width, cell.contentView.frame.size.height/2)];
    dayLabel.text = self.arr[indexPath.row-[AppTools firstDayInFirstWeekThisMonth:self.date]];
    dayLabel.textAlignment = NSTextAlignmentCenter;
    cell.backgroundColor = [UIColor clearColor];
    dayLabel.textColor = [UIColor whiteColor];

    //添加待办事宜
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(dayLabel.frame), cell.contentView.frame.size.width, cell.contentView.frame.size.height/2)];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor greenColor];
    
    [cell.contentView addSubview:label];
    [cell.contentView addSubview:dayLabel];
    
    //处理显示 ->显示今天
    NSString *today = [NSString stringWithFormat:@"%@",[NSDate date]];
    NSString *todayStr = [today substringToIndex:10];

    label.text = @"";
    
    NSInteger index = [dayLabel.text integerValue];
    NSString *time1 = [NSString stringWithFormat:@"-%02ld",index];
    NSString *cellTime = [self.middleLabel.text stringByAppendingString:time1];
    
    if ([cellTime compare:todayStr options:NSNumericSearch] == NSOrderedDescending){
        
        //单元格不可点击
        cell.userInteractionEnabled = NO;
        dayLabel.textColor = [UIColor lightGrayColor];
    
    }else if ([cellTime compare:todayStr options:NSNumericSearch] == NSOrderedSame){
        
        self.index = indexPath.row;
        
        //block回调
        if (_getRow) {
            _getRow(indexPath.row);
        }
    }
    
    //选中日期与当前日期比较
    for (NSString *time in self.dataList) {
        
        if ([time isEqualToString:cellTime]) {
            
            label.text = @"签";
        }
    }
    
    //检查服务器数据
    for (NSString *time in self.signDaysArr) {
        
        if ([time isEqualToString:cellTime]) {
            
            label.text = @"签";
        }
    }
    return cell;
}

#pragma mark ----UICollectionViewDelegateFlowLayout-----

//单元格点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger spaceCount = [AppTools firstDayInFirstWeekThisMonth:self.date];
    if (indexPath.row+1 <= spaceCount) return ;
    
    //安全判断是否已经签到
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    for (UIView *subView in cell.contentView.subviews) {
        
        if ([subView isKindOfClass:[UILabel class]]) {
            
            UILabel *label = (UILabel *)subView;
            
            if ([label.text isEqualToString:@"签"]) {
                
                [self.viewController showMsgWith:@"已签到"];
                return ;
            }
        }
    }
    //今天的日期
    NSString *today = [NSString stringWithFormat:@"%@",[NSDate date]];
    NSString *todayStr = [today substringToIndex:10];
    
    //当前点击单元格的日期
    NSString *time = [NSString stringWithFormat:@"-%02ld",indexPath.row +1 -spaceCount];
    NSString *cellTime = [NSString stringWithFormat:@"%@%@",self.middleLabel.text,time];
    
    if ([cellTime compare:todayStr options:NSNumericSearch] == NSOrderedSame){
        
        //开始签到
        [self startSignWithCell:indexPath WithDate:cellTime WithSuccess:nil WithFailure:^{
            
            [self.viewController showErrorWith:@"签到失败"];
        }];
    
    }else {
        
        //补签
        [AppTools alertViewWithTitle:@"提示" WithMsg:@"漏签了,是否补签" WithSureBtn:@"确定" WithCancleBtn:@"取消" WithVC:self.viewController WithSureBtn:^{
            
            //开始签到
            [self startSignWithCell:indexPath WithDate:cellTime WithSuccess:nil WithFailure:^{
                
                [self.viewController showErrorWith:@"签到失败"];
            }];
        } WithCancleBtn:nil];
    }
}

//四周边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 5, 5);
}

#pragma mark ---Action----

/**
 上一月点击事件
 */
- (void)lastMonthAction
{
    [self countMonthInt:-24];
}

/**
 下一月点击事件
 */
- (void)nextMonthAction
{
    [self countMonthInt:24];
}

/**
 计算月份,年份显示
 
 @param index 正负决定加减
 */
- (void)countMonthInt:(NSInteger )index
{
    NSDateComponents *components = [AppTools getDateComponentsFromDate:self.date];
    NSInteger month = components.month;
    NSInteger year = components.year;
    
    if (month == 1 ||month == 3 ||month == 5 ||month == 7 ||month == 8 ||month == 10 ||month == 12) {
        
        self.date = [self.date dateByAddingTimeInterval:31*index*3600];
        
    }else if (month == 4 ||month == 6 ||month == 9 ||month == 11){
        
        self.date = [self.date dateByAddingTimeInterval:30*index*3600];
        
    }else if (month == 2){
        
        if (year/4 == 0 && year/100 != 0) {
            //闰年
            self.date = [self.date dateByAddingTimeInterval:29*index*3600];
            
        }else{
            //平年
            self.date = [self.date dateByAddingTimeInterval:28*index*3600];
        }
    }
    //日期显示
    NSString *date = [NSString stringWithFormat:@"%@",self.date];
    self.middleLabel.text = [date substringToIndex:7];
    //重新保存天数
    [self initData];
    //刷新表
    [self.collection reloadData];
}

#pragma mark ----Lazy----

- (NSMutableArray *)dataList
{
    if (!_dataList) {
        _dataList = [[NSMutableArray alloc]init];
    }
    return _dataList;
}

- (NSMutableArray *)dateArray
{
    if (!_dateArray) {
        _dateArray = [[NSMutableArray alloc]init];
    }
    return _dateArray;
}


@end
