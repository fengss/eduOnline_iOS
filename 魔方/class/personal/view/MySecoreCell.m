//
//  MySecoreCell.m
//  魔方
//
//  Created by fengss on 15-5-15.
//  Copyright (c) 2015年 coderss. All rights reserved.
//

#import "MySecoreCell.h"

@implementation MySecoreCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(void)configUI:(SecoreModel *)model{
    self.title.text=model.title;
    self.score.text=[NSString stringWithFormat:@"成绩:%@",model.score];
    self.addtime.text=model.time;
}

@end
