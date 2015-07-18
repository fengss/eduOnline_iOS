//
//  AnnotationDemoViewController.m
//  BaiduMapApiDemo
//
//  Copyright 2011 Baidu Inc. All rights reserved.
//
#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]
#import "AnnotationViewController.h"
#import "MyAnimatedAnnotationView.h"
#import "MyAnnotation.h"
#import "PanoControlViewController.h"
#import "User.h"

@interface AnnotationViewController ()
{
    BMKCircle* circle;
    BMKPolygon* polygon;
    BMKPolygon* polygon2;
    BMKPolyline* polyline;
    BMKArcline* arcline;
    BMKGroundOverlay* ground;
    BMKGroundOverlay* ground2;
    MyAnnotation* pointAnnotation;
    BMKPointAnnotation* animatedAnnotation;
    BMKGeoCodeSearch* geocodesearch;
}
@property(nonatomic,strong) NSMutableArray  * dataArr;
@end

@implementation AnnotationViewController
//懒加载
-(NSMutableArray *)dataArr{
    if (_dataArr==nil) {
        _dataArr=[NSMutableArray arrayWithCapacity:0];
    }
    return _dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    geocodesearch = [[BMKGeoCodeSearch alloc]init];
    //直接去检索
    [self Geocode];
    //设置中心点
    _mapView.centerCoordinate = CLLocationCoordinate2DMake(31, 121);
    
    
    //左右两边的menu
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu_left"] style:UIBarButtonItemStylePlain target:self action:@selector(presentLeftMenuViewController:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu_right"]  style:UIBarButtonItemStylePlain target:self action:@selector(presentRightMenuViewController:)];
    
    //适配ios7
    if( ([[[UIDevice currentDevice] systemVersion] doubleValue]>=7.0))
    {
        self.navigationController.navigationBar.translucent = NO;
    }
    //设置地图缩放级别
    [_mapView setZoomLevel:9];
    //添加标注
    [self addPointAnnotation];
    //加载用户数据
    [self loadUserData];
}

-(void)loadUserData{
    AppDelegate *app=[UIApplication sharedApplication].delegate;
    [app.manger GET:USERADDRESS parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
       /*[{"id":"97","username":"fengss","userpass":"a0fb44be32ca0965862a09743ffd5047","name":"\u67ab\u4e09\u5c11","sex":"1","age":"19","email":"admin@coderss.cn","class":null,"picture":"553c44033ecc3.jpg","level":null,"point":null,"addtime":"1430012813","introduce":"\u54c8\u55bd\u5566","logintime":"0","logouttime":"0","address_X":"121.52475","loginnum":"0","address_Y":"31.276453"},{"id":"101","username":"dating","userpass":"a0fb44be32ca0965862a09743ffd5047","name":"\u9686\u9686","sex":"1","age":"12","email":"dating@qq.com","class":"","picture":"554f107164990.jpg","level":"1","point":"0","addtime":"1431244913","introduce":"","logintime":"0","logouttime":"0","address_X":"121","loginnum":"0","address_Y":"31.276"}]*/
        if ([[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]isKindOfClass:[NSArray class]]) {
            NSArray *temp=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            for (NSDictionary *dic in temp) {
                User *user=[[User alloc]init];
                [user setValuesForKeysWithDictionary:dic];
                [self.dataArr addObject:user];
            }
        }
        [self addPointAnnotation];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

-(void)viewWillAppear:(BOOL)animated {
    [_mapView viewWillAppear];
    _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
}

-(void)viewWillDisappear:(BOOL)animated {
    [_mapView viewWillDisappear];
    _mapView.delegate = nil; // 不用时，置nil
}

- (void)dealloc {
    if (_mapView) {
        _mapView = nil;
    }
}


//添加标注
- (void)addPointAnnotation
{
    for (int i=0; i<self.dataArr.count; i++) {
        User *model=[self.dataArr objectAtIndex:i];
        
        pointAnnotation = [[MyAnnotation alloc]init];
        CLLocationCoordinate2D coor;
        coor.latitude = [model.address_Y floatValue];
        coor.longitude =[model.address_X floatValue];
        pointAnnotation.coordinate = coor;
        pointAnnotation.title = model.username;
        pointAnnotation.subtitle = model.introduce;
        [_mapView addAnnotation:pointAnnotation];
    }
}


//根据overlay生成对应的View
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id <BMKOverlay>)overlay
{
    if ([overlay isKindOfClass:[BMKCircle class]])
    {
        BMKCircleView* circleView = [[BMKCircleView alloc] initWithOverlay:overlay];
        circleView.fillColor = [[UIColor redColor] colorWithAlphaComponent:0.5];
        circleView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
        circleView.lineWidth = 5.0;
        
        return circleView;
    }
    
    if ([overlay isKindOfClass:[BMKPolyline class]])
    {
        BMKPolylineView* polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        polylineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:1];
        polylineView.lineWidth = 20.0;
        [polylineView loadStrokeTextureImage:[UIImage imageNamed:@"texture_arrow.png"]];
        
        return polylineView;
    }
    
    if ([overlay isKindOfClass:[BMKPolygon class]])
    {
        BMKPolygonView* polygonView = [[BMKPolygonView alloc] initWithOverlay:overlay];
        polygonView.strokeColor = [[UIColor purpleColor] colorWithAlphaComponent:1];
        polygonView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:0.2];
        polygonView.lineWidth =2.0;
        polygonView.lineDash = (overlay == polygon2);
        return polygonView;
    }
    if ([overlay isKindOfClass:[BMKGroundOverlay class]])
    {
        BMKGroundOverlayView* groundView = [[BMKGroundOverlayView alloc] initWithOverlay:overlay];
        return groundView;
    }
    if ([overlay isKindOfClass:[BMKArcline class]]) {
        BMKArclineView *arclineView = [[BMKArclineView alloc] initWithArcline:overlay];
        arclineView.strokeColor = [UIColor blueColor];
        arclineView.lineDash = YES;
        arclineView.lineWidth = 6.0;
        return arclineView;
    }
    return nil;
}

