//
//  PublicViewController.m
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 17/2/7.
//  Copyright © 2017年 诺达科技. All rights reserved.
//

#import "PublicViewController.h"
#import "PhotosView.h"

@interface PublicViewController ()<UITextViewDelegate>

@property(nonatomic,strong)UITextView *textView;
@property(nonatomic,strong)PhotosView *photosView;


@end

@implementation PublicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
}

- (void)initView
{
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTitle:@"发表" target:self action:@selector(publicBtnAction)];
    [self.view addSubview:self.textView];
    
    [self.view addSubview:self.photosView];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self.textView resignFirstResponder];
}

#pragma mark ----Action----

/**
 发布按钮点击事件
 */
- (void)publicBtnAction
{
    //安全判断
    NSMutableArray *arr = [SaveDataTools sharedInstance].images;
        
    if (arr.count == 0 &&[self.textView.text isEqualToString:@"说点什么吧..."]) {
     
        [self showErrorWith:@"请输入内容"];
        return ;
    }
    //清空输入
    if ([self.textView.text isEqualToString:@"说点什么吧..."]) {
        self.textView.text = nil;
    }
    [self showLoadingWith:@"正在发表..."];
    //更新表
    BmobUser *user = [BmobUser currentUser];
    
    BmobObject *obj = [BmobObject objectWithClassName:@"friendCircle"];
    
    [obj setObject:[user objectForKey:@"nickName"] forKey:@"name"];
    [obj setObject:self.textView.text forKey:@"content"];
    [obj setObject:[user objectForKey:@"imageUrl"] forKey:@"headImgV"];
    
    //先保存文字信息
    [obj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
        
        if (isSuccessful &&arr.count == 0) {
            
            [self.navigationController popViewControllerAnimated:YES];
            [self showSuccessWith:@"已发表"];
            
        }else if(!isSuccessful){
            
            NSLog(@"error:%@",error);
            [self showErrorWith:@"网络出错!"];
        }
    }];
    
    //上传图片
    for (NSString *imgName in arr) {
        
        [BmobFile filesUploadBatchWithPaths:@[imgName] progressBlock:nil resultBlock:^(NSArray *array, BOOL isSuccessful, NSError *error) {
            
            if (isSuccessful) {
                
                BmobFile *file = array[0];
                
                [obj addObjectsFromArray:@[file.url] forKey:@"medias"];
                
                [obj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                    
                    if (!error ) {
                        
                        [self.navigationController popViewControllerAnimated:YES];
                        [self showSuccessWith:@"已发表"];
                        
                    }else {
                        
                        [self showErrorWith:@"网络出错!"];
                        NSLog(@"error%@",error);
                    }
                }];
            }else{
                
                NSLog(@"error:%@",error);
            }
        }];
    }
}

#pragma mark ----UITextViewDelegate----

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    textView.text = @"";
    textView.textColor = [UIColor whiteColor];
    
    return YES;
}


#pragma mark ----Lazy----

- (UITextView *)textView
{
    if (!_textView) {
        _textView = [[UITextView alloc]initWithFrame:CGRectMake(5, 64, kScreenWidth-10, kScreenHeight *0.2)];
        
        _textView.text = @"说点什么吧...";
        _textView.delegate = self;
        _textView.textColor = [UIColor whiteColor];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.font = [UIFont systemFontOfSize:18.0];
    }
    return _textView;
}

- (PhotosView *)photosView
{
    if (!_photosView) {
        _photosView = [[PhotosView alloc]initWithFrame:CGRectMake(15, CGRectGetMaxY(self.textView.frame), kScreenWidth-30, 999)];
    }
    return _photosView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
