//
//  UserLand1.h
//  3G学院
//
//  Created by coderss on 15/5/2.
//  Copyright (c) 2015年 coderss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserLand1 : UIView
@property(nonatomic,copy)void(^block)(NSInteger );
@property (weak, nonatomic) IBOutlet UITextField *nameFiled;
@property (weak, nonatomic) IBOutlet UITextField *passwdFiled;
- (IBAction)loadClick:(id)sender;
- (IBAction)registerClick:(id)sender;
@property(nonatomic,copy)void(^backblock)();
@property (weak, nonatomic) IBOutlet UIButton *userLogin;
@property (weak, nonatomic) IBOutlet UIButton *userRegister;
@property(nonatomic,copy)void(^navBlock)();
@end
