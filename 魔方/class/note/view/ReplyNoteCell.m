//
//  ReplyNoteCell.m
//  魔方
//
//  Created by fengss on 15-5-13.
//  Copyright (c) 2015年 coderss. All rights reserved.
//

#import "ReplyNoteCell.h"

@implementation ReplyNoteCell

- (void)awakeFromNib {
    self.bgView.layer.masksToBounds=YES;
    self.bgView.layer.cornerRadius=15.0f;
    self.icon.layer.masksToBounds=YES;
    self.icon.layer.cornerRadius=23.0f;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)configUI:(NoteReplyModel *)model{
    [self.icon setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:USERICO,model.username,model.picture]]];
    self.username.text=model.username;
    self.content.text=model.content;
    self.time.text=model.addtime;
}

@end
