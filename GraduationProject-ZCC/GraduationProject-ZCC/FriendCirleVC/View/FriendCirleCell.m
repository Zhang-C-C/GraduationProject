//
//  FriendCirleCell.m
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 17/1/13.
//  Copyright © 2017年 诺达科技. All rights reserved.
//

#import "FriendCirleCell.h"
#import "SDPhotoBrowser.h"

@interface FriendCirleCell ()<SDPhotoBrowserDelegate>

@property(nonatomic,strong)UIImageView *imgV;

@property(nonatomic,strong)NSMutableArray *arr;

@end

@implementation FriendCirleCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setModel:(FriendCirleModel *)model
{
    _model = model;
    
    self.name.text = _model.name;
    self.content.text = _model.content;
    self.time.text = _model.time;
    
    [self.headImgV sd_setImageWithURL:[NSURL URLWithString:_model.headImgV] placeholderImage:[UIImage imageNamed:@"headBackImgV"]];
    
    //点赞
    if (_model.zans.count >0) {
        
        NSString *me = [[BmobUser currentUser] objectForKey:@"nickName"];

        for (NSString *name in _model.zans) {
            
            if ([name isEqualToString:me]) {
                
                self.zan.selected = YES;
            }else{
                
                self.zan.selected = NO;
            }
        }
        
    }else{
        
        self.zan.selected = NO;
    }
    //移除图片组
    for (UIImageView *imgV in self.mediaView.subviews) {
        
        [imgV removeFromSuperview];
    }
    [self.arr removeAllObjects];
    
    if (_model.medias.count == 0) {
        
        self.imgV.hidden = YES;
        self.mediaView.hidden = YES;
        self.topSpace.constant = _model.contentHeight;
        
    }else if(_model.medias.count == 1){
        
        self.mediaView.hidden = NO;
        self.topSpace.constant = 210;
        self.mediaHeight.constant = 200;
        
        self.imgV.hidden = NO;
        NSString *img = _model.medias[0];
        [self.imgV sd_setImageWithURL:[NSURL URLWithString:img] placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
        [self.mediaView addSubview:self.imgV];
        [self.arr addObject:self.imgV.image];
        
    }else{
        
        self.mediaView.hidden = NO;
        
        self.imgV.hidden = YES;
        
        if (_model.medias.count <=3) {
            
            self.topSpace.constant = 115;
            self.mediaHeight.constant = 100;
            
        }else if (_model.medias.count >3 &&_model.medias.count <=6) {
            
            self.topSpace.constant = 215;
            self.mediaHeight.constant = 200;
            
        }else if (_model.medias.count >6 &&_model.medias.count <=9) {
            
            self.topSpace.constant = 315;
            self.mediaHeight.constant = 300;
        }
        //创建数组
        [self createImgVsWithArr:_model.medias];
    }
}

/**
 根据数组创建图片

 @param arr 数组
 */
- (void)createImgVsWithArr:(NSMutableArray *)arr
{
    CGFloat width = 100;
    for (int i = 0; i <arr.count; i++) {
        
        NSInteger x = i%3 *(width +5);
        NSInteger y= i/3 *(width +5);
        
        UIImageView *imgV = [[UIImageView alloc]initWithFrame:CGRectMake(x, y, width, width)];
        imgV.tag = i;
        imgV.userInteractionEnabled = YES;
        [imgV sd_setImageWithURL:[NSURL URLWithString:arr[i]] placeholderImage:[UIImage imageNamed:@"placeholder.jpg"]];
        
        [self.arr addObject:imgV.image];
        
        //点击事件
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [imgV addGestureRecognizer:tap];
        
        [self.mediaView addSubview:imgV];
    }
}

#pragma mark ----Action----

/**
 图片点击事件
 */
- (void)tapAction:(UITapGestureRecognizer *)tap
{
    SDPhotoBrowser *browser = [[SDPhotoBrowser alloc] init];
    
    //设置容器视图,父视图
    browser.sourceImagesContainerView = self.mediaView;
    UIImageView *imgV = (UIImageView *)[tap view];
    browser.currentImageIndex = imgV.tag;
    browser.imageCount = self.model.medias.count;
    
    //设置代理
    browser.delegate = self;
    //显示图片浏览器
    [browser show];
}

/**
 点赞按钮点击事件

 @param sender 按钮
 */
- (IBAction)zanBtnAction:(UIButton *)sender {
    
    //点赞人加入到数组中
    sender.selected = !sender.selected;
    
    BmobUser *user = [BmobUser currentUser];
    BmobObject *obj = [BmobObject objectWithoutDataWithClassName:@"friendCircle" objectId:self.model.objectID];
    
    if (sender.selected) {
        
        [obj addObjectsFromArray:@[[user objectForKey:@"nickName"]] forKey:@"zan"];
        
        [obj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            
            if (isSuccessful) {
                
            }else{
                
                sender.selected = !sender.selected;
                NSLog(@"error:%@",error);
                [self.viewController showErrorWith:@"网络出错,请重试!"];
            }
        }];
        
    }else{
        
        [obj removeObjectsInArray:@[[user objectForKey:@"nickName"]] forKey:@"zan"];
        [obj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
            
            if (isSuccessful) {
                
            }else{
                
                sender.selected = !sender.selected;
                NSLog(@"error:%@",error);
                [self.viewController showErrorWith:@"网络出错,请重试!"];
            }
        }];
    }
}

/**
 评论按钮点击事件
 
 @param sender 按钮
 */
- (IBAction)plBtnAction:(UIButton *)sender {
    
    
    
}

#pragma mark ----SDPhotoBrowserDelegate----

- (NSURL *)photoBrowser:(SDPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index
{
    //拿到显示的图片的高清图片地址
    return self.model.medias[index];
}

//返回占位图片
- (UIImage *)photoBrowser:(SDPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index
{
    //return [UIImage imageNamed:@"placeholder.jpg"];
    return self.arr[index];
}

#pragma mark ----Override----

- (void)setFrame:(CGRect)frame
{
    frame.origin.y +=10;
    frame.size.height -=10;
    
    [super setFrame:frame];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark ----Lazy----

- (UIImageView *)imgV
{
    if (!_imgV) {
        _imgV = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 200,200)];
        _imgV.tag = 0;
        _imgV.userInteractionEnabled = YES;
        
        //点击事件
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)];
        [_imgV addGestureRecognizer:tap];
    }
    return _imgV;
}

- (NSMutableArray *)arr
{
    if (!_arr) {
        _arr = [[NSMutableArray alloc]init];
    }
    return _arr;
}

@end
