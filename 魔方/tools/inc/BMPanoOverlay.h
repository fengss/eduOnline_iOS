//
//  BMOverlay.h
//  StreetViewDemo
//
//  Created by baidu on 14-7-3.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BMPanoOverlay : NSObject

enum
{
	TYPE_TEXT = 1,
	TYPE_IMAGE = 2,
	TYPE_UNKNOWN = 3
};

@property(nonatomic , strong) NSString* overlayId;
@property(nonatomic , assign) NSInteger type;
@property(nonatomic , assign) NSInteger x;
@property(nonatomic , assign) NSInteger y;
@property(nonatomic , assign) float pitch;

@end
