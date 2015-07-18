//
//  Mykit.h
//  3G学院
//
//  Created by coderss on 15/5/2.
//  Copyright (c) 2015年 coderss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface MyKit : NSObject
+(UIImageView *)createImageWithFrame:(CGRect)rect WithImage:(UIImage *)image;
+(UIButton *)createBtnFrame:(CGRect)frame title:(NSString *)title target:(id)target action:(SEL)action;
+(UILabel *)createLabel:(CGRect)rect WithFont:(UIFont*)font;
+(UITextField *)createTextField:(CGRect)rect WithFont:(UIFont *)font;
+(UIView *)createUIView:(CGRect)rect WithColor:(UIColor *)color;
@end
