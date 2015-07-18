//
//  DEMOSecondViewController.m
//  RESideMenuExample
//
//  Created by Roman Efimov on 10/10/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "NoteViewController.h"
#import "HeaderFile.h"
#import "NoteModel.h"
#import "NoteItemCell.h"
#import "NoteDetailViewController.h"
#import "MyNoteViewController.h"

@interface NoteViewController()<UITableViewDataSource,UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    MJRefreshHeaderView *header;
    MJRefreshFooterView *footer;
    //判断是否为刷新
    BOOL isRefresh;
    //目前页码
    int pageNum;
    //最大页码
    int maxNum;
}
@property(nonatomic,strong)NSMutableArray *noteItemArray;
@property(nonatomic,strong)UITableView *tableView;
@end
@implementation NoteViewController

//懒加载
-(NSMutableArray *)noteItemArray{
    if (_noteItemArray==nil) {
        _noteItemArray=[NSMutableArray arrayWithCapacity:0];
    }
    return _noteItemArray;
}

//refresh
-(void)createRefresh{
    header=[MJRefreshHeaderView header];
    header.scrollView=self.tableView;
    header.delegate=self;
    
    footer=[MJRefreshFooterView footer];
    footer.scrollView=self.tableView;
    footer.delegate=self;
}
-(void)removeRefresh{
    header.scrollView=nil;
    footer.scrollView=nil;
    [header removeFromSuperview];
    [footer removeFromSuperview];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
	self.title = @"学习笔记";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu_left"] style:UIBarButtonItemStylePlain target:self action:@selector(presentLeftMenuViewController:)];
    
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame= CGRectMake(SCREEN_WIDTH - 100,0 ,100, 60);
    [btn setTitle:@"我的笔记" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(pushViewController:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithCustomView:btn];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu_right"]  style:UIBarButtonItemStylePlain target:self action:@selector(presentRightMenuViewController:)];

    self.navigationItem.rightBarButtonItems = @[item2,item1];
    NSString * networkNetWork = @"noteReading";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetWork:) name:networkNetWork object:nil];
    CheckNetworkManager *networkManager = [CheckNetworkManager shareCheckNetworkManager];
    [networkManager checkNetWorkWithNotName:networkNetWork];
    
    [self createTableView];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //创建下拉上拉
    [self createRefresh];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self removeRefresh];
}

-(void)checkNetWork:(NSNotification *)not
{
    NSDictionary *dict =not.userInfo;
    NSString *isConnected  = [dict valueForKey:@"infoForNetWork"];
    if ([isConnected isEqualToString:@"yes"]) {
        [ProgressHUD showOnView:self.view];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadData:) name:@"note" object:nil];
        LoadDataManager  *manager = [LoadDataManager shareLoadDataManager];
        NSString *url = [NOTEALLURL stringByAppendingString:[NSString stringWithFormat:@"&myuid=%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"]]];
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
    
    //如果下拉刷新删除数组元素
    if (isRefresh) {
        [self.noteItemArray removeAllObjects];
    }
    
    for(NSDictionary *d in array)
    {
        NoteModel *model = [[NoteModel alloc]init];
        NSLog(@"%@",d);
        [model setValuesForKeysWithDictionary:d];
        maxNum=[model.maxNum intValue];
        [self.noteItemArray addObject:model];
    }
    [self.tableView reloadData];
    
    [ProgressHUD hideAfterSuccessOnView:self.view];
}

-(void)createTableView
{
    self.navigationController.navigationBar.translucent=NO;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width,SCREEN_HEIGHT-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    
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

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 110.0f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NoteModel *model = self.noteItemArray[indexPath.row];
    NoteDetailViewController *ctrl = [[NoteDetailViewController alloc]init];
    ctrl.model = model;
    NSLog(@"%p %p",model,ctrl.model);
    [self.navigationController pushViewController:ctrl animated:YES];
}

/**
 *  跳转我的笔记页面
 *
 *  @param sender
 */
- (void)pushViewController:(id)sender
{
    MyNoteViewController *viewController = [[MyNoteViewController alloc] init];
    viewController.title = @"我的笔记";
    viewController.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:viewController animated:YES];
}


#pragma mark refresh delegate
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView{

    if (refreshView==header) {
        isRefresh=YES;
        pageNum=0;
    }
    else{
        if (maxNum!=0&&pageNum>=maxNum) {
            [refreshView endRefreshing];
            return;
        }
        
        isRefresh=NO;
        pageNum++;
    }
    
    LoadDataManager  *manager = [LoadDataManager shareLoadDataManager];
    NSString *url = [NOTEALLURL stringByAppendingString:[NSString stringWithFormat:@"&myuid=%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"]]];
    NSString *newurl=[url stringByAppendingString:[NSString stringWithFormat:@"&page=%d",pageNum]];
    NSLog(@"url %@",newurl);
    
    
    [manager loadDataWithURL:newurl WithNotname:@"note"];
    
    [refreshView endRefreshing];
}

@end
