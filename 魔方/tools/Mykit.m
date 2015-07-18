//
//  Mykit.m
//  3G学院
//
//  Created by coderss on 15/5/2.
//  Copyright (c) 2015年 coderss. All rights reserved.
//

#import "Mykit.h"

@implementation MyKit
+(UIImageView *)createImageWithFrame:(CGRect)rect WithImage:(UIImage *)image
{
    UIImageView *imagev=[[UIImageView alloc]initWithFrame:rect];
    imagev.image=image;
    return imagev;
}
+(UIButton *)createBtnFrame:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)action
{
    UIButton *btn=[UIButton buttonWithType:UIButtonTypeSystem];
    [btn setTitle:title forState:UIControlStateNormal];
    btn.frame=frame;
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
+(UILabel *)createLabel:(CGRect)rect WithFont:(UIFont *)font
{
    UILabel *label=[[UILabel alloc]initWithFrame:rect];
    label.font=font;
    return label;
}
+(UITextField *)createTextField:(CGRect)rect WithFont:(UIFont *)font
{
    UITextField *tf=[[UITextField alloc]initWithFrame:rect];
    tf.font=font;
    return tf;
}
+(UIView *)createUIView:(CGRect)rect WithColor:(UIColor *)color
{
    UIView *v=[[UIView alloc]initWithFrame:rect];
    v.backgroundColor=color;
    return v;
}
@end

