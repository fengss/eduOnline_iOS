//
//  VideoPlayViewController.m
//  魔方
//
//  Created by coderss on 15/5/12.
//  Copyright (c) 2015年 coderss. All rights reserved.
//

#import "VideoPlayViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "HeaderFile.h"
#import "VideoDetail.h"
#import "VideoReplyModel.h"
#import "ReplyVideoView.h"
#import "VideoMenuCell.h"
#import "VideoReplyCell.h"
#import "NoteCreateViewController.h"

@interface VideoPlayViewController ()<UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>
{
    MPMoviePlayerController *playMovie;
    //点赞按钮
    UIButton *zanBtn;
    //收藏按钮
    UIButton *storeBtn;
}
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UIView * detailView;
@property(nonatomic,strong)UITableView * relativeCourseView;
@property(nonatomic,strong)UIButton *btn;
@property(nonatomic,strong)NSMutableArray *catalogueArray;
@property(nonatomic,strong)NSMutableArray *replyArray;
@property(nonatomic,assign)NSInteger whichVideo;
@property(nonatomic,assign)UITextView *myContentView;
@end
@implementation VideoPlayViewController
-(NSMutableArray *)catalogueArray
{
    if (_catalogueArray == nil) {
        _catalogueArray = [[NSMutableArray alloc]init];
    }
    return _catalogueArray;
}
-(UIView *)detailView
{
    if (_catalogueArray == nil)
    {
        return nil;
    }
    for(UIView *view in _detailView.subviews)
    {
        [view removeFromSuperview];
    }
    if (_detailView == nil) {
        _detailView = [[UIView alloc]init];
        _detailView.backgroundColor = [UIColor whiteColor];
        _detailView.frame = CGRectMake(10, 300, 320-20, self.view.bounds.size.height - 315);
    }
    VideoDetail *model = self.catalogueArray[self.whichVideo];
    NSString *str = model.descr;
    
    UILabel *content=[[UILabel alloc]initWithFrame:CGRectMake(5, 5, 100, 80)];
    content.text=str;
    [_detailView addSubview:content];
    
    
    return _detailView;
}
-(UIView *)relativeCourseView
{
    _relativeCourseView = [[UITableView alloc]init];
    _relativeCourseView.tag = 501;
    _relativeCourseView.delegate = self;
    _relativeCourseView.separatorStyle=UITableViewCellSeparatorStyleNone;
    _relativeCourseView.dataSource = self;
    _relativeCourseView.backgroundColor = [UIColor whiteColor];
    _relativeCourseView.frame = CGRectMake(10, 300, 320-20, self.view.bounds.size.height - 315);
    return _relativeCourseView;
}
-(UITableView *)tableView
{
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]init];
        _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
        _tableView.tag = 502;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.frame = CGRectMake(10, 300, 320-20, self.view.bounds.size.height - 315);
    }
    return _tableView;
}
-(NSArray *)titleArray
{
    if (_titleArray == nil) {
        _titleArray = @[@"目 录",@"详 情",@"评 论"];
    }
    return _titleArray;
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.whichVideo = 0 ;
    [self createMideoPlay];
    [self createSelectView];
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetWork:) name:@"videoDetail" object:nil];
    CheckNetworkManager  *networkManager = [CheckNetworkManager shareCheckNetworkManager];
    [networkManager checkNetWorkWithNotName:@"videoDetail"];
}

-(void)checkNetWork:(NSNotification *)not
{
    NSDictionary *dict = not.userInfo;
    NSString *isConnected = [dict valueForKey:@"infoForNetWork"];
    if ([isConnected isEqualToString:@"yes"]) {
        [self createProgressUI];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData:) name:@"testPaperData" object:nil];
        LoadDataManager *manager = [LoadDataManager shareLoadDataManager];
        NSString *str = [NSString stringWithFormat:@"%ld",self.whitchTypeVideo];
        NSString *url = [NSString stringWithFormat:VIDEODETAILURL,str,[[NSUserDefaults standardUserDefaults] objectForKey:@"userid"]];
        NSLog(@"*******%@",url);
        [manager loadDataWithURL:url WithNotname:@"testPaperData"];
    }
    else
    {
        UIAlertView  *av = [[UIAlertView alloc]initWithTitle:@"提 示" message:@"未检测到网络，请检查你的网络设置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
    }
}
-(void)loadData:(NSNotification *)not
{
    NSDictionary *dict = not.userInfo;
    NSArray *array = dict[@"items"];
    for (NSDictionary *d in array) {
        VideoDetail *model = [[VideoDetail alloc]init];
        [model setValuesForKeysWithDictionary:d];
        [self.catalogueArray addObject:model];
        [self.view addSubview:self.tableView];
    }
    NSLog(@"%@",self.catalogueArray);
    for(int i= 0 ; i < self.catalogueArray.count;i++)
    {
        VideoDetail *model = self.catalogueArray[i];
        NSLog(@"%@",model.name);
    }
    [ProgressHUD hideOnView:playMovie.view];
}
-(void)createProgressUI
{
    [ProgressHUD showOnView:playMovie.view];
}

