//
//  SearchMessageControllerViewController.m
//  3G学院
//
//  Created by coderss on 15/5/10.
//  Copyright (c) 2015年 coderss. All rights reserved.
//

#import "SearchMessageControllerViewController.h"
#import "SearchLabelView.h"
#import "HeaderFile.h"
#import "TestCatModel.h"
#import "Message.h"
#import "SearchResultCtrl.h"
@interface SearchMessageControllerViewController ()<SearchLabelViewDelegate,UITextFieldDelegate>
@property(nonatomic,strong)NSMutableArray *catArray;
@property(nonatomic,strong)NSMutableArray *selectCatArray;
@property(nonatomic,strong)UIScrollView *catSelectView;
@property(nonatomic,strong)NSMutableArray *titleArray;
@property(nonatomic,strong)NSMutableArray *searchResultArray;
@property(nonatomic,strong)SearchLabelView *searchLabelView;
@property(nonatomic,strong)UISearchBar *searchBar;
@property(nonatomic,strong)UITextField *textField;
@end

@implementation SearchMessageControllerViewController
-(NSMutableArray *)searchResultArray
{
    if (_searchResultArray == nil) {
        _searchResultArray = [[NSMutableArray alloc]init];
    }
    return _searchResultArray;
}
-(NSMutableArray *)selectCatArray
{
    if (_selectCatArray == nil) {
        _selectCatArray = [[NSMutableArray alloc]init];
    }
    return _selectCatArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"搜索帖子";
    [self createSelectLabelView];
    [self createNameTextView];
    self.view.backgroundColor = [UIColor lightGrayColor];
    NSString *networkNetWork = @"searchMessage";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetWork:) name:networkNetWork object:nil];
    CheckNetworkManager *netWorkManager = [CheckNetworkManager shareCheckNetworkManager];
    [netWorkManager checkNetWorkWithNotName:networkNetWork];
}
-(void)checkNetWork:(NSNotification *)not
{
    NSDictionary *dict =not.userInfo;
    NSString *isConnected  = [dict valueForKey:@"infoForNetWork"];
    if ([isConnected isEqualToString:@"yes"]) {
        [ProgressHUD showOnView:self.view];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadData:) name:@"searchMeassge" object:nil];
        LoadDataManager  *manager = [LoadDataManager shareLoadDataManager];
        NSString *url = TESTCATURL;
        [manager loadDataWithURL:url WithNotname:@"searchMeassge"];
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
    self.titleArray = [[NSMutableArray alloc]init];
    for(NSDictionary *d in array)
    {
        TestCatModel *model = [[TestCatModel alloc]init];
        [model setValuesForKeysWithDictionary:d];
        [self.titleArray  addObject:model.name];
        [itemArray addObject:model];
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
                [self.titleArray  addObject:model.name];
            }
        }
    }
    self.catArray = itemArray;
    [self createCatSelectView];
    [ProgressHUD hideAfterSuccessOnView:self.view];
}

