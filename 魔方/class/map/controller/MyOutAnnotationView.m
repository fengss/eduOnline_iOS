//
//  MyOutAnnotationView.m
//  魔方
//
//  Created by fengss on 15-5-14.
//  Copyright (c) 2015年 coderss. All rights reserved.
//

#import "MyOutAnnotationView.h"

@implementation MyOutAnnotationView

-(id)initWithAnnotation:(id<BMKAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor]; self.canShowCallout = NO;
        
        self.centerOffset = CGPointMake(0, -55);
        
        self.frame = CGRectMake(0, 0, 240, 80);
        
        UIView *_contentView = [[UIView alloc] initWithFrame:CGRectMake(5, 5, self.frame.size.width-15, self.frame.size.height-15)];
        _contentView.backgroundColor=[UIColor greenColor];
        
        _contentView.backgroundColor = [UIColor clearColor];
        [self addSubview:_contentView];
        self.contentView = _contentView;
    }
    return self;
}

@end
