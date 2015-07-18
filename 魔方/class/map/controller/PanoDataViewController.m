//
//  PanoDataViewController.m
//  PanoramaViewDemo
//
//  Created by baidu on 15/4/13.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "PanoDataViewController.h"
#import "BMPanoDataEngine.h"
#import "BMPanoView.h"
@interface PanoDataViewController ()<PanoramaViewDelegate>

@property(strong, nonatomic) BMPanoView  *panoramaView;

@end

@implementation PanoDataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"获取全景图数据";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self customPanoView];
    // Do any additional setup after loading the view.
}
- (void)customPanoView {
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth([self getFixedScreenFrame]), CGRectGetHeight([self getFixedScreenFrame]));
    self.panoramaView = [[BMPanoView alloc] initWithFrame:frame];
    self.panoramaView.delegate = self;
    [self.view addSubview:self.panoramaView];
    //设置地图的级别，1-5级可选，级别越高，图像越清晰，同样需要加载的图像体积也越大
    [self.panoramaView setPanoramaImageLevel:5];
    //级别范围是18-20，级别越高，显示的fov越小
    [self.panoramaView setPanoramaLevel:18];
    [self.panoramaView setPanorama:@"01002200001309101607372275K"];
    
}

//需要在单点描述信息加载完毕回调中才能获取到单点信息
-(void)loadDescreptionEnd
{
    /********************** PanoData   *************************/
    BMPanoDataEngine* dataEngine = [BMPanoDataEngine sharedInstance];
    NSString *string = [dataEngine GetCurrnetPanoramaInfo];
    NSData *data=[string dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    NSLog(@"全景描述json：%@",json);
    
}

- (UIButton *)createButton:(NSString *)title target:(SEL)selector frame:(CGRect)frame {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
        [button setBackgroundColor:[UIColor whiteColor]];
    }else {
        [button setBackgroundColor:[UIColor clearColor]];
    }
    [button addTarget:self action:selector forControlEvents:UIControlEventTouchUpInside];
    return button;
}

//获取设备bound方法
- (BOOL)isPortrait {
    UIInterfaceOrientation orientation = [self getStatusBarOritation];
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        return YES;
    }
    return NO;
}
- (UIInterfaceOrientation)getStatusBarOritation {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    return orientation;
}
- (CGRect)getFixedScreenFrame {
    CGRect mainScreenFrame = [UIScreen mainScreen].bounds;
#ifdef NSFoundationVersionNumber_iOS_7_1
    if(![self isPortrait]&& (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1)) {
        mainScreenFrame = CGRectMake(0, 0, mainScreenFrame.size.height, mainScreenFrame.size.width);
    }
#endif
    return mainScreenFrame;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
