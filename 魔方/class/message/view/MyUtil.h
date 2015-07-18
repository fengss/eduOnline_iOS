//
//  MyUtil.h
//  掌厨
//
//  Created by coderss on 15/5/7.
//  Copyright (c) 2015年 coderss. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface MyUtil : NSObject
//创建UILabel
+(UILabel *)createLabelFrame:(CGRect) frame title:(NSString *)title font:(UIFont *)font;
//创建UIImageView
+(UIImageView *)createImageView:(CGRect) frame imageName:(NSString *)imageName;
//按钮
+(UIButton *)createBtnFrame:(CGRect) frame image:(NSString *)image selectImage:(NSString *) selectImageName highlightImage:(NSString *)highlightImage target:(id)target action:(SEL) action;
+(UITextField *)createTextFieldFrame:(CGRect) frame placeHolder:(NSString *)placeHolder isPwd:(BOOL) isPwd;
@end
