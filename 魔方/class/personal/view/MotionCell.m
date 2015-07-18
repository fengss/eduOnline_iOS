//
//  MotionCell.m
//  魔方
//
//  Created by 沈伟 on 15/5/14.
//  Copyright (c) 2015年 coderss. All rights reserved.
//

#import "MotionCell.h"

@implementation MotionCell

- (void)awakeFromNib {
    self.iconimageview.layer.masksToBounds=YES;
    self.iconimageview.layer.cornerRadius=25.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(void)configUI:(MotionModel *)model{
    self.username.text=model.myname;
    self.content.text=model.content;
    self.addtime.text=model.addtime;
    [self.iconimageview setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:USERICO,model.myname,model.upic]]];
}

@end
