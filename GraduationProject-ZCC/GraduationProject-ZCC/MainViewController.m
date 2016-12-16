//
//  MianViewController.m
//  GraduationProject-ZCC
//
//  Created by 诺达科技 on 16/12/1.
//  Copyright © 2016年 诺达科技. All rights reserved.
//

#import "MainViewController.h"
#import "BindPhoneViewController.h"
#import "MeViewController.h"
#import "HomeViewController.h"
#import "MsgViewController.h"

@interface MainViewController ()<BmobEventDelegate>
//HomeVC
@property(nonatomic,strong)HomeViewController *homeVC;
//蒙版
@property(nonatomic,strong)UIView *blackView;

@end

@implementation MainViewController

+ (void)initialize
{
    //设置标签栏按钮的选中未选中文字
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:REDRGB} forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor lightGrayColor]} forState:UIControlStateNormal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
        
    [self initView];
    [self initData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self listenUpdatingdata];
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [[AppTools sharedInstance] chechPhoneBindedWithVC:self];
    });
}

- (void)initView
{
    //添加子控制器
    MeViewController *meVC = [[MeViewController alloc]init];
    HomeViewController *homeVC = [[HomeViewController alloc]init];
    
    NSArray *vcs = @[homeVC,meVC];
    NSArray *titles = @[@"首页",@"我"];
    NSArray *normalImgs = @[@"home_normal",@"me_normal"];
    NSArray *selectedImg = @[@"home_selected",@"me_selected"];
    for (int i = 0; i< vcs.count; i ++) {
        
        UIViewController *vc = vcs[i];
        vc.title = titles[i];
        
        BaseNavigationController *baseNav = [[BaseNavigationController alloc]initWithRootViewController:vc];
            
        //设置按钮图片
        baseNav.tabBarItem.image = [UIImage imageNamed:normalImgs[i]];
        baseNav.tabBarItem.selectedImage = [UIImage imageNamed:selectedImg[i]];

        [self addChildViewController:baseNav];
    }
    //设置标签栏样式
    self.tabBar.barStyle = UIBarStyleBlack;
    self.tabBar.alpha = 0.7;
    self.homeVC = homeVC;
}

- (void)initData
{
    //获取数据
    BmobUser *user = [BmobUser currentUser];
    BmobQuery *query = [[BmobQuery alloc]initWithClassName:@"_User"];
    [query getObjectInBackgroundWithId:user.objectId block:^(BmobObject *object, NSError *error) {
        
        if (!error) {
            
            NSString *focusName = [object objectForKey:@"loverName"];
            if (focusName.length > 0) {
                
                //已存在
                NSLog(@"已存在:%@",focusName);
                [SaveDataTools sharedInstance].focusName = focusName;
            }
        }else{
            
            [self showErrorWith:@"获取失败,请重试"];
        }
    }];
}

/**
 监听更新数据
 */
- (void)listenUpdatingdata
{
    BmobEvent *event = [BmobEvent defaultBmobEvent];
    event.delegate = self;
    [event start];
}

#pragma mark ----Delegate----

#pragma mark ----BmobEventDelegate-----

//已连接
-(void)bmobEventDidConnect:(BmobEvent *)event
{
    NSLog(@"连接服务器成功");
}

//接收到数据
- (void)bmobEvent:(BmobEvent *)event didReceiveMessage:(NSString *)message
{
    NSError *error = nil;
    NSData * getJsonData = [message dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary * getDict = [NSJSONSerialization JSONObjectWithData:getJsonData options:NSJSONReadingMutableContainers error:&error];
    
    //获取经纬度和关注的名字
    NSDictionary *dic = getDict[@"data"];
    NSString *latitude = [dic objectForKey:@"latitude"];
    NSString *longitude = [dic objectForKey:@"longitude"];
    
    //数据传递
    NSString *userName = dic[@"username"];
    NSNumber *sex = dic[@"sex"];
    NSInteger sexValue = [sex integerValue];
    self.homeVC.sex = sexValue;
    NSString *imgV = dic[@"imageUrl"];
    [SaveDataTools sharedInstance].imgV = imgV;
    
    BMKMapPoint point1 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(0,0));
    BMKMapPoint point2 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake(0,0));
    
    if ([userName isEqualToString:[BmobUser currentUser].username]) {
        
        //登录账号的位置信息
        point1 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake([latitude doubleValue],[longitude doubleValue]));
        
        [SaveDataTools sharedInstance].myAddressDic = @{@"latitude":latitude,@"longitude":longitude};
        
        return ;
        
    }else if ([userName isEqualToString:[SaveDataTools sharedInstance].focusName]){
        
        //安全判断,是否是关注对象位置信息变化
        [SaveDataTools sharedInstance].TaAddressDic = @{@"latitude":latitude,@"longitude":longitude};
        
        NSLog(@"数据更新,接收到更新:====%@===%@===%@",latitude,longitude,userName);
        point2 = BMKMapPointForCoordinate(CLLocationCoordinate2DMake([latitude doubleValue],[longitude doubleValue]));

        [self.homeVC addAnnotationWithLatitude:[latitude floatValue] Longitude:[longitude floatValue]];
    }
    
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
        CLLocationDistance distance = BMKMetersBetweenMapPoints(point1,point2);
        if (distance >= 0) {
            
            self.homeVC.distance = distance;
            [SaveDataTools sharedInstance].distance = distance;
            
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                
                [AppTools sendLocalNitificationWithTitle:@"通知" WithContent:@"Ta在你附近100米哦" WithTime:0 WithName:[SaveDataTools sharedInstance].focusName WithImgV:[SaveDataTools sharedInstance].imgV WithBock:^{
                    
                    [AppTools alertViewWithTitle:@"提示" WithMsg:@"收到一条新消息" WithSureBtn:@"立即查看" WithCancleBtn:@"我知道了" WithVC:self WithSureBtn:^{
                        
                        if (![self isKindOfClass:[MsgViewController class]]) {
                            
                            MsgViewController *msgVC = [[MsgViewController alloc]init];
                            [[AppDelegate sharedAppDelegate] pushViewController:msgVC WithTitle:@"消息中心"];
                        }
                        
                    } WithCancleBtn:nil];
                    
                }];
                
            });
        }
        NSLog(@"距离是:%f",distance);
    });
}

//可以开始监听
- (void)bmobEventCanStartListen:(BmobEvent *)event
{
    //检测表的变化,检测行变化,只能检测本人的
    [event listenTableChange:BmobActionTypeUpdateTable tableName:@"_User"];
    //[event listenRowChange:BmobActionTypeUpdateRow tableName:@"_User" objectId:@"	4dfa4104bb"];
}

#pragma mark ----Action----


#pragma mark ----Lazy----


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
