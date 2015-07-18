//
//  MotionCell.h
//  魔方
//
//  Created by 沈伟 on 15/5/14.
//  Copyright (c) 2015年 coderss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MotionModel.h"

@interface MotionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconimageview;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *addtime;

-(void)configUI:(MotionModel*)model;
@end
