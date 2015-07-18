
//
//  DetailNoteView.m
//  3G学院
//
//  Created by coderss on 15/5/8.
//  Copyright (c) 2015年 coderss. All rights reserved.
//
/*
 @property (weak, nonatomic) IBOutlet UILabel *createrName;
 @property (weak, nonatomic) IBOutlet UIButton *userIcon;
 @property (weak, nonatomic) IBOutlet UITextView *content;
 @property (weak, nonatomic) IBOutlet UILabel *likeNumber;
 @property (weak, nonatomic) IBOutlet UILabel *collectNumber;
 @property (weak, nonatomic) IBOutlet UITableView *CommentListTable;
 @property (weak, nonatomic) IBOutlet UITextView *mycomment;
 @property (weak, nonatomic) IBOutlet UIButton *submmit;
 */
#import "DetailNoteView.h"
#import "HeaderFile.h"
@implementation DetailNoteView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"DetailNoteView" owner:nil options:nil][0];
    }
    return self;
}
-(void)config:(NoteModel *)model
{
    NSLog(@"赞的数量%@,收藏的数量:%@ %p",model.isZan,model.isColl,model);
    if ([model.isZan intValue]==0) {
        [self.zanBtn setTitle:@"赞" forState:UIControlStateNormal];
    }
    else{
        [self.zanBtn setTitle:@"取消赞" forState:UIControlStateNormal];
    }
    
    if([model.isColl intValue]==0) {
        [self.scBtn setTitle:@"收藏" forState:UIControlStateNormal];
    }
    else{
        [self.scBtn setTitle:@"取消收藏" forState:UIControlStateNormal];
    }
    
    self.model=model;
    self.bgView.layer.masksToBounds=YES;
    self.bgView.layer.cornerRadius=15.0f;
    self.userIcon.layer.masksToBounds=YES;
    self.userIcon.layer.cornerRadius=24.0f;
    [self.userIcon setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:USERICO,model.username,model.picture]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"ProgressHUD_image"]];
    self.createrName.text = [NSString stringWithFormat:@"作者:%@",model.username];
    self.content.contentMode=UIViewContentModeTopLeft;
    self.content.text = model.content;
    self.likeNumber.text = [NSString stringWithFormat:@"%@赞",model.zanNum];
    self.collectNumber.text = [NSString stringWithFormat:@"%@收藏",model.collnum];
    self.timeLable.text = model.addtime;
    self.title.text = model.title;
}
- (IBAction)zan:(id)sender {
    [self zanOrSc:YES];
}
- (IBAction)sc:(id)sender {
    [self zanOrSc:NO];
}

#pragma mark 点赞和收藏
-(void)zanOrSc:(BOOL)zan{
    AppDelegate *app=[UIApplication sharedApplication].delegate;
    NSDictionary *dic=@{
                        @"uid":@"97",
                        @"id":self.model.id
                        };
    NSString *strUrl;
    if (zan) {
        strUrl=NOTEFAVO;
    }
    else{
        strUrl=NOTESC;
    }
    
    
    [app.manger POST:strUrl parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *str=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        if ([str isEqualToString:@"yes"]) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提 示" message:@"操作成功" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            if (zan) {
                if ([[self.zanBtn currentTitle] isEqualToString:@"赞"]) {
                    [self.zanBtn setTitle:@"取消赞" forState:UIControlStateNormal];
                    
                    int num=[Util returnNumberFormString:self.likeNumber.text];
                    NSLog(@"一共赞数量:%d",num);
                    
                    self.likeNumber.text=[NSString stringWithFormat:@"%d赞",++num];
                    self.model.isZan=@"1";
                    
                }
                else{
                    [self.zanBtn setTitle:@"赞" forState:UIControlStateNormal];
                    int num=[Util returnNumberFormString:self.likeNumber.text];
                    self.likeNumber.text=[NSString stringWithFormat:@"%d赞",--num];
                    self.model.isZan=@"0";
                }
            }
            else{
                if ([[self.scBtn currentTitle] isEqualToString:@"收藏"]) {
                    [self.scBtn setTitle:@"取消收藏" forState:UIControlStateNormal];
                    int num=[Util returnNumberFormString:self.collectNumber.text];
                    self.collectNumber.text=[NSString stringWithFormat:@"%d收藏",++num];
                    self.model.isColl=@"1";
                }
                else{
                    [self.scBtn setTitle:@"收藏" forState:UIControlStateNormal];
                    int num=[Util returnNumberFormString:self.collectNumber.text];
                    self.collectNumber.text=[NSString stringWithFormat:@"%d收藏",--num];
                    self.model.isColl=@"0";
                }
            }
        }
        else{
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提 示" message:@"操作失败" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
@end
