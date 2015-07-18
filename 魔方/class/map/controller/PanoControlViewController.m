//
//  PanoControlViewController.m
//  PanoramaViewDemo
//
//  Created by baidu on 15/4/10.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import "PanoControlViewController.h"
#import "BMPanoView.h"

#define TAG_SLIDER_PITCH   100001
#define TAG_SLIDER_HEADING 100002
#define TAG_SLIDER_LEVEL   100003
@interface PanoControlViewController ()<PanoramaViewDelegate>

@property(strong, nonatomic) BMPanoView  *panoramaView;
@property(strong, nonatomic) UISlider    *panoPitchSlider;
@property(strong, nonatomic) UISlider    *panoHeadingSlider;
@property(strong, nonatomic) UISlider    *panoLevelSlider;

@end

@implementation PanoControlViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"全景图控制";
    [self customPanoView];
    [self customSliderView];
    // Do any additional setup after loading the view.
}

- (void)customPanoView {
    CGRect frame = CGRectMake(0, 0, CGRectGetWidth(getFixedScreenFrame()), CGRectGetHeight(getFixedScreenFrame()));
    self.panoramaView = [[BMPanoView alloc] initWithFrame:frame];
    self.panoramaView.delegate = self;
    [self.view addSubview:self.panoramaView];
    //设置地图的级别，1-5级可选，级别越高，图像越清晰，同样需要加载的图像体积也越大
    [self.panoramaView setPanoramaImageLevel:5];
    //级别范围是18-20，级别越高，显示的fov越小
    [self.panoramaView setPanoramaLevel:18];
    [self.panoramaView setPanorama:@"01002200001309101607372275K"];
    //根据经纬度设置全景点
    [self.panoramaView setPanoramaWithX:self.address_Y andY:self.address_X];
}

- (void)customSliderView {
    CGFloat offsety = self.view.frame.size.height - 150;
    CGFloat offsetx = 5;
    UILabel *pitchLabel = [[UILabel alloc]initWithFrame:CGRectMake(offsetx, offsety, 100, 20)];
    pitchLabel.text = @"俯仰角控制";
//    pitchLabel.textColor = [UIColor grayColor];
    [self.view addSubview:pitchLabel];
    self.panoPitchSlider = [[UISlider alloc]initWithFrame:CGRectMake(105+offsetx, offsety, 200, 20)];
    [self.panoPitchSlider setMaximumValue:-75];
    [self.panoPitchSlider setMinimumValue:-180];
    [self.panoPitchSlider addTarget:self action:@selector(updateValue:) forControlEvents:UIControlEventValueChanged];
    [self.panoPitchSlider setTag:TAG_SLIDER_PITCH];
    [self.view addSubview:self.panoPitchSlider];
    offsety += 35;
    UILabel *headLabel = [[UILabel alloc]initWithFrame:CGRectMake(offsetx, offsety, 100, 20)];
    headLabel.text = @"朝向控制";
    [self.view addSubview:headLabel];
    self.panoHeadingSlider = [[UISlider alloc]initWithFrame:CGRectMake(105+offsetx, offsety, 200, 20)];
    [self.panoHeadingSlider setMaximumValue:360];
    [self.panoHeadingSlider addTarget:self action:@selector(updateValue:) forControlEvents:UIControlEventValueChanged];
    [self.panoHeadingSlider setTag:TAG_SLIDER_HEADING];
    [self.view addSubview:self.panoHeadingSlider];
    offsety += 35;
    UILabel *levelLabel = [[UILabel alloc]initWithFrame:CGRectMake(offsetx, offsety, 100, 20)];
    levelLabel.text = @"缩放控制";
    [self.view addSubview:levelLabel];
    self.panoLevelSlider = [[UISlider alloc]initWithFrame:CGRectMake(105+offsetx, offsety, 200, 20)];
    [self.panoLevelSlider setMaximumValue:20];
    [self.panoLevelSlider setMinimumValue:18];
    [self.panoLevelSlider addTarget:self action:@selector(updateValue:) forControlEvents:UIControlEventValueChanged];
    [self.panoLevelSlider setTag:TAG_SLIDER_LEVEL];
    [self.view addSubview:self.panoLevelSlider];
}


- (void)updateValue:(id)sender {
    
    UISlider *slider = (UISlider *)sender;
    if (slider.tag == TAG_SLIDER_PITCH) {
        [self.panoramaView setPanoramaPitch:slider.value];
    }else if (slider.tag == TAG_SLIDER_HEADING) {
        [self.panoramaView setPanoramaHeading:slider.value];
    }else if (slider.tag == TAG_SLIDER_LEVEL) {
        [self.panoramaView setPanoramaLevel:slider.value];
    }
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
BOOL isPortrait() {
    UIInterfaceOrientation orientation = getStatusBarOritation();
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        return YES;
    }
    return NO;
}
UIInterfaceOrientation getStatusBarOritation() {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    return orientation;
}
CGRect getFixedScreenFrame() {
    CGRect mainScreenFrame = [UIScreen mainScreen].bounds;
#ifdef NSFoundationVersionNumber_iOS_7_1
    if(!isPortrait() && (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_7_1)) {
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
