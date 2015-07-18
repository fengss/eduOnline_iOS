
//
//  AskQuestionViewController.m
//  3G学院
//
//  Created by coderss on 15/5/9.
//  Copyright (c) 2015年 coderss. All rights reserved.
//

#import "SearchQuestionViewController.h"
#import "HeaderFile.h"
#import "TestCatModel.h"
#import "MyUtil.h"
#import "SearchLabelView.h"
#import "QuestionModel.h"
#import "QuestionResultViewController.h"
@interface SearchQuestionViewController ()<SearchLabelViewDelegate,UITextViewDelegate,UITextFieldDelegate>
@property(nonatomic,strong)NSMutableArray *catArray;
@property(nonatomic,strong)UIScrollView *catSelectView;
@property(nonatomic,strong)SearchLabelView *searchLabelView;
@property(nonatomic,strong)NSMutableArray *titleArray;
@property(nonatomic,strong)NSMutableArray *selectCatArray;
@property(nonatomic,strong)UIButton *submitBtn;
@property(nonatomic,strong)NSMutableArray *searchResultArray;
@end

@implementation SearchQuestionViewController
-(NSMutableArray *)selectCatArray
{
    if (_selectCatArray == nil) {
        _selectCatArray = [[NSMutableArray alloc]init];
    }
    return _selectCatArray;
}
-(NSMutableArray*)searchResultArray
{
    if (_searchResultArray == nil) {
        _searchResultArray = [[NSMutableArray alloc]init];
    }
    return _searchResultArray;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createSelectLabelView];
    [self createMessageTitle];
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 30)];
    label.text= @"搜索问题";
    label.textColor = [UIColor blueColor];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.titleView = label;
    NSString *networkNetWork = @"searchQuestion";
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
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadData:) name:@"searchQuestion1" object:nil];
        LoadDataManager  *manager = [LoadDataManager shareLoadDataManager];
        NSString *url = TESTCATURL;
        [manager loadDataWithURL:url WithNotname:@"searchQuestion1"];
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
    self.searchLabelView = [[SearchLabelView alloc]initWithFrame:CGRectMake(20, 5, 260, 40) sectionInsets:UIEdgeInsetsMake(5, 5, 5, 5) spaceX:5];
    self.searchLabelView.backgroundColor = [UIColor whiteColor];
    CALayer *layer = self.searchLabelView.layer;
    layer.borderColor = [UIColor blueColor].CGColor;
    layer.borderWidth = 1.5;
    [self.view addSubview:self.searchLabelView];
    self.searchLabelView.delegate = self;
}
-(void)createCatSelectView
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(20, 50,260 ,30 )];
    label.text = @"请选择标签";
    label.font =[UIFont systemFontOfSize:12];
    [self.view addSubview:label];
    self.catSelectView = [[UIScrollView alloc] initWithFrame:CGRectMake(20, 80, 260, 50)];
    CALayer *layerCat = self.catSelectView.layer;
    layerCat.borderColor = [UIColor blueColor].CGColor;
    layerCat.borderWidth = 1.2;
    for(int i = 0 ; i < self.catArray.count;i++)
    {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
        btn.frame = CGRectMake(0+(80+2)*i, 10, 80,30 );
        TestCatModel *model = self.catArray[i];
        CALayer *layer = btn.layer;
        layer.borderWidth = 1;
        layer.borderColor =[UIColor blueColor].CGColor;
        layer.cornerRadius = 10.0;
        
        
        [btn setTitle:model.name forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        btn.tag = 500+i;
        [btn addTarget:self action:@selector(catTypeSelect:) forControlEvents:UIControlEventTouchUpInside];
        [self.catSelectView addSubview:btn];
        btn.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gray.jpg"]];
    }
    self.catSelectView.showsHorizontalScrollIndicator = NO;
    self.catSelectView.contentSize = CGSizeMake(50 * self.catArray.count, 50);
    [self.view addSubview:self.catSelectView];
}
-(void)createMessageTitle
{
    UIButton *submit = [UIButton buttonWithType:UIButtonTypeCustom];
    submit.frame = CGRectMake(105,200,100, 20);
    submit.backgroundColor =[UIColor colorWithPatternImage:[UIImage imageNamed:@"gray.jpg"]];
    CALayer *layerSubmit = submit.layer;
    layerSubmit.borderWidth = 1.0;
    layerSubmit.borderColor = [UIColor blueColor].CGColor;
    layerSubmit.cornerRadius = 10;
    [submit setTitle:@"搜索" forState:UIControlStateNormal];
    submit.enabled = YES;
    submit.tag = 333;
    self.submitBtn = submit;
    [self.view addSubview:submit];
    [submit addTarget:self action:@selector(submitClick) forControlEvents:UIControlEventTouchUpInside];
}
-(void)submitClick
{
        self.submitBtn.enabled = NO;
        //self.submitBtn.selected = YES;
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

        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadDataSearch:) name:@"searchQuestion3" object:nil];
        LoadDataManager  *manager = [LoadDataManager shareLoadDataManager];
        NSString *url = SEARCHQUESTIONURL;
        url = [url stringByAppendingFormat:@"/pid/%@",labelid];
        NSLog(@"搜索的路径%@",url);
        [manager loadDataWithURL:url WithNotname:@"searchQuestion3"];
}

-(void)loadDataSearch:(NSNotification *)not
{
    NSDictionary *dict = not.userInfo;
     self.submitBtn.enabled = YES;
    NSArray *dataArray = dict[@"list1"];
    NSString *justStr = [NSString stringWithFormat:@"%@",dataArray];
    if ([justStr isEqualToString:@"<null>"]) {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"提示" message:@"没有你要查找的问题" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [av show];
    }
    else
    {
        [self.searchResultArray removeAllObjects];
        for(NSDictionary *d in dataArray)
        {
            QuestionModel *model = [[QuestionModel alloc]init];
            [model setValuesForKeysWithDictionary:d];
            [self.searchResultArray addObject:model];
        }
        
        QuestionResultViewController *ctrl = [[QuestionResultViewController alloc]init];
        ctrl.questionArray = self.searchResultArray;
        NSLog(@"^^^^^^^%@",self.searchResultArray);
        [self.navigationController pushViewController:ctrl animated:YES];
    }
}

-(void)catTypeSelect:(UIButton *)btn
{
    NSInteger index = btn.tag - 500;
    TestCatModel *model = self.catArray[index];
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
