//
//  PerfectHeadView.m
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/2.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import "PerfectHeadView.h"
#import "HCDataHelper.h"

@interface PerfectHeadView ()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>


@end

@implementation PerfectHeadView

+ (instancetype)loadView
{
    return [[[NSBundle mainBundle] loadNibNamed:@"PerfectHeadView" owner:nil options:nil] lastObject];
}

#pragma mark ----Action----

/**
 定位按钮点击事件

 @param sender 按钮
 */
- (IBAction)locationBtnAction:(UIButton *)sender {
    

}

/**
 头像按钮点击事件

 @param sender 按钮
 */
- (IBAction)headBtnAction:(UIButton *)sender {
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:@"头像选择" message:@"选择" preferredStyle:UIAlertControllerStyleActionSheet];
    
    //相册
    UIImagePickerController *ipc = [[UIImagePickerController alloc] init];
    ipc.delegate = self;
    
    UIAlertAction* action1 = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {
        
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) return;
        ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self.viewController presentViewController:ipc animated:YES completion:nil];
    }];
    UIAlertAction* action2 = [UIAlertAction actionWithTitle:@"从相册上传" style:UIAlertActionStyleDefault  handler:^(UIAlertAction * _Nonnull action) {

        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) return;
        ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self.viewController presentViewController:ipc animated:YES completion:nil];
    }];
    
    UIAlertAction* cancle = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [alertVC addAction:action1];
    [alertVC addAction:action2];
    [alertVC addAction:cancle];
    
    [self.viewController presentViewController:alertVC animated:YES completion:nil];
}

#pragma mark ----UIImagePickerControllerDelegate----

//获取图片后的操作
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    [self.viewController showLoadingWith:@"正在加载图片"];
    
    //保存到沙河路径
    if (![self saveImgWithImg:info[UIImagePickerControllerOriginalImage]]) {
        
        [self saveImgWithImg:info[UIImagePickerControllerOriginalImage]];
    }
}

- (BOOL )saveImgWithImg:(UIImage *)img
{
    //保存到沙河路径
    NSData * imageData = UIImagePNGRepresentation([AppTools imageByScalingAndCroppingWithImg:img ForSize:CGSizeMake(200, 200)]);
    NSString *path = [HCDataHelper libCachePath];
    path = [path stringByAppendingPathComponent:@"headImgV.png"];
    BOOL isOK = [imageData writeToFile:path atomically:YES];
    
    if (isOK) {
        
        [self.viewController showSuccessWith:@"图片调用成功"];
        [self.headImgVBtn setImage:img forState:UIControlStateNormal];
        self.imgPath = path;
    }
    return isOK;
}



@end
