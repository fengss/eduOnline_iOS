//
//  ReplyNoteCell.h
//  魔方
//
//  Created by fengss on 15-5-13.
//  Copyright (c) 2015年 coderss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteReplyModel.h"

@interface ReplyNoteCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *username;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UIView *bgView;


-(void)configUI:(NoteReplyModel*)model;
@end