-(void)navBackBtn
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)createMideoPlay
{
    self.strUrl = VIDEODETAILURL;
    MPMoviePlayerController *playVc = [[MPMoviePlayerController alloc]initWithContentURL:[NSURL URLWithString:@"http://www.coderss.cn/test1.mp4"]]   ;
    //playVc.view addSubview:
    playVc.view.frame = CGRectMake(10, 0, self.view.bounds.size.width - 20, 230);
    playVc.controlStyle = MPMovieControlStyleEmbedded;
    playVc.scalingMode = MPMovieScalingModeAspectFit;
    [playVc prepareToPlay];
    UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [playBtn setImage:[UIImage imageNamed:@"player"] forState:UIControlStateNormal];
    [playBtn addTarget:self action:@selector(playBtn:) forControlEvents:UIControlEventTouchUpInside];
    [playVc.view addSubview:playBtn];
    playBtn.frame = CGRectMake(125, 80, 50, 50);
    playMovie = playVc;
    [self.view addSubview:playVc.view];
    zanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    zanBtn.frame = CGRectMake(5, 230+10, 100, 20);
    CALayer *zanLayer = zanBtn.layer;
    zanLayer.borderColor = [UIColor blueColor].CGColor;
    zanLayer.borderWidth = 1.0;
    zanBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [zanBtn setTitle:@"点赞" forState:UIControlStateNormal];
     [zanBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    zanBtn.backgroundColor = [UIColor colorWithRed:196/255.0 green:239/255.0 blue:244/255.0 alpha:1];
    [zanBtn addTarget:self action:@selector(zanClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:zanBtn];
    
    UIButton *replyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    replyBtn.frame = CGRectMake(110, 230+10, 100, 20);
    CALayer *replyBtnLayer = replyBtn.layer;
    replyBtnLayer.borderWidth = 1.0;
    [replyBtn setTitle:@"评论" forState:UIControlStateNormal];
    replyBtnLayer.borderColor = [UIColor blueColor].CGColor;
    [replyBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    replyBtn.backgroundColor = [UIColor colorWithRed:196/255.0 green:239/255.0 blue:244/255.0 alpha:1];
    replyBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [replyBtn addTarget:self action:@selector(replyBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:replyBtn];
    
    storeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    storeBtn.frame = CGRectMake(215, 230+10, 100, 20);
    storeBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [storeBtn setTitle:@"收藏" forState:UIControlStateNormal];
    [storeBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    storeBtn.backgroundColor = [UIColor colorWithRed:196/255.0 green:239/255.0 blue:244/255.0 alpha:1];
    CALayer *storeBtnLayer = storeBtn.layer;
    storeBtnLayer.borderColor = [UIColor blueColor].CGColor;
    storeBtnLayer.borderWidth = 1.0;
    [storeBtn addTarget:self action:@selector(storeClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:storeBtn];
    
    /**
     *  创建笔记按钮
     *
     */
    UIBarButtonItem *createNoteBtn=[[UIBarButtonItem alloc]initWithTitle:@"创建笔记" style:UIBarButtonItemStyleDone target:self action:@selector(createNoteClick)];
    self.navigationItem.rightBarButtonItem=createNoteBtn;
}

/**
 *  创建笔记
 */
-(void)createNoteClick{
    NoteCreateViewController *notecreate=[[NoteCreateViewController alloc]initWithNibName:@"NoteCreateViewController" bundle:nil];
    VideoDetail *detail=self.catalogueArray[self.whichVideo];
    notecreate.vid=detail.id;
    [self.navigationController pushViewController:notecreate animated:YES];
}

-(void)zanClick:(UIButton*)btn{
    AppDelegate *app=[UIApplication sharedApplication].delegate;
    VideoDetail *model=[_catalogueArray objectAtIndex:self.whichVideo];
    
    
    NSDictionary *dic=@{
                            @"uid":[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"],
                            @"id":model.id
                        };
    [app.manger POST:VIDEOFAVO parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *str=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([str isEqual:@"yes"]) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提 示" message:@"点了个大赞" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            [btn setTitle:@"取消赞" forState:UIControlStateNormal];
            model.isZan=@"1";
        }
        else if ([str isEqual:@"no"]){
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提 示" message:@"取消了个大赞" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            [btn setTitle:@"赞" forState:UIControlStateNormal];
            model.isZan=@"0";
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
    
}

-(void)storeClick:(UIButton*)btn{
    AppDelegate *app=[UIApplication sharedApplication].delegate;
    VideoDetail *model=[_catalogueArray objectAtIndex:self.whichVideo];

    
    NSDictionary *dic=@{
                        @"uid":[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"],
                        @"id":model.id
                        };
    [app.manger POST:VIDEOCOLL parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *str=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        if ([str isEqual:@"yes"]) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提 示" message:@"点了个大收藏" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            [btn setTitle:@"取消收藏" forState:UIControlStateNormal];
            model.isCol=@"1";
        }
        else if ([str isEqual:@"no"]){
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提 示" message:@"取消了个大收藏" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            [btn setTitle:@"收藏" forState:UIControlStateNormal];
            model.isCol=@"0";
        }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];

}

-(void)replyBtnClick
{
    NSString *islogin = [[NSUserDefaults standardUserDefaults] objectForKey:@"islogin"];
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"userid"]) {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请先登录后再评论" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [av show];
    }
    else
    {
        UIView *view = [[UIView alloc]init];
        view.backgroundColor =[UIColor blackColor];
        view.alpha = 0.3;
        view.tag= 401;
        view.frame = self.view.bounds;
        [self.view addSubview:view];
        ReplyVideoView *replyView = [[NSBundle mainBundle]loadNibNamed:@"ReplyVideoView"  owner:nil options:nil][0];
        replyView.tag = 402;
        replyView.ReplyBtn.enabled = NO;
        replyView.ReplyBtn.tag = 400;
        [replyView.ReplyBtn addTarget:self action:@selector(MyReplyClick:) forControlEvents:UIControlEventTouchUpInside];
        [replyView.resignBtn addTarget:self action:@selector(MyReplyClick:) forControlEvents:UIControlEventTouchUpInside];
        replyView.resignBtn.tag = 403;
        _myContentView = replyView.ReplyContent;
        _myContentView.delegate = self;
        replyView.frame = CGRectMake(self.view.center.x - 100, 50, 200, 210);
        replyView.backgroundColor = [UIColor colorWithRed:196/255.0 green:239/255.0 blue:244/255.0 alpha:1];
        [self.view addSubview:replyView];
    }
    
}

-(void)textViewDidChange:(UITextView *)textView
{
    if (![textView.text isEqualToString:@""]) {
        UIButton *btn = (UIButton *)[self.view viewWithTag:400];
        btn.enabled = YES;
    }
    else
    {
        UIButton *btn = (UIButton *)[self.view viewWithTag:400];
        btn.enabled = NO;
    }
}

-(void)MyReplyClick:(UIButton *)btn
{
    if (btn.tag != 400 ) {
        UIView *view1 = [self.view viewWithTag:401];
        UIView *view2 = [self.view viewWithTag:402];
        [view2 endEditing:YES];
        [UIView animateWithDuration:1 animations:^{
            [view1 removeFromSuperview];
            [view2 removeFromSuperview];
        }];
    }
    else
    {
        //发送网络请求
        NSUserDefaults *udf = [NSUserDefaults standardUserDefaults];
        NSString *userid = [udf objectForKey:@"userid"];
        NSString *content = _myContentView.text;
        VideoDetail *model = self.catalogueArray[self.whichVideo];
        NSString *videoId = model.id;
        
        NSDictionary *dic = @{@"uid":userid,@"vid":videoId,@"content":content};
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        manager.responseSerializer = [AFCompoundResponseSerializer serializer];
        [manager POST:VIDEOCOMMENT parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            //刷新评论列表
            NSString *replyUrl = [VIDEOREPLY stringByAppendingString:[NSString stringWithFormat:@"%@",model.id]];
            [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadReplyData:) name:@"detailComment" object:nil];
            LoadDataManager *manager = [LoadDataManager shareLoadDataManager];
            [manager loadDataWithURL:replyUrl WithNotname:@"detailComment"];
            
            
            UIView *view1 = [self.view viewWithTag:401];
            UIView *view2 = [self.view viewWithTag:402];
            [view2 endEditing:YES];
            [UIView animateWithDuration:1 animations:^{
                [view1 removeFromSuperview];
                [view2 removeFromSuperview];
            }];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        }];
    }
}
-(void)playBtn:(UIButton *)btn
{
    
    NSString *tid = [NSString stringWithFormat:@"%ld",self.whitchTypeVideo];
    VideoDetail *detail = self.catalogueArray[self.whichVideo];
    
    NSLog(@"视频文件名%@",detail.videoname);
    NSLog(@"视频文件名",detail.name);
    NSDictionary *dict = @{@"tid":tid ,@"id":detail.id};
    NSLog(@"%@",dict);
    btn.hidden = YES;
    //开始网络请求
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFCompoundResponseSerializer serializer];
    [manager POST:VIDEOONLYURL parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id jsonData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    [playMovie play];
}
-(void)createSelectView
{
    UIView *btnBgview = [[UIView alloc]initWithFrame:CGRectMake(0, 270, self.view.bounds.size.width, 20)];
    btnBgview.backgroundColor = [UIColor colorWithRed:196/255.0 green:239/255.0 blue:244/255.0 alpha:1];
    [self.view addSubview:btnBgview];
    for(int i = 0 ; i < self.titleArray.count;i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:self.titleArray[i] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blueColor] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
        btn.frame = CGRectMake((self.view.bounds.size.width / 3)* i, 0, self.view.bounds.size.width / 3, 25);
        btn.tag = 100+i;
        NSLog(@"%ld",btn.tag);
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchDown];
        if (i == 0 ) {
            btn.selected = YES;
            self.btn = btn;
        }
        [btnBgview addSubview:btn];
    }
}
-(void)btnClick:(UIButton *)btn
{
    self.btn.selected = NO;
    btn.selected = YES;
    self.btn = btn;
    if (btn.tag == 100) {
        [self.view addSubview:self.tableView];
    }
    if (btn.tag == 101) {
        [self.view addSubview:self.detailView];
    }
    if (btn.tag == 102) {
        
        VideoDetail *model = self.catalogueArray[self.whichVideo];
        NSString *replyUrl = [VIDEOREPLY stringByAppendingString:[NSString stringWithFormat:@"%@",model.id]];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadReplyData:) name:@"detailComment" object:nil];
        LoadDataManager *manager = [LoadDataManager shareLoadDataManager];
        [manager loadDataWithURL:replyUrl WithNotname:@"detailComment"];
    }
}
-(void)loadReplyData:(NSNotification *)not
{
    _replyArray = [[NSMutableArray alloc]init];
    NSDictionary *dic = not.userInfo;
    NSArray *array = dic[@"items"];
    for(NSDictionary * d in array)
    {
        VideoReplyModel *model = [[VideoReplyModel alloc]init];
        [model setValuesForKeysWithDictionary:d];
        [_replyArray addObject:model];
    }
    [self.view addSubview:self.relativeCourseView];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView.tag == 502) {
        return self.catalogueArray.count;
    }
    else
    {
        return _replyArray.count;
    }
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 502) {
        static NSString  *cellid = @"cell";
        VideoMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (cell == nil) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"VideoMenuCell" owner:self options:nil]firstObject];
        }
        VideoDetail *detail = self.catalogueArray[indexPath.row];
        [cell configUI:detail];
        return cell;
    }
    else
    {
        static NSString  *cellid = @"cell1";
        VideoReplyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle]loadNibNamed:@"VideoReplyCell" owner:self options:nil]firstObject];;
        }
        VideoReplyModel *model = self.replyArray[indexPath.row];
        [cell configUI:model];
        return cell;
        
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.whichVideo = indexPath.row;
    VideoDetail *model = self.catalogueArray[indexPath.row];
    int tempZan=[model.isZan intValue];
    int tempCol=[model.isCol intValue];
    if (tempZan!=0) {
        [zanBtn setTitle:@"取消赞" forState:UIControlStateNormal];
    }
    else{
        [zanBtn setTitle:@"赞" forState:UIControlStateNormal];
    }
    if (tempCol!=0) {
        [storeBtn setTitle:@"取消收藏" forState:UIControlStateNormal];
    }
    else{
        [storeBtn setTitle:@"收藏" forState:UIControlStateNormal];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60.0f;
}
@end