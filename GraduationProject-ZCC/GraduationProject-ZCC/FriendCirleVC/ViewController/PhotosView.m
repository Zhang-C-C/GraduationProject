//
//  PhotosView.m
//  UI高级-03-九宫格图片
//
//  Created by wangjin on 16/7/6.
//  Copyright © 2016年 wangjin. All rights reserved.
//
#import "PhotosView.h"
#import <Photos/Photos.h>
#import "PhotosViewController.h"
#import "UIViewExt.h"

#define kSpace 10

typedef void(^PhotosBlock)(UIImage *img);

@interface PhotosView ()<PhotosViewControllerDelegate>
{
    NSMutableArray *_itemArray;//存放所有子控件
    
    NSArray *_selectedAsses;//被选中的资源
    
    NSInteger _selectIndex;//当前被选中图像的下标
}
@end

@implementation PhotosView
{
    UIButton *_addBtn;//添加按钮
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self) {
        //1.指定当前视图的frame
        self.backgroundColor = [UIColor clearColor];
        
        //2.创建添加图片的btn
        [self createBtn];
        
        //3.判断是否授权
        PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
        
        if (status == PHAuthorizationStatusRestricted||status == PHAuthorizationStatusDenied) {
            
            NSLog(@"相册访问受限");
        }
        //数组初始化
        _itemArray = [[NSMutableArray alloc] init];
    }
    return self;
}

//创建添加图片的btn
-(void)createBtn
{
    //初始化 addBtn
    _addBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, (kScreenWidth-30)/4, (kScreenWidth-30)/4)];
    
    [_addBtn setImage:[UIImage imageNamed:@"btn_add_photo_n"] forState:UIControlStateNormal];
    
    [_addBtn addTarget:self action:@selector(addBtnAction) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_addBtn];
}

-(void)addBtnAction
{
    //弹出选择器
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"选择" message:@"" preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"从手机选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //推出图片选择的视图界面
        PhotosViewController *pVC = [[PhotosViewController alloc] init];
        
        //设置代理
        pVC.delegate = self;
        
        //将上次选中的图片资源传递
        pVC.selcetPhotos = _selectedAsses;
        
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:pVC];
        
        [self.viewController presentViewController:nav animated:YES completion:nil];
        
    }];
    [alert addAction:action1];
    
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:action2];
    
    //取消按钮
    UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action3];
    
    [self.viewController presentViewController:alert animated:YES completion:nil];
}

#pragma mark ----- photosDelegate
-(void)returnSelectedPhotos:(NSArray *)photos
{
    //得到资源创建视图控件
    NSLog(@"count %lu:",(unsigned long)photos.count);
    
    //记录本次传递来的数据
    _selectedAsses = photos;
    
    //根据资源创建控件
    [self createPhotosItemWithArray:photos];
    
}
//根据资源创建控件
-(void)createPhotosItemWithArray:(NSArray *)assets
{
    //每次创建前移除之前的子控件
    if (_itemArray.count>0) {
        
        for (UIImageView *imgV in _itemArray) {
            [imgV removeFromSuperview];
        }
    }

    for (int i=0; i<assets.count; i++) {
        
        //创建item控件
        UIImageView *item = [[UIImageView alloc] initWithFrame:[self getItemFrameWithIndex:i]];
        
        //添加点击事件
//        item.userInteractionEnabled = YES;
//        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(addBtnAction)];
//        [item addGestureRecognizer:tap];
        
        [self addSubview:item];
        
        //设置image属性
        [self getImageWithAsset:assets[i] withBlock:^(UIImage *img) {
            
            item.image = img;
            
        }];
        
        //添加item到数组中
        [_itemArray addObject:item];
    }
    
    //修改btn的坐标
    _addBtn.frame = [self getItemFrameWithIndex:assets.count];
}

//根据当前下标返回frame
-(CGRect)getItemFrameWithIndex:(NSInteger)index
{
    //计算x、y轴坐标
    CGFloat x = index%4 * ((kScreenWidth-50)/4+kSpace);
    CGFloat y = index/4 * ((kScreenWidth-50)/4 + kSpace);
    
    return CGRectMake(x-5, y, (kScreenWidth-50)/4, (kScreenWidth-50)/4);
}

//根据asset获取image对象
-(void)getImageWithAsset:(PHAsset *)asset withBlock:(PhotosBlock)block
{
    //根据asset请求图片
    [[PHCachingImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(90, 90) contentMode:PHImageContentModeAspectFill options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
    
//        NSMutableArray *arr = [SaveDataTools sharedInstance].images;
//        for (NSMutableDictionary *dict in arr) {
//            
//            
//            
//        }
        
        block(result);
    }];
}

@end
