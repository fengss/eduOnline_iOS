//
//  PanoOverlayViewController.m
//  PanoramaViewDemo
//
//  Created by baidu on 15/4/12.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "PanoOverlayViewController.h"
#import "BMPanoView.h"
#import "BMPanoTextOverlay.h"
#import "BMPanoImageOverlay.h"
@interface PanoOverlayViewController ()<PanoramaViewDelegate>

@property(strong, nonatomic) BMPanoView  *panoramaView;

@end

@implementation PanoOverlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setTitle:@"全景图覆盖物"];
    [self customPanoView];
    if (self.overlayType == panoOverlayTypeImage) {
        [self addImageOverlayTest];
    }else {
        [self addTextOverLayTest];
    }
    
    // Do any additional setup after loading the view.
}

- (void)viewDidDisappear:(BOOL)animated
{
    //界面消失的时候移除覆盖物
    if(self.overlayType == panoOverlayTypeImage) {
        [self.panoramaView removeOverlay:@"54321"];
    }else {
        [self.panoramaView removeOverlay:@"12345"];
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
    [self.panoramaView setPanorama:@"01002200001309101607372275K"];
    //根据经纬度设置全景点
    
}

- (void)addTextOverLayTest {
    BMPanoTextOverlay *textOverlay = [[BMPanoTextOverlay alloc] init];
    textOverlay.overlayId = @"12345";
    textOverlay.x         = 12971338;
    textOverlay.y         = 4826229;
    textOverlay.textColor = 0xff0000ff;
    textOverlay.backgroundColor = 0xffffffff;
    textOverlay.fontSize  = 25;
    textOverlay.text      = @"这是一段测试文字";
    textOverlay.pitch     = 80;
    [self.panoramaView addOverlay:textOverlay];
}

- (void)addImageOverlayTest {
    BMPanoImageOverlay *imageOverlay = [[BMPanoImageOverlay alloc] init];
    imageOverlay.overlayId = @"54321";
    imageOverlay.x         = 12971338;
    imageOverlay.y         = 4826229;
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingString:@"/PanoramaView.bundle"];
    NSBundle *sdkBundle = [NSBundle bundleWithPath:path];
    imageOverlay.imagePath = [sdkBundle pathForResource:@"icon_marka" ofType:@"png"];
    [self.panoramaView addOverlay:imageOverlay];
}


-(void)loadDataStart
{
    NSLog(@"loadDataStart");
}

-(void)loadDataEnd
{
    NSLog(@"loadDataEnd");
}

-(void)loadDataFail
{
    NSLog(@"loadDataFail");
}

-(void)onClickOverlay
{
    NSLog(@"onClickOverlay");
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
