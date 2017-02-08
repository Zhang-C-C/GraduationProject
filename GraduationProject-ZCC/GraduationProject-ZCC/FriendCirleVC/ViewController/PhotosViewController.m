//
//  PhotosViewController.m
//  UI高级-03-九宫格图片
//
//  Created by wangjin on 16/7/6.
//  Copyright © 2016年 wangjin. All rights reserved.
//

#import "PhotosViewController.h"
#import <Photos/Photos.h>
typedef void(^Myblock)(UIImage *img);

@interface PhotosViewController ()<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>
{
    UICollectionView *_collectionView;
    NSMutableArray *_dataList;
    
    NSMutableArray *_selcetPhotos;//被选中的图像
}
@end

@implementation PhotosViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //1.添加导航项
    [self addNavigationItem];
    
    self.title = @"相册";
    
    //2.获取所有图片资源
    [self getAllPhotos];
    
    //3.创建collectionView 显示图片
    [self createCollectionView];

    //初始化选中图片数组
    if (!_selcetPhotos) {
        _selcetPhotos = [[NSMutableArray alloc] init];
    }
}


//添加导航项左右两侧按钮
-(void)addNavigationItem
{
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(leftBtnAct)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(rightBtnAct)];
}

//导航项按钮方法
-(void)leftBtnAct
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)rightBtnAct
{
    //将选中数据传回到前页面
    [self.delegate returnSelectedPhotos:_selcetPhotos];
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma  mark ------ UICollectionView
-(void)createCollectionView
{
    //布局类
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat itemW = (self.view.bounds.size.width-30)/4;
    layout.itemSize = CGSizeMake(itemW, itemW);
    
    _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:layout];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    //注册单元格
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:_collectionView];
}

#pragma mark ---- 获取图片资源
-(void)getAllPhotos
{
    //初始化数据源数组
    _dataList = [[NSMutableArray alloc] init];
    
    //创建查询option
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
    //查询后所有图片资源
    PHFetchResult *results = [PHAsset fetchAssetsWithOptions:option];
    
    //遍历资源集合 将所有资源添加到数据源数组
    for (PHAsset *asset in results) {
        
        [_dataList addObject:asset];
    }
}

#pragma mark ----- UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataList.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    //判断当前单元格是否存在imgV控件
    if (![cell.contentView viewWithTag:101]) {
        //创建imgV
        UIImageView *imgV = [[UIImageView alloc] initWithFrame:cell.contentView.bounds];
        imgV.tag = 101;
        [cell.contentView addSubview:imgV];

        //选中图片视图
        UIImageView *selectV =[[UIImageView alloc] initWithFrame:CGRectMake(cell.contentView.frame.size.width-18, 0, 18, 18)];
        selectV.tag = 102;
        selectV.image = [UIImage imageNamed:@"checkmark"];
        
        //默认隐藏
        selectV.hidden = YES;
        [cell.contentView addSubview:selectV];
    }
    
    //获取资源图片 并且设置给imgV控件
    [self getImageWithAsset:_dataList[indexPath.row] withBlock:^(UIImage *img) {
        
        UIImageView *imgV = [cell.contentView viewWithTag:101];
        
        imgV.image = img;
    }];
    
    //显示已选中的图片
    UIImageView *selectImgV = [cell.contentView viewWithTag:102];
    
    //将上次选中过的图片显示选中效果
    if ([_selcetPhotos containsObject:_dataList[indexPath.row]]) {
        //上次被选中的图片 则本次也显示被选中
        selectImgV.hidden = NO;
    }
    else
    {
        selectImgV.hidden = YES;
    }
    return cell;
}

//获取资源图片
-(void)getImageWithAsset:(PHAsset *)asset withBlock:(Myblock)block
{
    [[PHCachingImageManager defaultManager] requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
 
        block(result);
    }];
}

//单元格点击方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    //获取被点击的单元格
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
    
    //获取图标控件
    UIImageView *checkImgV = [cell.contentView viewWithTag:102];
    
    //判断当前数组中个数是否已满9个，若已满则不允许添加
    if (_selcetPhotos.count>=9 && checkImgV.hidden == YES) {
        
        NSLog(@"目前数组中个数已到最大值，不允许添加");
        [self showMsgWith:@"目前数组中个数已到最大值，不允许添加"];
        return;
    }
    
    //隐藏属性取反
    checkImgV.hidden = !checkImgV.hidden;
    
    //添加图像
    if (checkImgV.hidden == NO) {
        //当前为选中状态添加到数组中
        [_selcetPhotos addObject:_dataList[indexPath.row]];
    }
    else
    {
        //取消选中则从数组中移除
        [_selcetPhotos removeObject:_dataList[indexPath.row]];
    }
}

@end
