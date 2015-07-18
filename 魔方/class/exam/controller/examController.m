#import "examController.h"
#import "examView.h"
#import "LoadDataManager.h"
#import "CheckNetworkManager.h"
#import "HeaderFile.h"
#import "TestModel.h"
@interface examController ()<UIAlertViewDelegate,UIScrollViewDelegate,UIAlertViewDelegate>
{
    NSTimer *_timer;
    UIScrollView *scrollView;
    UIAlertView *noTestAv;
}
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,assign)int time;
@property(nonatomic,strong)NSMutableArray *testArray;
@property(nonatomic,strong)NSMutableArray *answerArray;
@property(nonatomic,strong)UIAlertView *timeAlertView;
@end

@implementation examController
-(NSMutableArray *)answerArray
{
    if (_answerArray == nil) {
        _answerArray  = [[NSMutableArray alloc]init];
        for(int i = 0 ; i <self.testArray.count;i++)
        {
            NSString *a = @" ";
            [_answerArray addObject:a];
        }
    }
    return _answerArray;
}
-(NSMutableArray *)testArray
{
    if (_testArray == nil) {
        _testArray = [[NSMutableArray alloc]init];
    }
    return _testArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    
    NSString *netWorkNetWork =@"detailExam";
    self.timeLabel.text = @"剩余0分0秒";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetWork:) name:netWorkNetWork object:nil];
    CheckNetworkManager *netWorkManager = [CheckNetworkManager shareCheckNetworkManager];
    [netWorkManager checkNetWorkWithNotName:netWorkNetWork];

}
-(void)checkNetWork:(NSNotification *)not
{
    NSDictionary *dict = not.userInfo;
    NSString *isConntected = [dict valueForKey:@"infoForNetWork"];
    if ([isConntected isEqualToString:@"yes"]) {
        [self createProgressUI];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadData:) name:@"detailExamData" object:nil];
        LoadDataManager   *manager = [LoadDataManager shareLoadDataManager];
        NSString *url = [TESTURL stringByAppendingFormat:@"%@",_id];
        NSLog(@"%@",url);
        [manager loadDataWithURL:url WithNotname:@"detailExamData"];
    }
    else
    {
        UIAlertView  *av = [[UIAlertView alloc]initWithTitle:@"提  示" message:@"未检测到网络，请检查你的网络设置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
    }
}
-(void)createTimer
{
    _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(ChangeTime) userInfo:nil repeats:YES];
    
}
-(void)ChangeTime
{
    self.time--;
    if (self.time == 0) {
        UIAlertView  *av = [[UIAlertView alloc]initWithTitle:@"提 示" message:@"考试时间到了，自动提交试卷~~~" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        self.timeAlertView = av;
        [_timer setFireDate:[NSDate distantFuture]];
        scrollView.userInteractionEnabled = NO;
    }
    int minute = self.time / 60;
    int second = self.time % 60;
    self.timeLabel.text = [NSString  stringWithFormat:@"剩余%d分%d秒",minute,second];
}
-(void)loadData:(NSNotification *)not
{
    NSDictionary *dict = not.userInfo;
    NSLog(@"%@",dict);
    NSArray *array = dict[@"items"];
    if (array.count<1) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提 示" message:@"此试卷还未添加试题\n请等待后台管理添加试题" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        alert.delegate=self;
        alert.tag=100;
        [alert show];
    }
    for(NSDictionary * d in array)
    {
        TestModel *model = [[TestModel alloc]init];
        [model setValuesForKeysWithDictionary:d];
        [self.testArray addObject:model];
    }
    [self createNibView];
    [self answerArray];
    [self createNavItem];
    self.time = 60 * (int)self.testArray.count;
    [self createTimer];
    UIView *progressView = [self.view viewWithTag:100];
    [ProgressHUD hideOnView:progressView];
}
-(void)createProgressUI
{
    UIView *progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49)];
    progressView.backgroundColor = [UIColor clearColor];
    progressView.tag = 100;
    [self.view addSubview:progressView];
    [ProgressHUD showOnView:progressView];
}
-(void)createNavItem
{
    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    navView.userInteractionEnabled = YES;
    [self.view addSubview:navView];
    
    UIImageView *timeImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"time"]];
    timeImageView.frame = CGRectMake(50, 0, 20, 20);
    [navView addSubview:timeImageView];
    UILabel *timeLabel  = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 20)];
    [navView addSubview:timeLabel];
    timeLabel.font = [UIFont systemFontOfSize:15];
    timeLabel.textColor = [UIColor redColor];
    timeLabel.center = navView.center;
    self.timeLabel = timeLabel;
    
    UIButton *submitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    submitBtn.frame = CGRectMake(0, 0, 80, 44);
    [submitBtn setTitle:@"提 交" forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [submitBtn addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *submit=[[UIBarButtonItem alloc]initWithCustomView:submitBtn];
    
    
    
    
    UIButton *anwserBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    anwserBtn.frame = CGRectMake(0, 0, 60, 44);
    [anwserBtn setTitle:@"查看答案" forState:UIControlStateNormal];
    [anwserBtn addTarget:self action:@selector(anwerBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *answer=[[UIBarButtonItem alloc]initWithCustomView:anwserBtn];
    
    self.navigationItem.rightBarButtonItems=@[answer,submit];
}
-(void)anwerBtnClick
{
    /*
     AFHTTPSessionManager *sessionmang=[AFHTTPSessionManager manager];
     sessionmang.responseSerializer=[AFHTTPResponseSerializer serializer];
     [sessionmang POST:TESTSCORE parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
     NSString *str=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
     UIAlertView  *av = [[UIAlertView alloc]initWithTitle:@"提 示" message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
     [av show];
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
     }];
     */
    NSString *url= [TESTANSWER stringByAppendingString:self.id];
    AFHTTPSessionManager *sessionmang=[AFHTTPSessionManager manager];
    sessionmang.responseSerializer=[AFHTTPResponseSerializer serializer];
    [sessionmang POST:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil] isKindOfClass:[NSArray class]]) {
            NSArray *temp=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSMutableString *answer=[NSMutableString string];
            
            for (int i=0;i<temp.count;i++) {
                NSDictionary *dic=temp[i];
                [answer appendFormat:@"第 %d 题的答案是:%@ \n",i,[dic objectForKey:@"answer"]];
            }
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提 示" message:answer delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
       
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
    }];
    
}
-(void)submit:(UIButton *)btn
{
    UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"答  案" message:@"您确定提交？" delegate:self cancelButtonTitle:@"确 定" otherButtonTitles:nil, nil];
    av.delegate = self;
    [av show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSLog(@"%ld",alertView.tag);
    if (alertView.tag==100) {
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    if (buttonIndex== 0) {
        [self countScore];
    }
}
-(void)createNibView
{
    UIScrollView *scrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,SCREEN_WIDTH, SCREEN_HEIGHT)];
    scrollView = scrollview;
    [self.view addSubview:scrollview];
    for(int i = 0 ; i < self.testArray.count;i++)
    {
        examView *ev = [[NSBundle mainBundle] loadNibNamed:@"examView" owner:nil options:nil][0];
        ev.indexLabel.text = [NSString stringWithFormat:@"题目%d",i+1];
        ev.aBtn.tag = 400+i*4+1;
        NSLog(@"%ld",ev.aBtn.tag);
        [ev.aBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        ev.bBtn.tag = 400+i*4+2;
        NSLog(@"%ld",ev.bBtn.tag);
        [ev.bBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        ev.cBtn.tag = 400+i*4+3;
        NSLog(@"%ld",ev.cBtn.tag);
        [ev.cBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        ev.dBtn.tag = 400+i*4+4;
        NSLog(@"%ld",ev.dBtn.tag);
        [ev.dBtn addTarget:self action:@selector(selectBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        TestModel *model = self.testArray[i];
        [ev config:model];
        ev.frame = CGRectMake(self.view.bounds.size.width*i, 0, SCREEN_WIDTH,SCREEN_HEIGHT-64);
        [scrollview addSubview:ev];
    }
    scrollview.contentSize = CGSizeMake(self.testArray.count *(SCREEN_WIDTH), 0);
    scrollview.delegate = self;
    scrollview.pagingEnabled = YES;
}
-(void)selectBtnClick:(UIButton *)btn
{
    NSInteger  whichQus = (btn.tag - 400) / 4;
    NSInteger  whichAns = (btn.tag - 400) % 4 -1;
    switch (whichAns) {
        case 0:
            [self.answerArray replaceObjectAtIndex:whichQus withObject:@"A"];
            break;
        case 1:
            [self.answerArray replaceObjectAtIndex:whichQus withObject:@"B"];
            break;
        case 2:
            [self.answerArray replaceObjectAtIndex:whichQus withObject:@"C"];
        case 3:
            [self.answerArray replaceObjectAtIndex:whichQus withObject:@"D"];
    }
    NSLog(@"%@",self.answerArray);
}
-(void)countScore
{
    NSMutableDictionary *dic=[NSMutableDictionary dictionary];
    NSMutableDictionary *dicAnswer=[NSMutableDictionary dictionary];
    [dic setObject:self.id forKey:@"tid"];
    [dic setObject:[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"] forKey:@"uid"];
    for(int i = 0 ; i < self.testArray.count;i++)
    {
        TestModel *model = self.testArray[i];
        [dicAnswer setObject:self.answerArray[i] forKey:[NSString stringWithFormat:@"%@",model.id]];
    }
    [dic setObject:dicAnswer forKey:@"test"];
    [ProgressHUD showOnView:self.view];
    AFHTTPSessionManager *sessionmang=[AFHTTPSessionManager manager];
    sessionmang.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    [sessionmang POST:TESTSCORE1 parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        [ProgressHUD hideAfterSuccessOnView:self.view];
        NSString *str=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        UIAlertView  *av = [[UIAlertView alloc]initWithTitle:@"提 示" message:str delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
       [ProgressHUD hideAfterFailOnView:self.view];
    }];
    
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView1
{
    if (scrollView.contentOffset.x > scrollView.contentSize.width - self.view.bounds.size.width) {
        UIAlertView  *av = [[UIAlertView alloc]initWithTitle:@"提 示" message:@"没有题目了......" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
        [self.view addSubview:av];
        [self performSelector:@selector(hideAlertView) withObject:nil afterDelay:1];
    }
}
//提示框自动消失
-(void)hideAlertView
{
    [noTestAv dismissWithClickedButtonIndex:0 animated:YES];
}
-(void)backClick
{
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self.testArray removeAllObjects];
    [self.answerArray removeAllObjects];
    _timer=nil;
    [self.timeAlertView removeFromSuperview];
    //[self.timeAlertView dismissWithClickedButtonIndex:0 animated:YES];
}
@end
