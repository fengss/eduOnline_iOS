//
//  NoteItemCell.m
//  3G学院
//
//  Created by coderss on 15/5/7.
//  Copyright (c) 2015年 coderss. All rights reserved.
//

#import "NoteItemCell.h"
/*
 @property (weak, nonatomic) IBOutlet UILabel *noteTitle;
 @property (weak, nonatomic) IBOutlet UIImageView *createrIcon;
 @property (weak, nonatomic) IBOutlet UILabel *createrName;
 @property (weak, nonatomic) IBOutlet UILabel *addtime;
 @property (weak, nonatomic) IBOutlet UILabel *content;
 */
@implementation NoteItemCell
+(instancetype)cellWithTableView:(UITableView *)tableView
{
    NSString *cellId = @"cellId";
    NoteItemCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[NSBundle mainBundle] loadNibNamed:@"NoteItemCell" owner:nil options:nil][0];
    }
    return cell;
}
-(void)setModel:(NoteModel *)model
{
    self.createrIcon.layer.masksToBounds=YES;
    self.createrIcon.layer.cornerRadius=8.0f;
    self.noteTitle.text = model.title;
    self.createrName.text =[NSString stringWithFormat:@"来自:%@",model.username];
    //计算时间
    [Util calculateTimeWithTimeUpload:model.addtime label:self.addtime];
    self.content.text = model.content;
    self.collnum.text = [NSString stringWithFormat:@"%@人收藏",model.collnum];
    self.commnum.text = [NSString stringWithFormat:@"%@人回复",model.commnum];
    [self.createrIcon setImage:[UIImage imageNamed:@"account_candou"]];
    [self.createrIcon setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:USERICO,model.username,model.picture]] placeholderImage:[UIImage imageNamed:@"ProgressHUD_image"]];
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
}
@end
