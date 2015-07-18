//
//  MyAnnotation.h
//  魔方
//
//  Created by fengss on 15-5-14.
//  Copyright (c) 2015年 coderss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI/BMapKit.h>

@interface MyAnnotation : BMKPointAnnotation
//标注点的cell显示信息
@property(nonatomic,strong) NSDictionary  * mydic;

@end
