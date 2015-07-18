//
//  MyPersonalViewController.m
//  Person
//
//  Created by 沈伟 on 15/5/12.
//  Copyright (c) 2015年 沈伟. All rights reserved.
//

#import "MyPersonalViewController.h"
#import "AFNetworking.h"
#import "XHMenu.h"
#import "XHScrollMenu.h"
#import "UIButton+WebCache.h"
#import "HeaderFile.h"
#import "MotionModel.h"
#import "MotionCell.h"
#import "UpdataDoc.h"
#import "AMLoginViewController.h"
#import "CardViewController.h"
#import "SecoreModel.h"
#import "MJRefresh.h"
#import "MySecoreCell.h"

@interface MyPersonalViewController ()<UITableViewDataSource,UITableViewDelegate,XHScrollMenuDelegate, UIScrollViewDelegate,PhotoStackViewDataSource, PhotoStackViewDelegate,UITextViewDelegate,MJRefreshBaseViewDelegate>
{
    AFHTTPRequestOperationManager *manger;
    //心情模块
    UITextView* MotionText;
    UITableView *MotionTable;
    UIButton *MotionBtn;
    //用户的userid
    NSString *userid;
    //用户的用户名
    NSString *userName;
    //成绩页码
    int pagenum;
    //成绩的下拉和上拉
    MJRefreshFooterView *footer;
    MJRefreshHeaderView *header;
}
//相册集
@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, strong) UISegmentedControl *segmentedControl;
@property (nonatomic, strong) XHScrollMenu *scrollMenu;
@property (nonatomic, strong) NSMutableArray *menus;
@property (nonatomic, assign) BOOL shouldObserving;
//心情数据
@property(nonatomic,strong) NSMutableArray *MotionArray;
//我的考试成绩
@property(nonatomic,strong) UITableView  * secoreTable;
//成绩数据
@property(nonatomic,strong) NSMutableArray  * scoreArray;

@end

@implementation MyPersonalViewController

-(NSMutableArray *)scoreArray{
    if (_scoreArray==nil) {
        _scoreArray=[NSMutableArray arrayWithCapacity:0];
    }
    return _scoreArray;
}

-(void)createRefresh{
    header=[MJRefreshHeaderView header];
    header.scrollView=self.secoreTable;
    header.delegate=self;
    
    footer=[MJRefreshFooterView footer];
    footer.scrollView=self.secoreTable;
    footer.delegate=self;
}

