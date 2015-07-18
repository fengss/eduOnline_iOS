//
//  PanoOverlayViewController.h
//  PanoramaViewDemo
//
//  Created by baidu on 15/4/12.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    PanoOverlayTypeText,
    panoOverlayTypeImage,
} PanoOverlayType;

@interface PanoOverlayViewController : UIViewController

@property(assign, nonatomic) PanoOverlayType overlayType;

@end
