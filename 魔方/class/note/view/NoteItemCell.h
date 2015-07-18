//
//  NoteItemCell.h
//  3G学院
//
//  Created by coderss on 15/5/7.
//  Copyright (c) 2015年 coderss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteModel.h"
@interface NoteItemCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *noteTitle;
@property (weak, nonatomic) IBOutlet UIImageView *createrIcon;
@property (weak, nonatomic) IBOutlet UILabel *createrName;
@property (weak, nonatomic) IBOutlet UILabel *addtime;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property(nonatomic,strong)NoteModel *model;
@property (weak, nonatomic) IBOutlet UILabel *collnum;
@property (weak, nonatomic) IBOutlet UILabel *commnum;
+(instancetype)cellWithTableView:(UITableView *)tableView;
@end
