
//
//  PanoShowViewController.m
//  PanoramaViewDemo
//
//  Created by baidu on 15/4/10.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "PanoShowViewController.h"
#import "BMPanoView.h"
@interface PanoShowViewController ()<PanoramaViewDelegate>

@property(strong, nonatomic) BMPanoView  *panoramaView;
@property(strong, nonatomic) UITextField *panoPidTF;
@property(strong, nonatomic) UITextField *panoCoorXTF;
@property(strong, nonatomic) UITextField *panoCoorYTF;

@end

@implementation PanoShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"百度全景展示"];
    [self customPanoView];
    [self customInputView];
    [self showPanoViewWithPID:@"01002200001309101607372275K"];
    // Do any additional setup after loading the view.
}

- (void)customInputView {
    
    CGFloat offsety = 70;
    CGRect btnFrame = CGRectMake(260, offsety, 50, 30);
    UIButton *enterBtn = [self createButton:@"确定" target:@selector(refreshPanoViewData) frame:btnFrame];
    [self.view addSubview:enterBtn];
    if (self.showType == PanoShowTypePID) {
        self.panoPidTF = [[UITextField alloc]initWithFrame:CGRectMake(5, offsety, 250, 30)];
        self.panoPidTF.backgroundColor = [UIColor whiteColor];
        self.panoPidTF.placeholder     = @" 输入全景PID展示全景";
        [self.view addSubview:self.panoPidTF];
    }else if (self.showType == PanoShowTypeGEO) {
        self.panoCoorXTF = [[UITextField alloc]initWithFrame:CGRectMake(5, offsety, 250, 30)];
        self.panoCoorXTF.backgroundColor = [UIColor whiteColor];
        self.panoCoorXTF.placeholder     = @"输入地理坐标longitude";
        offsety += 35;
        self.panoCoorYTF = [[UITextField alloc]initWithFrame:CGRectMake(5, offsety, 250, 30)];
        self.panoCoorYTF.backgroundColor = [UIColor whiteColor];
        self.panoCoorYTF.placeholder     = @"输入地理坐标latitude";
        [self.view addSubview:self.panoCoorXTF];
        [self.view addSubview:self.panoCoorYTF];
    }else {
        self.panoCoorXTF = [[UITextField alloc]initWithFrame:CGRectMake(5, offsety, 250, 30)];
        self.panoCoorXTF.backgroundColor = [UIColor whiteColor];
        self.panoCoorXTF.placeholder     = @"输入百度坐标X";
        offsety += 35;
        self.panoCoorYTF = [[UITextField alloc]initWithFrame:CGRectMake(5, offsety, 250, 30)];
        self.panoCoorYTF.backgroundColor = [UIColor whiteColor];
        self.panoCoorYTF.placeholder     = @"输入百度坐标Y";
        [self.view addSubview:self.panoCoorXTF];
        [self.view addSubview:self.panoCoorYTF];
    }
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
    //根据经纬度设置全景点
    
}

- (void)showPanoViewWithPID:(NSString *)pid {
    [self.panoramaView setPanorama:pid];
}

- (void)showPanoViewWithLon:(double)lon lat:(double)lat {
    [self.panoramaView setPanoramaWithLon:lon andLat:lat];
}

- (void)showPanoViewWithX:(int)x Y:(int)y {
    [self.panoramaView setPanoramaWithX:x andY:y];
}

- (void)refreshPanoViewData {
    if (self.showType == PanoShowTypePID) {
        if (self.panoPidTF.text.length>0) {
            [self showPanoViewWithPID:self.panoPidTF.text];
        }
        [self.panoPidTF resignFirstResponder];
    }else if (self.showType == PanoShowTypeGEO) {
        if (self.panoCoorXTF.text.length>0 && self.panoCoorYTF.text.length>0) {
            [self showPanoViewWithLon:[self.panoCoorXTF.text doubleValue] lat:[self.panoCoorYTF.text doubleValue]];
        }
        [self.panoCoorXTF resignFirstResponder];
        [self.panoCoorYTF resignFirstResponder];
    }else {
        if (self.panoCoorXTF.text.length>0 && self.panoCoorYTF.text.length>0) {
            [self showPanoViewWithX:[self.panoCoorXTF.text intValue] Y:[self.panoCoorYTF.text intValue]];
        }
        [self.panoCoorXTF resignFirstResponder];
        [self.panoCoorYTF resignFirstResponder];
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - other func 
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
