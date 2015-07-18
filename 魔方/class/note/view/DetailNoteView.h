//
//  DetailNoteView.h
//  3G学院
//
//  Created by coderss on 15/5/8.
//  Copyright (c) 2015年 coderss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteModel.h"
@interface DetailNoteView : UIView
@property (weak, nonatomic) IBOutlet UIButton *backBtn;

@property (weak, nonatomic) IBOutlet UILabel *createrName;
@property (weak, nonatomic) IBOutlet UIButton *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *likeNumber;
@property (weak, nonatomic) IBOutlet UILabel *collectNumber;
@property (weak, nonatomic) IBOutlet UITableView *CommentListTable;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *icomment;
- (IBAction)sc:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *timeLable;
- (IBAction)zan:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *title;
-(void)config:(NoteModel *)model;
@property (weak, nonatomic) IBOutlet UIButton *zanBtn;
@property (weak, nonatomic) IBOutlet UIButton *scBtn;

@property(nonatomic,strong) UITableView  * tableView;

@property(nonatomic,strong) NoteModel  * model;
@end
