//
//  MyNoteCell.m
//  魔方
//
//  Created by fengss on 15-5-13.
//  Copyright (c) 2015年 coderss. All rights reserved.
//

#import "MyNoteCell.h"

@implementation MyNoteCell

-(void)awakeFromNib{
    self.icoImageView.layer.masksToBounds=YES;
    self.icoImageView.layer.cornerRadius=20.0f;
}

-(void)configUI:(NoteModel *)note{
    self.content.text=note.content;
    self.userName.text=note.username;
    [self.icoImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:USERICO,note.username,note.picture]] placeholderImage:[UIImage imageNamed:@"IconProfile"]];
}

@end
