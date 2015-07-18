//
//  VideoReplyCell.m
//  魔方
//
//  Created by fengss on 15-5-14.
//  Copyright (c) 2015年 coderss. All rights reserved.
//

#import "VideoReplyCell.h"

@implementation VideoReplyCell

- (void)awakeFromNib {
    self.iconimageView.layer.cornerRadius=23.0f;
    self.iconimageView.layer.masksToBounds=YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}

-(void)configUI:(VideoReplyModel *)model{
    [self.iconimageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:USERICO,model.username,model.picture]]];
    self.username.text=model.username;
    self.content.text=model.content;
    self.addtime.text=model.addtime;
}

@end
