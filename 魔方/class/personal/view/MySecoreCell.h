//
//  MySecoreCell.h
//  魔方
//
//  Created by fengss on 15-5-15.
//  Copyright (c) 2015年 coderss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SecoreModel.h"

@interface MySecoreCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *score;
@property (weak, nonatomic) IBOutlet UILabel *addtime;

-(void)configUI:(SecoreModel*)model;
@end
