//
//  PerfectViewController.m
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/2.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

//完善信息的控制器
#import "PerfectViewController.h"
#import "PerfectHeadView.h"
#import "PerfectMsgCell.h"
#import "SexPickerTools.h"

static NSString *identifier = @"perfectMsgCell";

@interface PerfectViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>

@property(nonatomic,strong)UITableView *tableView;

//蒙版
@property(nonatomic,strong)UIView *blacView;

//性别选择器
@property(nonatomic,strong)SexPickerTools *tools;

//记录单元格高度
//@property(nonatomic,assign)CGFloat QMCellHeight;

@property(nonatomic,copy)NSString *userName;
@property(nonatomic,copy)NSString *QMString;
@property(nonatomic,copy)NSString *sex;

@end

@implementation PerfectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tapAction) name:@"cancleBtn" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(sureBtnAction:) name:@"sureBtn" object:nil];
    [self initView];
}

- (void)initView
{
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) style:UITableViewStyleGrouped];
    
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    tableView.backgroundColor = [UIColor clearColor];
    //设置表视图头试图
    tableView.tableHeaderView = [PerfectHeadView loadView];
    
    [tableView registerClass:[PerfectMsgCell class] forCellReuseIdentifier:identifier];
    
    self.tableView = tableView;
    [self.view addSubview:tableView];
    
    //设置导航栏右侧按钮
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithSize:CGSizeMake(50, 50) Title:@"跳过" target:self action:@selector(skipAction)];
    
    //添加完成按钮
    [self addFinishBtn];
}

//保存密码,并跳转到首页
- (void)skipToRootVC
{
    //保存用户名密码
    [kUserDefaultDict setObject:self.account forKey:kUserName];
    [kUserDefaultDict setObject:self.password forKey:kPassword];
    //重新设置跟试图控制器
    kRootViewController = [[MainViewController alloc]init];
}

//添加完成按钮
- (void)addFinishBtn
{
    CGFloat btnX = (kScreenWidth - kBtnWidth)*0.5;
    CGFloat btnY = kScreenHeight -kBtnHeight- 100;
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(btnX, btnY, kBtnWidth, kBtnHeight)];
    btn.layer.cornerRadius = 5;
    [btn setBackgroundColor:REDRGB];
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(finishBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self.tableView addSubview:btn];
}

#pragma mark ----Action----

/**
 完成按钮点击事件
 */
- (void)finishBtnAction
{
    NSLog(@"昵称:%@,性别:%@,签名:%@",self.userName,self.sex,self.QMString);
    
    
}

/**
 性别选择按钮点击事件

 @param note 通知
 */
- (void)sureBtnAction:(NSNotification *)note
{
    [self tapAction];
    NSDictionary *dic = note.userInfo;
    NSLog(@"当前选中的为:%@",dic[@"row"]);
    //赋值保存
    self.sex = [NSString stringWithFormat:@"%ld",[dic[@"row"] integerValue]];
}

/**
 跳过按钮
 */
- (void)skipAction
{
    [self skipToRootVC];
}

//性别选择器
- (void)sexPickView
{
    [self.view addSubview:self.blacView];
    
    SexPickerTools *tools = [SexPickerTools loadSexPickerView];
    [self.view addSubview:tools];
    self.tools = tools;
    tools.transform = CGAffineTransformMakeTranslation(0, kScreenHeight +230);
    [UIView animateWithDuration:.5 animations:^{
        
        tools.transform = CGAffineTransformMakeTranslation(0, kScreenHeight -230);
    }];
}

#pragma mark ----Delegate----

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark ----UITableViewDataSource----

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

//单元格个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        
        return 2;
    
    }else if (section == 1){
        
        return 1;
    }else{
        
        return 4;
    }
    return 0;
}

//单元格内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        
        PerfectMsgCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"PerfectMsgCell" owner:nil options:nil] lastObject];
        cell.indexPath = indexPath;
        
        return cell;
    }
    
    PerfectMsgCell *cell = [[[NSBundle mainBundle]loadNibNamed:@"PerfectMsgCell" owner:nil options:nil] firstObject];
    cell.indexPath = indexPath;
    //设置代理对象
    cell.inPutView.delegate = self;
    cell.QMTextView.delegate = self;
    
    return cell;
}

#pragma mark ----UITableViewDelegate----

//单元格点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:YES];
    if (indexPath.section == 0 && indexPath.row == 1) {
        
        //弹出性别选择器
        [self sexPickView];
    }
}

//单元格高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 && indexPath.row == 0){
        
        //指定行的高度变化
        //self.QMCellHeight > 49?(self.QMCellHeight = self.QMCellHeight):(self.QMCellHeight = 49);
        //return self.QMCellHeight;
        return 60;
    }
    return 49;
}

//尾试图高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 30;
}

//头试图高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}

//尾试图的文字
- (NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        
        return @"签名";
    }else if (section == 1){
        
        return @"账号绑定";
    }
    return @"";
}

/**
 获取指定的单元格

 @param row 行
 @param section 组
 @return 单元格
 */
- (PerfectMsgCell *)getSelectedCellWithRow:(NSInteger )row WithSection:(NSInteger )section
{
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
    PerfectMsgCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    return cell;
}

#pragma mark ----UITextViewDelegate-----

//将要开始编辑时
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    PerfectMsgCell *nameCell = [self getSelectedCellWithRow:0 WithSection:0];
    PerfectMsgCell *QMCell = [self getSelectedCellWithRow:0 WithSection:1];
    
    if (textView == nameCell.inPutView) {
        
        if ([textView.text isEqualToString:@"请输入用户名"]) {
            
            textView.text = nil;
        }
        
    }else if (textView == QMCell.QMTextView){
        
        if ([textView.text isEqualToString:@"请输入您的个性签名"]) {
            
            textView.text = nil;
        }
    }
    return YES;
}

//结束编辑时调用
- (void)textViewDidEndEditing:(UITextView *)textView
{
    PerfectMsgCell *nameCell = [self getSelectedCellWithRow:0 WithSection:0];
    PerfectMsgCell *QMCell = [self getSelectedCellWithRow:0 WithSection:1];
    
    if (textView == nameCell.inPutView) {
        
        if ([textView.text isEqualToString:@""]) {
            
            textView.text = @"请输入用户名";
        
        }else{
            
            self.userName = textView.text;
        }
        
    }else if (textView == QMCell.QMTextView){
        
        if ([textView.text isEqualToString:@""]) {
            
            textView.text = @"请输入您的个性签名";
            
        }else{
            
            //保存用户输入
            self.QMString = textView.text;
            
            //CGRect rect = [textView.text boundingRectWithSize:CGSizeMake(280, 999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0]} context:nil];
            
            //self.QMCellHeight = rect.size.height;
            //刷新指定的一行数据
            //NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
            //[self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}

#pragma mark ----Lazy----

- (UIView *)blacView
{
    if (!_blacView) {
        _blacView = [[UIView alloc]initWithFrame:self.view.bounds];
        _blacView.backgroundColor = [UIColor grayColor];
        _blacView.alpha = 0.5;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction)];
        [_blacView addGestureRecognizer:tap];
    }
    return _blacView;
}

- (void)tapAction
{
    [self.blacView removeFromSuperview];
    
    [UIView animateWithDuration:.5 animations:^{
       
        self.tools.transform = CGAffineTransformMakeTranslation(0, kScreenHeight+230);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
