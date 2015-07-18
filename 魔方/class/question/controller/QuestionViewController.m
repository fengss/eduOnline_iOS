//
//  ViewController.m
//  AnimationMaximize
//
//  Created by mayur on 7/31/13.
//  Copyright (c) 2013 mayur. All rights reserved.
//

#import "QuestionViewController.h"
#import "SampleCell.h"
#import "DetailViewController.h"
#import "HeaderFile.h"
#import "QuestionModel.h"
#import "UIImageView+WebCache.h"
#import "AskQuestionViewController.h"
#define TABLE_HEIGHT 100
#import "SearchQuestionViewController.h"
#import "MJRefresh.h"

@interface   QuestionViewController() <UITableViewDataSource, UITableViewDelegate,MJRefreshBaseViewDelegate>
{
    MJRefreshFooterView *footer;
    MJRefreshHeaderView *header;
    UITableView  *mytableView;
    int pageNum;
}
@property(nonatomic,strong)NSMutableArray *questionArray;
@end

@implementation QuestionViewController

-(NSMutableArray *)questionArray{
    if (_questionArray==nil) {
        _questionArray=[NSMutableArray array];
    }
    return _questionArray;
}

-(void)createRefresh{
    footer=[MJRefreshFooterView footer];
    footer.scrollView=mytableView;
    footer.delegate=self;
    
    header=[MJRefreshHeaderView header];
    header.scrollView=mytableView;
    header.delegate=self;
}

-(void)removeRefresh{
    header.scrollView=nil;
    [header removeFromSuperview];
    
    footer.scrollView=nil;
    [footer removeFromSuperview];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu_left"]
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(presentLeftMenuViewController:)];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame= CGRectMake(SCREEN_WIDTH - 100,0 ,100, 60);
    [btn setTitle:@"提问去" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(pushViewController) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithCustomView:btn];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu_right"]
                                                              style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:@selector(presentRightMenuViewController:)];
    self.navigationItem.rightBarButtonItems = @[item2,item1];
    [self createSegmentControl];
    [self loadMyData:YES];
    
    [self createTableView];
}


-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self createRefresh];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self removeRefresh];
}

- (void)createSegmentControl;
{
    UISegmentedControl *segCtrl = [[UISegmentedControl alloc] initWithItems:@[@"所有问题",@"推荐问题",@"搜索问题"]];
    segCtrl.tintColor = [UIColor blueColor];
    segCtrl.frame = CGRectMake(0,0, 300, 30);
    [segCtrl addTarget:self action:@selector(segValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:segCtrl];
}
- (void)segValueChanged:(UISegmentedControl *)seg
{
    if ( seg.selectedSegmentIndex == 2) {
        SearchQuestionViewController *ctrl = [[SearchQuestionViewController alloc]init];
        [self.navigationController pushViewController:ctrl animated:YES];
    }
}
-(void)pushViewController
{
    AskQuestionViewController *ctrl = [[AskQuestionViewController alloc]init];
    [self.navigationController pushViewController:ctrl animated:YES];
}

-(void)loadMyData:(BOOL)refresh{
    AppDelegate *app=[UIApplication sharedApplication].delegate;
    
    if (refresh) {
        pageNum=0;
    }
    else{
        pageNum+=1;
    }
    
    NSString *url = QUESTIONBARFIRSTURL;
    
    NSDictionary *dic=@{
                        @"page":[NSString stringWithFormat:@"%d",pageNum]
                        };
    
    [app.manger POST:url parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil]isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSArray *dataArray = dict[@"list1"];
            
            if (refresh) {
                [self.questionArray removeAllObjects];
            }
            
            for(NSDictionary *d in dataArray)
            {
                QuestionModel *model = [[QuestionModel alloc]init];
                [model setValuesForKeysWithDictionary:d];
                [self.questionArray addObject:model];
            }
            [mytableView reloadData];
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}



-(void)createTableView
{
    mytableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 30, self.view.bounds.size.width,self.view.bounds.size.height-30) style:UITableViewStylePlain];
    mytableView.delegate = self;
    mytableView.dataSource = self;
    [self.view addSubview:mytableView];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return TABLE_HEIGHT;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.questionArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QuestionModel *model = self.questionArray[indexPath.row];
    SampleCell *cell = (SampleCell*) [tableView dequeueReusableCellWithIdentifier:@"SampleCell"];
    if(cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"SampleCell" owner:[SampleCell class] options:nil];
        cell = (SampleCell *)[nib objectAtIndex:0];
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
   [cell configUI:model];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGRect cellFrameInTableView = [tableView rectForRowAtIndexPath:indexPath];
    CGRect cellFrameInSuperview = [tableView convertRect:cellFrameInTableView toView:[tableView superview]];
    
    DetailViewController* detailViewController = [[DetailViewController alloc] initWithNibName:@"DetailViewController" bundle:nil];
    
    QuestionModel *model = self.questionArray[indexPath.row];
    detailViewController.model = model;
    detailViewController.yOrigin = cellFrameInSuperview.origin.y;
    [self.navigationController pushViewController:detailViewController animated:NO];

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView{
    if (refreshView==header) {
        [self loadMyData:YES];
    }
    else{
        [self loadMyData:NO];
    }
    [refreshView endRefreshing];
}

@end