#pragma mark -
#pragma mark implement BMKMapViewDelegate


// 根据anntation生成对应的View
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    //普通annotation
    if (annotation == pointAnnotation) {
        NSString *AnnotationViewID = @"renameMark";
        BMKPinAnnotationView *annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:AnnotationViewID];
        if (annotationView == nil) {
            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
            // 设置颜色
            annotationView.pinColor = BMKPinAnnotationColorPurple;
            // 从天上掉下效果
            annotationView.animatesDrop = YES;
            // 设置可拖拽
            annotationView.draggable = YES;
            
            MyAnnotation * ani=(MyAnnotation*)annotation;
            annotationView.tag=ani;
        }
        
        
        return annotationView;
    }
    
    //动画annotation
    NSString *AnnotationViewID = @"AnimatedAnnotation";
    MyAnimatedAnnotationView *annotationView = nil;
    if (annotationView == nil) {
        annotationView = [[MyAnimatedAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:AnnotationViewID];
    }
    NSMutableArray *images = [NSMutableArray array];
    for (int i = 1; i < 4; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"poi_%d.png", i]];
        [images addObject:image];
    }
    annotationView.annotationImages = images;
    return annotationView;
    
}

// 当点击annotation view弹出的泡泡时，调用此接口
- (void)mapView:(BMKMapView *)mapView annotationViewForBubble:(BMKAnnotationView *)view;
{
    NSLog(@"我要查看个人信息");
    MyAnnotation *ano=view.annotation;
    PanoControlViewController *pcVC = [[PanoControlViewController alloc]init];
    NSLog(@"坐标:%f %f",ano.coordinate.latitude,ano.coordinate.longitude);
    pcVC.address_X=ano.coordinate.latitude;
    pcVC.address_Y=ano.coordinate.longitude;
    [self.navigationController pushViewController:pcVC animated:YES];
}


//检索地址
-(void)Geocode
{
    BMKGeoCodeSearchOption *geocodeSearchOption = [[BMKGeoCodeSearchOption alloc]init];
    geocodeSearchOption.city= @"上海";
    geocodeSearchOption.address = @"人民广场";
    BOOL flag = [geocodesearch geoCode:geocodeSearchOption];
    if(flag)
    {
        NSLog(@"geo检索发送成功");
    }
    else
    {
        NSLog(@"geo检索发送失败");
    }
    
}

#pragma mark 检索一下
- (void)onGetGeoCodeResult:(BMKGeoCodeSearch *)searcher result:(BMKGeoCodeResult *)result errorCode:(BMKSearchErrorCode)error
{
    NSArray* array = [NSArray arrayWithArray:_mapView.annotations];
    [_mapView removeAnnotations:array];
    array = [NSArray arrayWithArray:_mapView.overlays];
    [_mapView removeOverlays:array];
    if (error == 0) {
        BMKPointAnnotation* item = [[BMKPointAnnotation alloc]init];
        item.coordinate = result.location;
        item.title = result.address;
        [_mapView addAnnotation:item];
        _mapView.centerCoordinate = result.location;
        NSString* titleStr;
        NSString* showmeg;
        
        titleStr = @"正向地理编码";
        showmeg = [NSString stringWithFormat:@"经度:%f,纬度:%f",item.coordinate.latitude,item.coordinate.longitude];
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:titleStr message:showmeg delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        [myAlertView show];
    }
}

@end

