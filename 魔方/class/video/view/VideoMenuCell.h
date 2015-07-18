//
//  VideoMenuCell.h
//  魔方
//
//  Created by fengss on 15-5-14.
//  Copyright (c) 2015年 coderss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoDetail.h"

@interface VideoMenuCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *content;

-(void)configUI:(VideoDetail*)detail;
@end
