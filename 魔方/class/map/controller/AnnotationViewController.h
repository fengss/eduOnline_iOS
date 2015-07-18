//
//
//  Copyright 2011 Baidu Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI/BMapKit.h>

@interface AnnotationViewController : UIViewController <BMKMapViewDelegate,BMKGeoCodeSearchDelegate>{
	IBOutlet BMKMapView* _mapView;
    IBOutlet UISegmentedControl* segment;
}

@end
