

//
//  NoteTableView.m
//  3G学院
//
//  Created by coderss on 15/5/7.
//  Copyright (c) 2015年 coderss. All rights reserved.
//

#import "NoteTableView.h"
#import "NoteModel.h"
#import "HeaderFile.h"
#import "NoteItemCell.h"
@interface NoteTableView()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)NSMutableArray * noteItemArray;
@property(nonatomic,strong)UITableView *tableView;
@end
@implementation NoteTableView
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor orangeColor];
        [self createLabel];
        NSString * networkNetWork = @"noteReading";
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetWork:) name:networkNetWork object:nil];
        CheckNetworkManager *networkManager = [CheckNetworkManager shareCheckNetworkManager];
        [networkManager checkNetWorkWithNotName:networkNetWork];
    }
    return self;
}
-(void)checkNetWork:(NSNotification *)not
{
    NSDictionary *dict =not.userInfo;
    NSString *isConnected  = [dict valueForKey:@"infoForNetWork"];
    if ([isConnected isEqualToString:@"yes"]) {
       [ProgressHUD showOnView:self];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadData:) name:@"note" object:nil];
        LoadDataManager  *manager = [LoadDataManager shareLoadDataManager];
        NSString *url = NOTEALLURL;
        [manager loadDataWithURL:url WithNotname:@"note"];
    }
    else
    {
        UIAlertView  *av = [[UIAlertView alloc]initWithTitle:@"提 示" message:@"未检测到网络，请检查你的网络设置" delegate:nil cancelButtonTitle:@"确 定" otherButtonTitles:nil, nil];
        [av show];
    }
}
-(void)loadData:(NSNotification *)not
{
    NSDictionary *dict = not.userInfo;
    NSArray *array = dict[@"items"];
    NSMutableArray *itemArray = [[NSMutableArray alloc]init];
    for(NSDictionary *d in array)
    {
        NoteModel *model = [[NoteModel alloc]init];
        [model setValuesForKeysWithDictionary:d];
        [itemArray addObject:model];
    }
    self.noteItemArray = itemArray;
    [self createTableView];
    [ProgressHUD hideAfterSuccessOnView:self];
}
-(void)createLabel
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    label.backgroundColor = [UIColor orangeColor];
    label.text = @"精彩笔记推荐";
    label.textColor = [UIColor greenColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:20];
    [self addSubview:label];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame= CGRectMake(SCREEN_WIDTH - 100,0 ,100, 60);
    [btn setTitle:@"我的笔记" forState:UIControlStateNormal];
    [self addSubview:btn];
    [btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];
}
-(void)btnClick
{
     NSString *islogin = [[NSUserDefaults standardUserDefaults] objectForKey:@"islogin"];
    if ([islogin isEqualToString:@"0"]) {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请先登录,才能进入我的笔记" delegate:self cancelButtonTitle:@"好的" otherButtonTitles:nil, nil];
        [av show];
    }
    else
    {
       self.myblock();   
    }
}
-(void)createTableView
{
    UITableView *table = [[UITableView alloc]initWithFrame:CGRectMake(10, 70, self.bounds.size.width,SCREEN_HEIGHT) style:UITableViewStylePlain];
    table.delegate = self;
    table.dataSource = self;
    self.tableView = table;
    [self addSubview:table];
    
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.noteItemArray.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NoteItemCell *cell = [NoteItemCell cellWithTableView:tableView];
    NoteModel *model = self.noteItemArray[indexPath.row];
    [cell setModel:model];
    return cell;
}
-(void)layoutSubviews
{
    [super layoutSubviews];
     self.tableView.frame = CGRectMake(10, 70, self.bounds.size.width - 20,self.bounds.size.height-70);
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NoteModel *model = self.noteItemArray[indexPath.row];
    self.DetailNoteblock(model);
}
@end
