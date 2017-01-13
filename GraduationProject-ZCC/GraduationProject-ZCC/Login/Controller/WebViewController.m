//
//  WebViewController.m
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 17/1/13.
//  Copyright © 2017年 诺达科技. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()<UIWebViewDelegate>

@property(nonatomic,strong)UIWebView *webView;

@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    [self initData];
}

- (void)initView
{
    [self.view addSubview:self.webView];
}

- (void)initData
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.adURL]];
    [self.webView loadRequest:request];
}

#pragma mark ----UIWebViewDelegate----

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self showLoadingWith:@"加载中"];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self showSuccessWith:@"已完成"];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self showErrorWith:@"未知错误"];
    [self dismissViewControllerAnimated:YES completion:^{
        
        if (_finishShow) {
            _finishShow();
        }
    }];
}

#pragma mark ----Action----

/**
 导航栏返回按钮点击事件
 
 @param back 按钮
 */
- (void)backBtnAction:(UIButton *)back
{
    [self dismissViewControllerAnimated:YES completion:^{
        
        if (_finishShow) {
            _finishShow();
        }
    }];
}

#pragma mark ----Lazy----

- (UIWebView *)webView
{
    if (!_webView) {
        _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64)];
        _webView.delegate = self;
    }
    return _webView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
