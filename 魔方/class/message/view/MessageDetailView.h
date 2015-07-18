//
//  MessageDetailView.h
//  3G学院
//
//  Created by coderss on 15/5/9.
//  Copyright (c) 2015年 coderss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"
@interface MessageDetailView : UIView<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *addtime;
@property (weak, nonatomic) IBOutlet UILabel *desc;
@property (weak, nonatomic) IBOutlet UILabel *scan;
@property (weak, nonatomic) IBOutlet UILabel *createrLabel;

@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIButton *icomment;
- (IBAction)iCommentClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIButton *collectBtn;
-(void)config:(Message *) model;
@property (weak, nonatomic) IBOutlet UITableView *commentTableView;

@property(strong,nonatomic) NSMutableArray *commentArray;
@end
