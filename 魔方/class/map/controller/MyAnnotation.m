//
//  MyAnnotation.m
//  魔方
//
//  Created by fengss on 15-5-14.
//  Copyright (c) 2015年 coderss. All rights reserved.
//

#import "MyAnnotation.h"

@implementation MyAnnotation
-(NSDictionary *)mydic{
    if (_mydic==nil) {
        _mydic=[NSDictionary dictionary];
    }
    return _mydic;
}
@end
