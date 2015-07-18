//
//  VideoMenuCell.m
//  魔方
//
//  Created by fengss on 15-5-14.
//  Copyright (c) 2015年 coderss. All rights reserved.
//

#import "VideoMenuCell.h"

@implementation VideoMenuCell

- (void)awakeFromNib {
    self.iconImageView.layer.masksToBounds=YES;
    self.iconImageView.layer.cornerRadius=20.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

-(void)configUI:(VideoDetail *)detail{
    [self.iconImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:VIDEOPIC,detail.picname]]];
    self.title.text=detail.videoname;
    self.content.text=detail.descr;
}

@end
