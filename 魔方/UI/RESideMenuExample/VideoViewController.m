//
//  DEMOFirstViewController.m
//  RESideMenuExample
//
//  Created by Roman Efimov on 10/10/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "VideoViewController.h"
#import "HeaderFile.h"
#import "VideoItemModel.h"
#import "VideoCell.h"
#import "VideoPlayViewController.h"
@interface VideoViewController ()<UITableViewDelegate,UITableViewDataSource>
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation VideoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	self.title = @"教学视频";
    self.navigationController.navigationBar.barTintColor=[UIColor colorWithRed:0 green:192 blue:238 alpha:1];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu_left"] style:UIBarButtonItemStylePlain target:self action:@selector(presentLeftMenuViewController:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu_right"]  style:UIBarButtonItemStylePlain target:self action:@selector(presentRightMenuViewController:)];

    NSString * networkNetWork = @"OnlineVideo";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetWork:) name:networkNetWork object:nil];
    CheckNetworkManager *networkManager = [CheckNetworkManager shareCheckNetworkManager];
    [networkManager checkNetWorkWithNotName:networkNetWork];
}
-(void)checkNetWork:(NSNotification *)not
{
    NSDictionary *dict =not.userInfo;
    NSString *isConnected  = [dict valueForKey:@"infoForNetWork"];
    if ([isConnected isEqualToString:@"yes"]) {
        [ProgressHUD showOnView:self.view];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadData:) name:@"VideoCat" object:nil];
        LoadDataManager  *manager = [LoadDataManager shareLoadDataManager];
        NSString *url = VIDEOITEMURL ;
        [manager loadDataWithURL:url WithNotname:@"VideoCat"];
    }
    else
    {
        UIAlertView  *av = [[UIAlertView alloc]initWithTitle:@"提 示" message:@"未检测到网络，请检查你的网络设置" delegate:nil cancelButtonTitle:@"确 定" otherButtonTitles:nil, nil];
        [av show];
    }
}
-(void)loadData:(NSNotification *)not
{
    _dataArray = [[NSMutableArray alloc]init];
    NSDictionary *dict = not.userInfo;
    NSArray *array = dict[@"items"];
    for(NSDictionary *d in array)
    {
        VideoItemModel *model = [[VideoItemModel alloc]init];
        [model setValuesForKeysWithDictionary:d];
        [self.dataArray addObject:model];
    }
    [self createUI];
}
-(void)createUI
{
    self.navigationController.navigationBar.translucent=NO;
    UITableView *tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    tableView.dataSource = self;
    tableView.delegate = self;
    [self.view addSubview:tableView];
    self.tableView = tableView;
    [ProgressHUD hideOnView:self.view];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VideoCell *cell =[VideoCell cellWithTableView:tableView];
    VideoItemModel *model = self.dataArray[indexPath.row];
    [cell setCellModel:model];
    
//    UIView *maskUpView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, cell.contentView.bounds.size.width,20)];
//    maskUpView.backgroundColor = [UIColor blackColor];
//    maskUpView.alpha = 0.3;
//    [cell.contentView addSubview:maskUpView];
//    
//    UIView *maskDownView = [[UIView alloc]initWithFrame:CGRectMake(0,  cell.contentView.bounds.size.height - 20, cell.contentView.bounds.size.width,20)];
//    maskDownView.alpha = 0.3;
//    maskDownView.backgroundColor = [UIColor blackColor];
//    [cell.contentView addSubview:maskDownView];
    return cell;
}
-(void)tapCellAction:(UIGestureRecognizer *)g
{
    UIView *maskView = [[UIView alloc]initWithFrame:g.view.bounds];
    maskView.backgroundColor = [UIColor blackColor];
    maskView.alpha = 0.3;
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, g.view.bounds.size.width, g.view.bounds.size.height)];
    [g.view addSubview:maskView];
    [g.view addSubview:label1];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    VideoItemModel *model = self.dataArray[indexPath.row];
    VideoPlayViewController *player = [[VideoPlayViewController alloc]init];
    player.whitchTypeVideo = [model.id integerValue];
    [self.navigationController pushViewController:player animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200.0f;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  self.dataArray.count;
}
@end