-(void)createSelectLabelView
{
    self.searchLabelView = [[SearchLabelView alloc]initWithFrame:CGRectMake(30, 25, 260, 40) sectionInsets:UIEdgeInsetsMake(5, 5, 5, 5) spaceX:5];
    self.searchLabelView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.searchLabelView];
    self.searchLabelView.delegate = self;
}
-(void)createCatSelectView
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(30, 70, 260, 30)];
    label.text = @"请选择标签";
    [self.view addSubview:label];
    self.catSelectView = [[UIScrollView alloc] initWithFrame:CGRectMake(30, 100, 260, 50)];
    for(int i = 0 ; i < self.catArray.count;i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(0+(80+2)*i, 0, 80, 50);
        TestCatModel *model = self.catArray[i];
        [btn setTitle:model.name forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        btn.tag = 500+i;
        [btn addTarget:self action:@selector(catTypeSelect:) forControlEvents:UIControlEventTouchUpInside];
        [self.catSelectView addSubview:btn];
        if (i % 2 == 0) {
            btn.backgroundColor = [UIColor yellowColor];
        }
        else
        {
            btn.backgroundColor = [UIColor grayColor];
        }
    }
    self.catSelectView.showsHorizontalScrollIndicator = NO;
    self.catSelectView.contentSize = CGSizeMake(50 * self.catArray.count, 50);
    [self.view addSubview:self.catSelectView];
}
-(void)createNameTextView
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(30, 155, 260, 30)];
    label.text = @"请输入你要查找的帖子的名称";
    [self.view addSubview:label];
    
    UITextField * textField = [[UITextField alloc] initWithFrame:CGRectMake(30, 190, 260, 30)];
    textField.backgroundColor= [UIColor whiteColor];
    [self.view addSubview:textField];
    self.textField = textField;
    self.textField.delegate = self;
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    searchBtn.frame = CGRectMake(225, 225, 80, 20);
    [self.view addSubview:searchBtn];
    [searchBtn addTarget:self action:@selector(searchBtnClick) forControlEvents:UIControlEventTouchUpInside];
}
-(void)searchBtnClick
{
    if (![self.textField.text isEqualToString:@""]||self.selectCatArray.count) {
        NSString *labelid = @"";
        for(int i = 0 ; i < self.selectCatArray.count;i++)
        {
            TestCatModel *model = self.selectCatArray[i];
            if (i== 0) {
                labelid = [labelid stringByAppendingFormat:@"%@",model.id];
            }
            else
            {
                labelid = [labelid stringByAppendingFormat:@",%@",model.id];
            }
        }
       //请求网络
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadDataSearch:) name:@"searchMessage1" object:nil];
        LoadDataManager  *manager = [LoadDataManager shareLoadDataManager];
        NSString *url = SEARCHMEASSAGEURL;
        if (self.textField.text==nil) {
            NSString *temp=[self.textField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            url = [url stringByAppendingFormat:@"/q/%@",temp];
        }
        else if(![labelid isEqual:@""]){
            url = [url stringByAppendingFormat:@"/pid/%@",labelid];
        }
        else{
            NSString *temp=[self.textField.text stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            url = [url stringByAppendingFormat:@"/q/%@/pid/%@",temp,labelid];
        }
        
        NSLog(@"%@",url);
        [manager loadDataWithURL:url WithNotname:@"searchMessage1"];
    }
    else
    {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请填入一种输入条件" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [av show];
    }
}
-(void)loadDataSearch:(NSNotification *)not
{
    NSDictionary *dict = not.userInfo;
    NSArray *dataArray = dict[@"list"];
    NSString *justStr = [NSString stringWithFormat:@"%@",dataArray];
    if ([justStr isEqualToString:@"<null>"]) {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"提示" message:@"没有你要查找的帖子" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [av show];
    }
    else
    {
        [self.searchResultArray removeAllObjects];
    for(NSDictionary *d in dataArray)
    {
        Message *model = [[Message alloc]init];
        [model setValuesForKeysWithDictionary:d];
        [self.searchResultArray addObject:model];
    }
     
        SearchResultCtrl *ctrl = [[SearchResultCtrl alloc]init];
        ctrl.messageArray = self.searchResultArray;
        [self.navigationController pushViewController:ctrl animated:YES];
    }
}
-(void)catTypeSelect:(UIButton *)btn
{
    NSInteger index = btn.tag - 500;
    TestCatModel *model = self.catArray[index];
    NSLog(@"%@",self.selectCatArray);
    for(int i = 0 ; i < self.selectCatArray.count;i++)
    {
        TestCatModel *model1 = self.selectCatArray[i];
        if ([model.name isEqualToString:model1.name]) {
            return;
        }
    }
    [self.selectCatArray addObject:model];
    if (self.selectCatArray.count > 3) {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"提示" message:@"最多三个标签" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [av show];
        return;
    }
    [self.searchLabelView refreshData];
}

#pragma mark -SearchLabelView代理方法
-(NSInteger) numberOfCellInSearchLableView:(SearchLabelView *)searchLabelView{
    return self.selectCatArray.count;
}
-(void)configCell:(SearchLableCell *)cell atIndex:(NSInteger)index inSearchView:(SearchLabelView *)searchLableView
{
    TestCatModel *model = self.selectCatArray[index];
    [cell config:model.name];
}
-(void)deleteCellAtIndex:(NSInteger)index inGridView:(SearchLabelView *)searchLabelView
{
    [self.selectCatArray removeObjectAtIndex:index];
    [self.searchLabelView refreshData];
}
-(void)viewDidDisappear:(BOOL)animated
{
     [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
