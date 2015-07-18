//
//  PanoShowViewController.h
//  PanoramaViewDemo
//
//  Created by baidu on 15/4/10.
//  Copyright (c) 2015年 baidu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    PanoShowTypePID,
    PanoShowTypeGEO,
    PanoShowTypeXY,
} PanoShowType;
@interface PanoShowViewController : UIViewController

@property(assign, nonatomic) PanoShowType showType;
@end
