//
//  AMLoginViewController.h
//  魔方
//
//  Created by coderss on 15/5/13.
//  Copyright (c) 2015年 coderss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@protocol LoginDelegate
/**
 *  更新前台
 *
 *  @param  其他附带信息 dic
 */
-(void)loginSuccessUpdate:(NSDictionary *)dic;

@end

@interface AMLoginViewController : UIViewController<UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIView *usernameView;
@property (strong, nonatomic) UIView *passwordView;
@property (strong, nonatomic) UIView *sendButtonView;

@property(nonatomic,assign) id<LoginDelegate> delegate;
@end
