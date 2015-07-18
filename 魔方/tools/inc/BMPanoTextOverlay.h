//
//  BMTextOverlay.h
//  StreetViewDemo
//
//  Created by baidu on 14-7-3.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import "BMPanoOverlay.h"

@interface BMPanoTextOverlay : BMPanoOverlay

@property(nonatomic , strong) NSString* text;
@property(nonatomic , assign) NSInteger fontSize;
@property(nonatomic , assign) NSInteger textColor;
@property(nonatomic , assign) NSInteger backgroundColor;

@end
