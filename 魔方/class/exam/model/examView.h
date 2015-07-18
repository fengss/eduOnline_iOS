//
//  examView.h
//  3G学院
//
//  Created by coderss on 15/4/29.
//  Copyright (c) 2015年 coderss. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "TestModel.h"
@interface examView : UIView
@property(nonatomic,strong)UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UILabel *anwer1;
@property (weak, nonatomic) IBOutlet UILabel *answer2;
@property (weak, nonatomic) IBOutlet UILabel *answer3;
@property (weak, nonatomic) IBOutlet UILabel *answer4;
@property (weak, nonatomic) IBOutlet UILabel *indexLabel;
@property (weak, nonatomic) IBOutlet UILabel *examContent;

@property (weak, nonatomic) IBOutlet UIButton *aBtn;
@property (weak, nonatomic) IBOutlet UIButton *bBtn;
@property (weak, nonatomic) IBOutlet UIButton *cBtn;
@property (weak, nonatomic) IBOutlet UIButton *dBtn;

- (IBAction)aBtnClick:(UIButton *)sender1;
- (IBAction)bBtnClick:(UIButton *)sender2;
- (IBAction)cBtnClick:(UIButton *)sender3;
- (IBAction)dBtnClick:(UIButton *)sender4;
-(void)config:(TestModel *)model;
@end

