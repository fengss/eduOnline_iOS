//
//  BMImageOverlay.h
//  StreetViewDemo
//
//  Created by baidu on 14-7-3.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import "BMPanoOverlay.h"

@interface BMPanoImageOverlay : BMPanoOverlay

@property(nonatomic , strong) NSString* imagePath;
@property(nonatomic , assign) float     pitch;

@end
