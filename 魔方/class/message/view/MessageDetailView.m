//
//  MessageDetailView.m
//  3G学院
//
//  Created by coderss on 15/5/9.
//  Copyright (c) 2015年 coderss. All rights reserved.
//

#import "MessageDetailView.h"
#import "ReplyVideoView.h"
#import "MessageReplyModel.h"
#import "MessageReplyCell.h"

@implementation MessageDetailView

-(NSMutableArray *)commentArray{
    if (_commentArray==nil) {
        _commentArray=[NSMutableArray arrayWithCapacity:0];
    }
    return _commentArray;
}

-(void)config:(Message *)model
{
    self.content.layer.cornerRadius=18.0f;
    self.content.layer.masksToBounds=YES;
    
    self.titleLabel.text= [NSString stringWithFormat:@"标题:%@",model.title];
    self.createrLabel.text = [NSString stringWithFormat:@"发帖人:%@",model.username];
    self.addtime.text = model.addtime;
    self.desc.text = model.keyword;
    self.scan.text = model.scan;
    self.content.text = model.content;
    self.commentTableView.delegate=self;
    self.commentTableView.dataSource=self;
    
    [self loadData:model.id];
}

-(void)loadData:(NSString *)urlid{
    AppDelegate *app=[UIApplication sharedApplication].delegate;
    [app.manger GET:[NSString stringWithFormat:@"http://edu.coderss.cn/index.php/Message/showForIos/id/%@",urlid] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            NSArray *tempArr=[dic objectForKey:@"comment"];
            
            if (![tempArr isKindOfClass:[NSNull class]]) {
                for (NSDictionary *mydic in tempArr) {
                    MessageReplyModel *model=[[MessageReplyModel alloc]init];
                    [model setValuesForKeysWithDictionary:mydic];
                    
                    [self.commentArray addObject:model];
                }
            }
            
            
            [self.commentTableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

#pragma mark datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.commentArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageReplyCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cellid"];
    if (!cell) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"MessageReplyCell" owner:self options:nil]firstObject];
    }
    
    MessageReplyModel *model=self.commentArray[indexPath.row];
    cell.textLabel.text=model.content;
    
    return cell;
}




- (IBAction)iCommentClick:(id)sender {

}
@end