-(void)removeRefresh{
    header.scrollView=nil;
    [header removeFromSuperview];
    
    footer.scrollView=nil;
    [footer removeFromSuperview];
}
//用于注销改变账号后 修改数据
/*
 @property(nonatomic,strong) NSMutableArray *MotionArray;
 //我的考试成绩
 @property(nonatomic,strong) UITableView  * secoreTable;
 //成绩数据
 @property(nonatomic,strong) NSMutableArray  * scoreArray;
 */
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    if ([self.isViewDid isEqualToString:@"0"]) {
        NSLog(@"fhftt");
        [self.MotionArray removeAllObjects];
        [self.scoreArray removeAllObjects];
        userid=[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
        userName=[[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];
        //加载收藏视频数据
        [self loadData];
        //加载心情
        [self loadMyHeartData];
        //加载我的考试
        [self loadScoreData:YES];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"个人中心";
    self.navigationController.navigationBar.translucent=NO;
    [self.MotionArray removeAllObjects];
    [self.scoreArray removeAllObjects];
    NSLog(@"%@",[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"]);
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"userid"]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提 示" message:@"请登陆后执行操作" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        
        //去登陆
        AMLoginViewController *login=[[AMLoginViewController alloc]init];
        [self presentViewController:[[UINavigationController alloc]initWithRootViewController:login] animated:YES completion:nil];
        
        return;
    }
     NSLog(@"ViewDidLoad!!!!");
    userid=[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
    userName=[[NSUserDefaults standardUserDefaults]objectForKey:@"userName"];

    
       UIBarButtonItem *reLogin=[[UIBarButtonItem alloc] initWithTitle:@"切换账号" style:UIBarButtonItemStylePlain target:self action:@selector(reLogin:)];;
    
    UIBarButtonItem *leftMenu = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu_left"] style:UIBarButtonItemStylePlain target:self action:@selector(presentLeftMenuViewController:)];
    self.navigationItem.leftBarButtonItems=@[leftMenu,reLogin];
    
   
    UIBarButtonItem *rightCard=[[UIBarButtonItem alloc]initWithTitle:@"我的名片" style:UIBarButtonItemStylePlain target:self action:@selector(goCard:)];
    
    UIBarButtonItem *rightMenu=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu_right"]  style:UIBarButtonItemStylePlain target:self action:@selector(presentRightMenuViewController:)];
    
    self.navigationItem.rightBarButtonItems=@[rightMenu,rightCard];
    
    self.view.backgroundColor=[UIColor whiteColor];
    self.shouldObserving = YES;
    
    _scrollMenu = [[XHScrollMenu alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 40)];
    _scrollMenu.backgroundColor = [UIColor colorWithWhite:0.902 alpha:1.000];
    _scrollMenu.delegate = self;
    _scrollMenu.selectedIndex = 0;
    [self.view addSubview:self.scrollMenu];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 40, SCREEN_WIDTH, SCREEN_HEIGHT)];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate = self;
    _scrollView.pagingEnabled = YES;
    
    [self.view addSubview:self.scrollView];
    
    for (int i = 0; i < 6; i ++) {
        XHMenu *menu = [[XHMenu alloc] init];
        
        NSString *title = nil;
        switch (i) {
            case 0:
                title = @"心情";
                break;
            case 1:
                title = @"我的学习";
                break;
            case 2:
                title = @"修改资料";
                break;
            case 3:
                title = @"陌生人";
                break;
            case 4:
                title = @"我的相册";
                break;
            case 5:
                title = @"我的考试";
                break;
        }
        menu.title = title;
        
        menu.titleNormalColor = [UIColor colorWithWhite:0.141 alpha:1.000];
        menu.titleFont = [UIFont boldSystemFontOfSize:16];
        [self.menus addObject:menu];
        
        UIImageView *logoImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo"]];
        logoImageView.frame = CGRectMake(i * CGRectGetWidth(_scrollView.bounds), 0, CGRectGetWidth(_scrollView.bounds), CGRectGetHeight(_scrollView.bounds));
        [_scrollView addSubview:logoImageView];
    }
    [_scrollView setContentSize:CGSizeMake(self.menus.count * CGRectGetWidth(_scrollView.bounds), 40)];
    [self startObservingContentOffsetForScrollView:_scrollView];
    
    _scrollMenu.menus = self.menus;
    [_scrollMenu reloadData];
    
    _scrollView.contentOffset=CGPointMake(1, 1);
    manger=[AFHTTPRequestOperationManager manager];
    manger.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    [self loadMyView];
    
    //加载收藏视频数据
    [self loadData];
    //加载心情
    [self loadMyHeartData];
    //加载陌生人数据
    [self loadMsrData];
    //加载我的考试
    [self loadScoreData:YES];
    
}

/**
 *  重新登陆
 */
-(void)reLogin:(UIButton*)btn{
    AMLoginViewController *login=[[AMLoginViewController alloc]init];
    //设置代理修改首页的个人资料
    login.delegate = self.logindelegate;
      self.isViewDid = @"0";
    [self presentViewController:[[UINavigationController alloc]initWithRootViewController:login] animated:YES completion:nil];
}


-(void)goCard:(UIButton*)btn{
    CardViewController *card=[[CardViewController alloc]init];
    card.userid=[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"];
    [self.navigationController pushViewController:card animated:YES];
}

-(void)loadMyView{
    //我的心情的视图
    UIView *view=[[[NSBundle mainBundle]loadNibNamed:@"MyPersonMotion" owner:self options:nil]firstObject];
    view.frame=CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [self.scrollView addSubview:view];
    
    MotionBtn=(UIButton *)[view viewWithTag:102];
    [MotionBtn addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
    
    MotionText=(UITextView*)[view viewWithTag:103];
    MotionText.layer.cornerRadius=20.0f;
    MotionText.layer.masksToBounds=YES;
    MotionText.textContainerInset=UIEdgeInsetsMake(30, 30, 30, 30);
    MotionText.delegate=self;
    MotionText.layer.borderColor=[UIColor blueColor].CGColor;
    MotionText.layer.borderWidth=0.7;
    MotionTable=(UITableView*)[view viewWithTag:101];
    MotionTable.delegate=self;
    MotionTable.dataSource=self;
    
    
    //学习收藏的视图
    _tabview=[[UITableView alloc]initWithFrame:CGRectMake(self.scrollView.bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-88)];
    self.tabview.delegate=self;
    self.tabview.tag=201;
    [self.scrollView addSubview:self.tabview];
    self.tabview.dataSource=self;
    
    
    //相册集
    _photoStack = [[PhotoStackView alloc] initWithFrame:CGRectMake(4*self.scrollView.bounds.size.width+10, 0, [UIScreen mainScreen].bounds.size.width-20, [UIScreen mainScreen].bounds.size.height)];
    _photoStack.dataSource = self;
    _photoStack.delegate = self;
    [self.scrollView addSubview:_photoStack];
    
    //修改资料
    UpdataDoc *doc=[[[NSBundle mainBundle]loadNibNamed:@"UpdataDoc" owner:self options:nil]firstObject];
    doc.frame=CGRectMake(2*self.scrollView.bounds.size.width+10, 0, [UIScreen mainScreen].bounds.size.width-20, [UIScreen mainScreen].bounds.size.height);
    doc.mainVc=self;
    [self.scrollView addSubview:doc];
    
    
    //陌生人
    self.sphereView = [[DBSphereView alloc] initWithFrame:CGRectMake(3*self.scrollView.bounds.size.width+10, 30, SCREEN_WIDTH-20, SCREEN_HEIGHT-30)];
    
    
    //学习成绩视图
    self.secoreTable=[[UITableView alloc]initWithFrame:CGRectMake(5*self.scrollView.bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-88)];
    self.secoreTable.delegate=self;
    self.secoreTable.dataSource=self;
    [self.scrollView addSubview:self.secoreTable];
    
}

#pragma mark 懒加载
-(NSArray *)photos {
    if(!_photos) {
        
        _photos = [NSArray arrayWithObjects:
                   [UIImage imageNamed:@"photo1.jpg"],
                   [UIImage imageNamed:@"photo2.jpg"],
                   [UIImage imageNamed:@"photo3.jpg"],
                   [UIImage imageNamed:@"photo4.jpg"],
                   [UIImage imageNamed:@"photo5.jpg"],
                   nil];
        
    }
    return _photos;
}

-(NSMutableArray *)MSViewArray{
    if (!_MSViewArray) {
        _MSViewArray=[NSMutableArray array];
    }
    return _MSViewArray;
}

-(NSMutableArray *)MotionArray{
    if (_MotionArray==nil) {
        _MotionArray=[NSMutableArray arrayWithCapacity:0];
    }
    return _MotionArray;
}


- (NSMutableArray *)menus {
    if (!_menus) {
        _menus = [[NSMutableArray alloc] initWithCapacity:1];
    }
    return _menus;
}

- (void)valueChange:(UISegmentedControl *)segmentedControl {
    if (segmentedControl.selectedSegmentIndex == 0) {
        [self.menus removeObject:[self.menus firstObject]];
    } else {
        XHMenu *menu = [[XHMenu alloc] init];
        menu.title = @"添加的";
        
        menu.titleNormalColor = [UIColor colorWithWhite:0.141 alpha:1.000];
        menu.titleFont = [UIFont boldSystemFontOfSize:16];
        [self.menus addObject:menu];
    }
    self.scrollMenu.menus = self.menus;
    [self.scrollMenu reloadData];
}


-(NSMutableArray *)menuTitles{
    if (_menuTitles==nil) {
        _menuTitles=[[NSMutableArray alloc]initWithArray:@[@"我收藏的视频",@"我收藏的手记",@"我收藏的文档",@"我创建的笔记"]];
    }
    return _menuTitles;
}

-(NSMutableDictionary *)dataDic{
    if (_dataDic==nil) {
        _dataDic=[NSMutableDictionary dictionary];
    }
    return _dataDic;
}


#pragma mark 数据载入
//加载陌生人数据
-(void)loadMsrData{
    NSString *url=@"http://edu.coderss.cn/index.php/Users/strangerForIos";

    [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil] isKindOfClass:[NSArray class]]) {
            NSArray *tmp=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"%@",tmp);

            
            //刷新现在的数据
            NSMutableArray *array = [[NSMutableArray alloc] initWithCapacity:0];
            for (NSInteger i = 0; i < tmp.count; i ++) {
                UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
                [btn setTitle:[NSString stringWithFormat:@"%@",[tmp[i] objectForKey:@"username"]] forState:UIControlStateNormal];
                [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
                btn.titleLabel.font = [UIFont systemFontOfSize:24.];
                btn.frame = CGRectMake(0, 0, 100, 50);
                [btn setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:USERICO,[tmp[i] objectForKey:@"username"],[tmp[i] objectForKey:@"picture"]]] forState:UIControlStateNormal];
                [btn addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
                [array addObject:btn];
                [self.sphereView addSubview:btn];
            }
            [self.sphereView setCloudTags:array];
            self.sphereView.backgroundColor = [UIColor whiteColor];
            [self.scrollView addSubview:self.sphereView];


        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


//加载收藏列别的数据
-(void)loadData{
    NSString *url=[NSString stringWithFormat:@"http://edu.coderss.cn/index.php/Users/myeduForIos/uid/%@",userid];
    //加载收藏的数据
    [manger GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSArray *collect=[dic  objectForKey:@"collect"];
            [self.dataDic setObject:collect forKey:@"我收藏的视频"];
            
            NSArray *notecoll=[dic objectForKey:@"notecoll"];
            [self.dataDic setObject:notecoll forKey:@"我收藏的手记"];
     
            NSArray *libcoll=[dic objectForKey:@"libcoll"];
            [self.dataDic setObject:libcoll forKey:@"我收藏的文档"];
            
            NSArray *note=[dic objectForKey:@"note"];
            [self.dataDic setObject:note forKey:@"我创建的笔记"];
            
            [self.tabview reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

//加载考试成绩
-(void)loadScoreData:(BOOL)refresh{
    
    NSDictionary *dic=@{
                        @"page":[NSString stringWithFormat:@"%d",pagenum]
                        };
    [manger POST:[NSString stringWithFormat:TESTSCORE,userid] parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id jsonData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            if ([[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil] isKindOfClass:[NSArray class]]) {
            
            
            if (refresh) {
                [self.scoreArray removeAllObjects];
            }
            
            NSArray *arr=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            NSLog(@"考试成绩结果%@",arr);
            for (NSDictionary *dic in arr) {
                SecoreModel *model=[[SecoreModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                
                [self.scoreArray addObject:model];
            }
            [self.secoreTable reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

//加载心情说说数据
-(void)loadMyHeartData{
    //加载我的心情说说
    NSString *heart=[NSString stringWithFormat:@"http://edu.coderss.cn/index.php/Users/myheartForIos/uid/%@",userid];
    
    [self.MotionArray removeAllObjects];
    
    [manger GET:heart parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[NSJSONSerialization  JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil] isKindOfClass:[NSDictionary class]]) {
            
    
            NSDictionary *dic=[NSJSONSerialization  JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            NSArray *temp=[dic objectForKey:@"mymes"];
            
            for (NSDictionary *mydic in temp) {
                MotionModel *model=[[MotionModel alloc]init];
                [model setValuesForKeysWithDictionary:mydic];
                
                [self.MotionArray addObject:model];
            }
        
            
            [MotionTable reloadData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}


#pragma mark datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView.tag==201) {
        return self.menuTitles.count;
    }
    else if (tableView==MotionTable){
        return 1;
    }
    else if (tableView==self.secoreTable){
        return 1;
    }
    return 0;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag==201) {
        NSString *str=_menuTitles[section];
        NSArray *arr=[self.dataDic objectForKey:str];
        NSString  *judgeIsNull = [NSString stringWithFormat:@"%@",arr];
        if ([judgeIsNull isEqualToString:@"<null>"]) {
            return 0;
        }
        else
        {
            return arr.count;

        }
    }
    else if (tableView==MotionTable){
        NSString *judgeIsNull = [NSString stringWithFormat:@"%@",self.MotionArray];
        if ([judgeIsNull isEqualToString:@"<null>"]) {
            return 0;
        }
        else
        {
            return self.MotionArray.count;
        }
    }
    else if (tableView==self.secoreTable){
         NSString *judgeIsNull = [NSString stringWithFormat:@"%@",self.scoreArray];
        if ([judgeIsNull isEqualToString:@"<null>"]) {
            return 0;
        }
        else
        {
            return self.scoreArray.count;
        }
    }
    {
        return 0;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView==MotionTable) {
        return 75;
    }
    else if (tableView==self.secoreTable){
        return 70;
    }
    else{
        return 44;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView.tag==201) {
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cellid"];
        if (!cell) {
            cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellid"];
        }
        
        //先拿类别
        NSString *str=self.menuTitles[indexPath.section];
        
        
        //这里取出的是收藏的类别下数据的数组
        NSArray *arr=[self.dataDic objectForKey:str];
        
        //这里取出来的是每个收藏的细节数据
        NSDictionary *dic=arr[indexPath.row];
        
        
        
        if ([str isEqualToString:@"我收藏的视频"]) {
            cell.textLabel.text=[dic objectForKey:@"videoname"];
        }
        else{
            cell.textLabel.text=[dic objectForKey:@"title"];
        }
        
        
        return cell;
    }
    else if (tableView==MotionTable){
        MotionCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cellMotionId"];
        if (!cell) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"MotionCell" owner:self options:nil]firstObject];
        }
        MotionModel *model=self.MotionArray[indexPath.row];
        //取出数据
        [cell configUI:model];
        
        return cell;
    }
    else if (tableView==self.secoreTable){
        MySecoreCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cellSecore"];
        if (!cell) {
            cell=[[[NSBundle mainBundle]loadNibNamed:@"MySecoreCell" owner:self options:nil]firstObject];
        }
        
        SecoreModel *model=self.scoreArray[indexPath.row];
        
        [cell configUI:model];
        
        return cell;
    }
    return NULL;
}

-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (tableView.tag==201) {
        return _menuTitles[section];
    }
    else{
        return nil;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
}

#pragma mark menu
- (void)startObservingContentOffsetForScrollView:(UIScrollView *)scrollView
{
    [scrollView addObserver:self forKeyPath:@"contentOffset" options:0 context:nil];
}

- (void)stopObservingContentOffset
{
    if (self.scrollView) {
        [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
        self.scrollView = nil;
    }
}

- (void)scrollMenuDidSelected:(XHScrollMenu *)scrollMenu menuIndex:(NSUInteger)selectIndex {
    
    NSLog(@"selectIndex : %ld", selectIndex);
    self.shouldObserving = NO;
    [self menuSelectedIndex:selectIndex];
}

- (void)scrollMenuDidManagerSelected:(XHScrollMenu *)scrollMenu {
    
}

- (void)menuSelectedIndex:(NSUInteger)index {
    CGRect visibleRect = CGRectMake(index * CGRectGetWidth(self.scrollView.bounds), 0, CGRectGetWidth(self.scrollView.bounds), CGRectGetHeight(self.scrollView.bounds));
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
        [self.scrollView scrollRectToVisible:visibleRect animated:NO];
    } completion:^(BOOL finished) {
        self.shouldObserving = YES;
    }];
}

#pragma mark - ScrollView delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //每页宽度
    CGFloat pageWidth = scrollView.frame.size.width;
    //根据当前的坐标与页宽计算当前页码
    int currentPage = floor((scrollView.contentOffset.x - pageWidth/2)/pageWidth)+1;
    [self.scrollMenu setSelectedIndex:currentPage animated:YES calledDelegate:NO];
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqualToString:@"contentOffset"] && self.shouldObserving) {
        //每页宽度
        CGFloat pageWidth = self.scrollView.frame.size.width;
        //根据当前的坐标与页宽计算当前页码
        NSUInteger currentPage = floor((self.scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
        if (currentPage > self.menus.count - 1)
            currentPage = self.menus.count - 1;
        
        CGFloat oldX = currentPage * CGRectGetWidth(self.scrollView.frame);
        if (oldX != self.scrollView.contentOffset.x) {
            BOOL scrollingTowards = (self.scrollView.contentOffset.x > oldX);
            NSInteger targetIndex = (scrollingTowards) ? currentPage + 1 : currentPage - 1;
            if (targetIndex >= 0 && targetIndex < self.menus.count) {
                CGFloat ratio = (self.scrollView.contentOffset.x - oldX) / CGRectGetWidth(self.scrollView.frame);
                CGRect previousMenuButtonRect = [self.scrollMenu rectForSelectedItemAtIndex:currentPage];
                CGRect nextMenuButtonRect = [self.scrollMenu rectForSelectedItemAtIndex:targetIndex];
                CGFloat previousItemPageIndicatorX = previousMenuButtonRect.origin.x;
                CGFloat nextItemPageIndicatorX = nextMenuButtonRect.origin.x;
                
                /* this bug for Memory
                 UIButton *previosSelectedItem = [self.scrollMenu menuButtonAtIndex:currentPage];
                 UIButton *nextSelectedItem = [self.scrollMenu menuButtonAtIndex:targetIndex];
                 [previosSelectedItem setTitleColor:[UIColor colorWithWhite:0.6 + 0.4 * (1 - fabsf(ratio))
                 alpha:1.] forState:UIControlStateNormal];
                 [nextSelectedItem setTitleColor:[UIColor colorWithWhite:0.6 + 0.4 * fabsf(ratio)
                 alpha:1.] forState:UIControlStateNormal];
                 */
                CGRect indicatorViewFrame = self.scrollMenu.indicatorView.frame;
                
                if (scrollingTowards) {
                    indicatorViewFrame.size.width = CGRectGetWidth(previousMenuButtonRect) + (CGRectGetWidth(nextMenuButtonRect) - CGRectGetWidth(previousMenuButtonRect)) * ratio;
                    indicatorViewFrame.origin.x = previousItemPageIndicatorX + (nextItemPageIndicatorX - previousItemPageIndicatorX) * ratio;
                } else {
                    indicatorViewFrame.size.width = CGRectGetWidth(previousMenuButtonRect) - (CGRectGetWidth(nextMenuButtonRect) - CGRectGetWidth(previousMenuButtonRect)) * ratio;
                    indicatorViewFrame.origin.x = previousItemPageIndicatorX - (nextItemPageIndicatorX - previousItemPageIndicatorX) * ratio;
                }
                
                self.scrollMenu.indicatorView.frame = indicatorViewFrame;
            }
        }
    }
}


#pragma mark Deck DataSource Protocol Methods

-(NSUInteger)numberOfPhotosInPhotoStackView:(PhotoStackView *)photoStack {
    return [self.photos count];
}

-(UIImage *)photoStackView:(PhotoStackView *)photoStack photoForIndex:(NSUInteger)index {
    return [self.photos objectAtIndex:index];
}

#pragma mark Deck Delegate Protocol Methods

-(void)photoStackView:(PhotoStackView *)photoStackView willStartMovingPhotoAtIndex:(NSUInteger)index {
    // User started moving a photo
}

-(void)photoStackView:(PhotoStackView *)photoStackView willFlickAwayPhotoAtIndex:(NSUInteger)index {
    // User flicked the photo away, revealing the next one in the stack
}

-(void)photoStackView:(PhotoStackView *)photoStackView didRevealPhotoAtIndex:(NSUInteger)index {
    NSLog([NSString stringWithFormat:@"现在您点击的是:%ld",index]);
}

-(void)photoStackView:(PhotoStackView *)photoStackView didSelectPhotoAtIndex:(NSUInteger)index {
    NSLog(@"selected %ld", index);
}

#pragma mark 点击事件
-(void)buttonPressed:(id)sender{
    NSLog(@"点击了陌生人");
}

-(void)sendMessage:(id)sender{
    NSLog(@"发送消息");
    NSLog(@"%@",MotionText.text);
    
    //发送消息
    NSString *str=@"http://edu.coderss.cn/index.php/Usermessage/addusermessage";
    
    NSDictionary *dic=@{
                        @"message":MotionText.text,
                        @"myid":userid,
                        @"vid":userid,
                        @"myname":userName,
                        @"visitor":userName
                        };
    
    [manger POST:str parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *tmp=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        if ([tmp isEqualToString:@"ok"]) {
            NSLog(@"发送成功");
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提 示" message:@"说说发布成功!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            [self loadMyHeartData];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark textView delegate
-(void)textViewDidBeginEditing:(UITextView *)textView{
    textView.text=@"";
}

#pragma mark mjrefresh
-(void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView{
    if (refreshView==header) {
        pagenum=0;
        [self loadScoreData:YES];
    }
    else{
        pagenum++;
        [self loadScoreData:NO];
    }
    
}

-(void)viewDidDisappear:(BOOL)animated{
    
    [self.MotionArray removeAllObjects];
    [self.scoreArray removeAllObjects];
    [self stopObservingContentOffset];
    [self.view removeFromSuperview];
    [super viewDidDisappear:animated];
}
@end








