//
//  NoteDetailViewController.m
//  魔方
//
//  Created by coderss on 15/5/12.
//  Copyright (c) 2015年 coderss. All rights reserved.
//

#import "NoteDetailViewController.h"
#import "DetailNoteView.h"
#import "NoteModel.h"
#import "HeaderFile.h"
#import "ReplyVideoView.h"
#import "ReplyNoteCell.h"
#import "NoteReplyModel.h"


@interface NoteDetailViewController ()<UITextViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
{
    UIButton *icomment;
    UITextView *textView;
    //评论框的文本信息
    UITextView *contentText;
    
    //视图
    DetailNoteView *DnView;
}
@property(nonatomic,strong) NSMutableArray *replyComment;
@end

@implementation NoteDetailViewController

#pragma mark 懒加载
-(NSMutableArray *)replyComment{
    if (_replyComment==nil) {
        _replyComment=[NSMutableArray arrayWithCapacity:0];
    }
    return _replyComment;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title=@"笔记详情";
    
    DnView= [[DetailNoteView alloc]initWithFrame:self.view.bounds];
    
    //初始化界面
    UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithTitle:@"评论" style:UIBarButtonItemStyleDone target:self action:@selector(icommentClick)];
    self.navigationItem.rightBarButtonItem=item;
    //设置代理
    DnView.CommentListTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    DnView.CommentListTable.delegate=self;
    DnView.CommentListTable.dataSource=self;
    
    [DnView config:self.model];
    [self.view addSubview:DnView];
    
    //加载评论数据
    [self loadData:YES];
}
-(void)backBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)textViewDidChange:(UITextView *)textView1
{
    if (![textView1.text isEqualToString:@""]) {
        icomment.enabled = YES;
    }
    else
    {
        icomment.enabled = NO;
    }
}

/**
 *  评论消息框
 */
-(void)icommentClick
{
    NSString *islogin = [[NSUserDefaults standardUserDefaults] objectForKey:@"islogin"];
    if ([islogin isEqualToString:@"0"]) {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请先登录后再评论" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [av show];
    }
    else{
        if(!self.popup)
            self.popup = [KOPopupView popupView];
        
        UIView *replyView=[[[NSBundle mainBundle]loadNibNamed:@"NoteReplyView" owner:self options:nil]firstObject];
        [self.popup.handleView addSubview:replyView];
        //取出发送和退出按钮
        UIButton *send=(UIButton *)[replyView viewWithTag:401];
        UIButton *exit=(UIButton *)[replyView viewWithTag:402];
        contentText=[(UITextView *)replyView viewWithTag:403];
        contentText.delegate=self;
        
        //给发送和退出设置监听
        [send addTarget:self action:@selector(MyReplyClick:) forControlEvents:UIControlEventTouchUpInside];
        [exit addTarget:self action:@selector(MyReplyClick:) forControlEvents:UIControlEventTouchUpInside];
        
        replyView.center = CGPointMake(self.popup.handleView.frame.size.width/2.0,
                                            self.popup.handleView.frame.size.height/2.0-100);
        [self.popup show];
    }
}
-(void)MyReplyClick:(UIButton *)btn
{
    NSLog(@"隐藏");
    
    [self.popup hideAnimated:YES];
    
    if (btn.tag == 401) {
        NSLog(@"发送评论");
        [self submmitClick:contentText.text];
    }
    else
    {
        NSLog(@"取消");
    }
}
-(void)submmitClick:(NSString *)content
{
    NSUserDefaults *udf = [NSUserDefaults standardUserDefaults];
//    NSString *userid = [udf objectForKey:@"userid"];
    NSString *userid=@"97";
    NSDictionary *dic = @{@"uid":userid,@"nid":self.model.id,@"content":content};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFCompoundResponseSerializer serializer];
    [manager POST:NOTECOMMENT parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"提示" message:@"评论成功" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [av show];
        [self loadData:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

#pragma mark 加载评论数据
-(void)loadData:(BOOL)isRefresh{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager POST:[NSString stringWithFormat:NOTEMYCOMMENT,self.model.id] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil] isKindOfClass:[NSArray class]]) {
            NSArray *arr=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            if (isRefresh) {
                [self.replyComment removeAllObjects];
            }
            
            for (int i=0; i<arr.count; i++) {
                NSDictionary *dic=arr[i];
                
                NoteReplyModel *model=[[NoteReplyModel alloc]init];
                
                [model setValuesForKeysWithDictionary:dic];
                
                [self.replyComment addObject:model];
                
                [DnView.CommentListTable reloadData];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    
}

#pragma mark datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.replyComment.count;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ReplyNoteCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cellid"];
    if (!cell) {
        cell=[[[NSBundle mainBundle]loadNibNamed:@"ReplyNoteCell" owner:self options:nil]firstObject];;
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    NoteReplyModel *model=self.replyComment[indexPath.row];
    
    [cell configUI:model];
    
    return cell;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.popup hideAnimated:YES];
    [super touchesBegan:touches withEvent:event];
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100.0f;
}

#pragma mark TextView delegate
-(void)textViewDidBeginEditing:(UITextView *)textView{
    textView.text=@"";
}

@end
