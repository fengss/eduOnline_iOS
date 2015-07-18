//
//  MessageController.m
//  魔方
//
//  Created by coderss on 15/5/12.
//  Copyright (c) 2015年 coderss. All rights reserved.
//

#import "MessageController.h"
#import "MessageForum.h"
#import "HeaderFile.h"
#import "MyLayout.h"
#import "MessageCell.h"
#define kCellReuseId (@"cellID")
#import "Message.h"
#import "AddMessageController.h"
#import "SearchMessageControllerViewController.h"
#import "MessageDetailVC.h"
@interface MessageController ()<UICollectionViewDelegate,UICollectionViewDataSource,MyLayoutDelegate>
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *messageArray;
@property(nonatomic,strong)NSMutableArray *heightForCellArray;
@property(nonatomic,strong)UIButton *selectButton;
@property(nonatomic,strong)MessageForum *messageView;
@end
/*
 @property (weak, nonatomic) IBOutlet UIButton *MessageBtn;
 @property (weak, nonatomic) IBOutlet UIButton *AllMessageBtn;
 */
@implementation MessageController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent=NO;
    self.navigationItem.title=@"贴吧中心";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu_left"] style:UIBarButtonItemStylePlain target:self action:@selector(presentLeftMenuViewController:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu_right"]  style:UIBarButtonItemStylePlain target:self action:@selector(presentRightMenuViewController:)];
    MessageForum *view = [[NSBundle mainBundle] loadNibNamed:@"MessageForum" owner:nil options:nil][0];
    view.frame = CGRectMake(0, 0,375,597);
    view.tag = 299;
    CALayer *layer1 = view.MessageBtn.layer;
    layer1.borderColor = [UIColor blueColor].CGColor;
    layer1.borderWidth = 1.0;
    self.messageView = view;
    [self.view addSubview:view];
    view.MessageBtn.tag = 300;
    CALayer *layer2 = view.AllMessageBtn.layer;
    layer2.borderWidth = 1.0;
    layer2.borderColor = [UIColor blueColor].CGColor;
    self.selectButton = view.MessageBtn;
    [view.MessageBtn addTarget:self action:@selector(MessageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    view.AllMessageBtn.tag = 301;
    CALayer *layer3 = view.publishMessagebBtn.layer;
    layer3.borderColor = [UIColor blueColor].CGColor;
    layer3.borderWidth = 1.0;
    [view.AllMessageBtn addTarget:self action:@selector(MessageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view.publishMessagebBtn addTarget:self action:@selector(publishMessagebBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [view.searchBtn addTarget:self action:@selector(SearchBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    NSString * networkNetWork = @"MessageBarNet";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetWork:) name:networkNetWork object:nil];
    CheckNetworkManager *netWorkManager = [CheckNetworkManager shareCheckNetworkManager];
    [netWorkManager checkNetWorkWithNotName:networkNetWork];
}
-(void)publishMessagebBtnClick
{
    NSString *islogin = [[NSUserDefaults standardUserDefaults] objectForKey:@"islogin"];
    if ([islogin isEqualToString:@"0"]) {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请先登录后再评论" delegate:nil cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [av show];
    }else
    {
        AddMessageController *ctrl = [[AddMessageController alloc]init];
        [self.navigationController pushViewController:ctrl animated:YES];
    }
    
}
-(void)MessageBtnClick:(UIButton *)btn
{
    self.selectButton = btn;
    NSString *url = nil;
    if (btn.tag == 300) {
        url = MesssageFIRSTURL;
    }
    else
    {
        url = ALLSEEMESSAGEURL;
    }
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadData:) name:@"MessageBar1" object:nil];
    LoadDataManager  *manager = [LoadDataManager shareLoadDataManager];
    
    [manager loadDataWithURL:url WithNotname:@"MessageBar1"];
    
}
-(void)checkNetWork:(NSNotification *)not
{
    NSDictionary *dict =not.userInfo;
    NSString *isConnected  = [dict valueForKey:@"infoForNetWork"];
    if ([isConnected isEqualToString:@"yes"]) {
        [ProgressHUD showOnView:self.view];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadData:) name:@"MessageBar" object:nil];
        LoadDataManager  *manager = [LoadDataManager shareLoadDataManager];
        NSString *url = ALLSEEMESSAGEURL;
        [manager loadDataWithURL:url WithNotname:@"MessageBar"];
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
    NSArray *array = dict[@"list"];
    _messageArray= [[NSMutableArray alloc]init];
    _heightForCellArray = [[NSMutableArray alloc]init];
    for(NSDictionary *d in array)
    {
        Message *model = [[Message alloc]init];
        [model setValuesForKeysWithDictionary:d];
        [_messageArray addObject:model];
        
        NSNumber *height = [[NSNumber alloc]initWithInt:arc4random()%100+140];
        [_heightForCellArray addObject:height];
    }
    if (_collectionView == nil) {
        [self createCollectionView];
    }
    else
    {
        [_collectionView reloadData];
    }
}

-(void)createCollectionView
{
    [ProgressHUD hideAfterSuccessOnView:self.view];
    MyLayout *layout = [[MyLayout alloc] init];
    layout.sectionInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    layout.itemSpace = 5;
    layout.lineSpace = 10;
    layout.delegate = self;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT-130) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"MessageCell" bundle:nil] forCellWithReuseIdentifier:kCellReuseId];
    [self.messageView.mycollectionView addSubview:_collectionView];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return  self.messageArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MessageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellReuseId forIndexPath:indexPath];
    Message *model = self.messageArray[indexPath.row];
    [cell config:model];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    Message *model = self.messageArray[indexPath.item];
    MessageDetailVC *ctrl = [[MessageDetailVC alloc]init];
    ctrl.message = model;
    [self.navigationController pushViewController:ctrl animated:YES];
}
-(NSInteger)numberOfColumns
{
    return 2;
}
-(CGFloat)heightForCellAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *height = self.heightForCellArray[indexPath.row];
    return [height floatValue];
}
-(void)SearchBtnClick:(id)sender {
    SearchMessageControllerViewController *ctrl = [[SearchMessageControllerViewController alloc]init];
    [self.navigationController pushViewController:ctrl animated:YES];
}
@end