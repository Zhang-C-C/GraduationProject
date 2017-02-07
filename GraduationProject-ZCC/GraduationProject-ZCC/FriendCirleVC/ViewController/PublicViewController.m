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

- (void)initData
{
    
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
    NSMutableArray *array = [SaveDataTools sharedInstance].images;
    
    NSLog(@"array:%@",array);
    NSLog(@"text:%@",self.textView.text);
    
    //更新表
    BmobUser *user = [BmobUser currentUser];
    
    BmobObject *obj = [BmobObject objectWithClassName:@"friendCircle"];
    
    [obj setObject:[user objectForKey:@"nickName"] forKey:@"name"];
    [obj setObject:self.textView.text forKey:@"content"];
    [obj setObject:[user objectForKey:@"imageUrl"] forKey:@"headImgV"];
    
    [obj saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
       
        if (isSuccessful) {
            
            [self.navigationController popViewControllerAnimated:YES];
            [self showSuccessWith:@"已发表"];
            
            
//            //数组中添加数据
//            BmobObject *object = [BmobObject objectWithoutDataWithClassName:@"friendCircle" objectId:user.objectId];
//            
//            [object addObjectsFromArray:@[] forKey:@"signDays"];
//            
//            [object updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
//                
//                
//            }];
            
        }else{
            
            NSLog(@"error:%@",error);
            [self showErrorWith:@"网络出错!"];
        }
        
    }];
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
