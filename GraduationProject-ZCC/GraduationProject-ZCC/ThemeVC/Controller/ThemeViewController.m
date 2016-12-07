//
//  ThemeViewController.m
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/7.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import "ThemeViewController.h"
#import "ThemeCell.h"
#import "ThemeModel.h"
#import "HCDataHelper.h"

@interface ThemeViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property(nonatomic,strong)NSMutableArray *dataList;

@property(nonatomic,strong)UICollectionView *collectionView;

@property(nonatomic,assign)BOOL isOk;

@end

@implementation ThemeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    [self initData];
}

- (void)initView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    
    layout.itemSize = CGSizeMake(kScreenWidth *0.3, 1.4* kScreenWidth *0.3);
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 10;
    layout.scrollDirection = UICollectionViewScrollDirectionVertical;
    layout.headerReferenceSize =CGSizeMake(0, 40);
    
    UICollectionView *collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight) collectionViewLayout:layout];
    
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    
    [collectionView registerNib:[UINib nibWithNibName:@"ThemeCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"Xib_cell"];
    [collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"class_header"];
    
    self.collectionView = collectionView;
    [self.view addSubview:collectionView];
    
    //添加下拉刷新
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       
        [self initData];
    }];
}

- (void)initData
{
    self.dataList = [[NSMutableArray alloc]init];
    //获取服务器的图片
    BmobQuery *bquery = [BmobQuery queryWithClassName:@"theme"];
    [bquery findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
       
        if (!error) {
            
            [self.collectionView.mj_header endRefreshing];
            
            for (BmobObject *obj in array) {
                
                ThemeModel *model = [[ThemeModel alloc]init];
                model.url = [obj objectForKey:@"url"];
                model.name = [obj objectForKey:@"name"];
                model.isSelected = [obj objectForKey:@"isSelected"];
                
                [self.dataList addObject:model];
                [self.collectionView reloadData];
            }
        }
    }];
}

/**
 设置背景图片
 */
- (void)setUpBackImgWithCell:(ThemeCell *)cell WithModel:(ThemeModel *)model
{
    cell.label.text = @"下载完成";
    NSString *name = [NSString stringWithFormat:@"%@.png",model.name];
    
    [AppTools alertViewWithTitle:@"下载完成" WithMsg:@"立即使用?" WithSureBtn:@"确定" WithCancleBtn:@"再看看" WithVC:self WithSureBtn:^{
        
        [self showLoadingWith:@"正在保存"];

        [AppTools queryWithClassName:@"theme" Key:@"name" EqualTo:model.name WithSuccess:^(NSArray *array) {
            
            for (BmobObject *obj in array) {
                
                //更新数据
                [obj setObject:name forKey:@"isSelected"];
                [obj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    
                    if (isSuccessful) {
                        
                        [self showSuccessWith:@"保存信息到服务器成功"];
                    
                    }else{
                        
                        [self showErrorWith:@"保存信息到服务器失败"];
                    }
                    //发送通知,保存到偏好设置
                    [kUserDefaultDict setObject:name forKey:kTheme];
                    [kUserDefaultDict synchronize];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:kThemeChange object:nil userInfo:@{@"name":name}];
                    
                    //刷新集合石图
                    model.isSelected = name;
                    [self.collectionView reloadData];
                }];
            }
            
        } WithErroe:^(NSError *error) {
           
            [self showErrorWith:@"网络出错,请重试!"];
        }];
        
    } WithCancleBtn:nil];
}

#pragma mark ----Deleagte----

#pragma mark ----UICollectionViewDataSource----

//单元格个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataList.count;
}

//单元格内容
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //创建
    ThemeCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Xib_cell" forIndexPath:indexPath] ;
    cell.model = self.dataList[indexPath.row];
    
    return cell;
}

#pragma mark ----UICollectionViewDelegateFlowLayout----

//点击事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //下载对应的图片到沙河路径
    ThemeModel *model = self.dataList[indexPath.row];
    ThemeCell *cell = (ThemeCell *)[collectionView cellForItemAtIndexPath:indexPath];

    //安全检查是否已经下载
    if ([SaveDataTools isFileExist:[NSString stringWithFormat:@"%@.png",model.name]]) {
        
        [self setUpBackImgWithCell:cell WithModel:model];
        return ;
    }
    cell.label.text = @"正在下载...";
    
    //下载到本地
    NSData *imgData = [NSData dataWithContentsOfURL:[NSURL URLWithString:model.url]];
    UIImage *image = [UIImage imageWithData:imgData];
    NSData *data = UIImagePNGRepresentation(image);
    
    NSString *caches = [HCDataHelper libCachePath];
    NSString *path = [caches stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.png",model.name]];
    
    BOOL isOk = [data writeToFile:path atomically:YES];
    if (isOk) {
        
        [self setUpBackImgWithCell:cell WithModel:model];
        
    }else{
        
        [self showErrorWith:@"图片下载失败,请重试"];
    }
}

//设置单元格与控件边缘的距离
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

//设置组头试图和组尾试图的试图(需要先注册头试图和尾试图)
-(UICollectionReusableView*)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    //viewForSupplementaryElementOfKind  种类:头试图/尾试图
    if (kind == UICollectionElementKindSectionHeader) {
        
        UICollectionReusableView* headerView =[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"class_header" forIndexPath:indexPath];
        
        headerView.backgroundColor =[UIColor clearColor];
        
        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth, headerView.frame.size.height)];
        title.text = @"主题选择";
        title.textColor = [UIColor whiteColor];
        [headerView addSubview:title];
        
        return headerView;
    }
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
