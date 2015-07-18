//
//  ExamViewController.m
//  magic
//
//  Created by coderss on 15/5/11.
//  Copyright (c) 2015年 Roman Efimov. All rights reserved.
//

#import "ExamViewController.h"
#import "HeaderFile.h"
#import "TestCatModel.h"
#import "ExamSelectCtrl.h"
@interface ExamViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)NSMutableArray *contentArray;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)UILabel *titleLabel;
@end

@implementation ExamViewController
-(NSMutableArray *)contentArray
{
    if (_contentArray == nil) {
        _contentArray = [NSMutableArray arrayWithCapacity:0];
    }
    return _contentArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent=NO;
    self.navigationItem.title=@"考试中心";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu_left"] style:UIBarButtonItemStylePlain target:self action:@selector(presentLeftMenuViewController:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu_right"]  style:UIBarButtonItemStylePlain target:self action:@selector(presentRightMenuViewController:)];
    
    NSString * networkNetWork = @"OnlineExam";
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
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadData:) name:@"ExamCat" object:nil];
        LoadDataManager  *manager = [LoadDataManager shareLoadDataManager];
        NSString *url = TESTCATURL;
        [manager loadDataWithURL:url WithNotname:@"ExamCat"];
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
    for(NSDictionary *d in array)
    {
        NSMutableArray *itemArray = [[NSMutableArray alloc]init];
        TestCatModel *model = [[TestCatModel alloc]init];
        [model setValuesForKeysWithDictionary:d];
        [itemArray addObject:model];
        
        NSMutableDictionary  *dict1 =[[NSMutableDictionary alloc]init];
        [dict1 setObject:model.name forKey:@"title"];
        
        NSArray *sub1 = d[@"subclass"];
        NSString *subJ = [NSString stringWithFormat:@"%@",sub1];
        if ([subJ isEqualToString:@"<null>"]) {
        }
        else
        {
            for(NSDictionary *sub in sub1)
            {
                TestCatModel * model  = [[TestCatModel alloc]init];
                [model setValuesForKeysWithDictionary:sub];
                [itemArray addObject:model];
            }
        }
        [dict1 setObject:itemArray forKey:@"itemArray"];
        [dict1 setObject:[NSNumber numberWithBool:NO]forKey:@"state"];
        [self.contentArray addObject:dict1];
    }
    
    [self createTableView];
}
-(void)createTableView
{
    CGRect frame = CGRectMake(0, 0, self.view.bounds.size.width,SCREEN_HEIGHT);
    UITableView *tableView = [[UITableView alloc]initWithFrame:frame  style:UITableViewStyleGrouped];
    tableView.delegate = self;
    tableView.dataSource = self;
    self.tableView = tableView;
    [self.view addSubview:tableView];
    [ProgressHUD hideOnView:self.view];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.contentArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSDictionary  *dict = [self.contentArray objectAtIndex:section];
    BOOL expand = [[dict objectForKey:@"state"] boolValue];
    if (expand) {
        NSArray *array = [dict objectForKey:@"itemArray"];
        return [array count];
    }
    else
    {
        return 0;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"examItemCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSDictionary  *dict = self.contentArray[indexPath.section];
    NSArray  *itemArray = [dict objectForKey:@"itemArray"];
    TestCatModel *model = itemArray[indexPath.row];
    cell.textLabel.text =model.name;
    return cell;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSDictionary *dict = self.contentArray[section];
    NSString *titleHeader = [dict  objectForKey:@"title"];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:titleHeader forState:UIControlStateNormal];
    btn.backgroundColor = [UIColor colorWithRed:196/255.0 green:239/255.0 blue:244/255.0 alpha:1];
    btn.titleLabel.font = [UIFont boldSystemFontOfSize:15];
    btn.tag = section+400;
    btn.titleLabel.tintColor = [UIColor blackColor];
    BOOL expand = [[dict objectForKey:@"state"] boolValue];
    if (expand) {
        btn.imageView.transform = CGAffineTransformMakeRotation(M_PI_2);
    }
    else
    {
        btn.imageView.transform =  CGAffineTransformMakeRotation(0);
    }
    UIImage *image = [UIImage imageNamed:@"buddy_header_arrow"];
    [btn setImage:image forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(headerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}
-(void)headerBtnClick:(UIButton *)btn
{
    NSMutableDictionary *dict = [self.contentArray objectAtIndex:btn.tag - 400];
    BOOL expand = [[dict objectForKey:@"state"] boolValue];
    [dict setObject:[NSNumber numberWithBool:!expand] forKey:@"state"];
    NSIndexSet *set = [NSIndexSet indexSetWithIndex:btn.tag - 400];
    [self.tableView reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = self.contentArray[indexPath.section];
    NSArray *itemArray = [dict objectForKey:@"itemArray"];
    TestCatModel *model =  itemArray[indexPath.row];
    NSLog(@"选择的试卷类型是%@",model.id);
    ExamSelectCtrl *ctrl = [[ExamSelectCtrl alloc]init];
    ctrl.whichType = [model.id integerValue];
    [self.navigationController pushViewController:ctrl animated:YES];
}
@end
