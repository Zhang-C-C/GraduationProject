//
//  SettingViewController.m
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/21.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingCell.h"
#import "SettingCollectionReusableView.h"
#import "PopoverAnimator.h"
#import "FocusViewController.h"
#import "ThemeViewController.h"
#import "PLockViewController.h"

static NSString *headIdentifier = @"headCell";
static NSString *cellIdentifier = @"cellCell";

@interface SettingViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)SettingCollectionReusableView* headerView;
@property(nonatomic,strong)PopoverAnimator *popover;

@end

@implementation SettingViewController

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    //设置导航栏的左侧按钮
    self.navigationItem.leftBarButtonItem = [UIBarButtonItem itemWithNoramlImgae:@"" SelectedImage:@"" target:self action:@selector(leftBtnAction)];
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"设置" target:self action:@selector(rightBtnAction)];

    [self.view addSubview:self.collectionView];

    [self initData];
}

- (void)initData
{
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"_User"];
    [bquery whereKey:@"username" equalTo:[BmobUser currentUser].username];
    
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        
        if (error) {
            
            [self showErrorWith:@"获取个人信息失败"];
            NSLog(@"获取个人信息失败:%@",error);
            return ;
        }
        for (BmobObject *obj in array) {
            
            //传递用于修改信息页面
            self.headerView.user = obj;

            //设置参数
            [self.headerView.nickNameBtn setTitle:[obj objectForKey:@"nickName"] forState:UIControlStateNormal];
            self.headerView.qmLabel.text = [obj objectForKey:@"qm"];
            [self.headerView.headBtn sd_setImageWithURL:[NSURL URLWithString:[obj objectForKey:@"imageUrl"]] forState:UIControlStateNormal];
        }
    }];
}

#pragma mark ---Action----
/**
 导航栏左侧按钮点击事件
 */
- (void)leftBtnAction
{
    //弹出密码验证页面
    PLockViewController *plockVC = [[PLockViewController alloc]init];
    
    [AppTools getDataFromPlistWithFileName:kTouchIDFile Success:^(NSDictionary *dic) {
        
        if ([dic[[BmobUser currentUser].username] boolValue]) {
            
            plockVC.isTouchID = YES;
        }
    }];
    
    [AppTools getDataFromPlistWithFileName:kPasswordFile Success:^(NSDictionary *dic) {
        
        if ([dic[kPasswordName] length] == 5) {
            
            plockVC.isPassword = YES;
        }
    }];
    
    if (plockVC.isTouchID || plockVC.isPassword) {
        
        [self presentViewController:plockVC animated:YES completion:nil];
    }
}

/**
 导航栏右侧按钮点击事件
 */
- (void)rightBtnAction
{
    //弹出控制器
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"PopoverViewController" bundle:nil];
    UIViewController *vc = sb.instantiateInitialViewController;
    
    //设置转场动画代理对象 ->使用懒加载避免重复创建
    vc.transitioningDelegate = self.popover;
    //设置转场的样式
    vc.modalPresentationStyle = UIModalPresentationCustom;
    vc.modalTransitionStyle = UIModalTransitionStyleCoverVertical; // 要实现自定义转场动画,不是在这里设置
    
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark ----Delegate----

#pragma amrk ----UICollectionViewDataSource----

//单元格个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return 2;
}

//单元格个数
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    SettingCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.indexPath = indexPath;
    
    return cell;
}

#pragma amrk ----UICollectionViewDelegateFlowLayout----

//点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        //我的主题
        ThemeViewController *themeVC = [[ThemeViewController alloc]init];
        [[AppDelegate sharedAppDelegate] pushViewController:themeVC WithTitle:@"个性主题"];
        
    }else if (indexPath.row == 1){
        
        //我的关注
        FocusViewController *focuesVC = [[FocusViewController alloc]init];
        [[AppDelegate sharedAppDelegate] pushViewController:focuesVC WithTitle:@"我的关注"];
    }
}

//头试图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (kind == UICollectionElementKindSectionHeader) {
        
        SettingCollectionReusableView* headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headIdentifier forIndexPath:indexPath];
        self.headerView = headerView;
        
        return headerView;
 
    }else{
        
        return nil;
    }
    return nil;
}

//设置单元格与控件边缘的距离
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

#pragma mark ----Lazy----

- (UICollectionView *)collectionView
{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
        layout.itemSize = CGSizeMake(kScreenWidth /5, kScreenWidth/5);
        //设置组头试图和组尾试图的尺寸(宽度不起作用)
        layout.headerReferenceSize =CGSizeMake(0, 150);
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) collectionViewLayout:layout];
        _collectionView.backgroundColor = [UIColor clearColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        [self.collectionView registerNib:[UINib nibWithNibName:@"SettingCell" bundle:nil] forCellWithReuseIdentifier:cellIdentifier];
        
        [self.collectionView registerNib:[UINib nibWithNibName:@"SettingCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headIdentifier];
    }
    return _collectionView;
}

/**
 *  懒加载
 *
 *  @return self
 */
- (PopoverAnimator *)popover
{
    if (!_popover) {
        _popover = [[PopoverAnimator alloc]init];
        //必须设置大小
        _popover.presentedFrame = CGRectMake(kScreenWidth-180, 56, 160, 200);
    }
    return _popover;
}

/**
 *  移除通知
 */
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
