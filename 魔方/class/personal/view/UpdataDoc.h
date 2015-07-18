//
//  UpdataDoc.h
//  魔方
//
//  Created by fengss on 15-5-14.
//  Copyright (c) 2015年 coderss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpdataDoc : UIView
@property (weak, nonatomic) IBOutlet UITextField *username;
- (IBAction)save:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *age;
@property (weak, nonatomic) IBOutlet UITextView *desc;
@property (weak, nonatomic) IBOutlet UITextField *myId;
@property (weak, nonatomic) IBOutlet UIButton *chosePic;
@property (weak, nonatomic) IBOutlet UIButton *upPic;
@property (weak, nonatomic) IBOutlet UIImageView *avatorImageView;
@property(weak,nonatomic) UIViewController *mainVc;
- (IBAction)chose:(id)sender;
- (IBAction)Up:(id)sender;

@end
