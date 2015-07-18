//
//  MyNotrViewController.m
//  魔方
//
//  Created by coderss on 15/5/12.
//  Copyright (c) 2015年 coderss. All rights reserved.
//

#import "MyNoteViewController.h"
#import "HeaderFile.h"
#import  "NoteModel.h"
#import "NoteDetailViewController.h"
#import "MyNoteCell.h"

@interface MyNoteViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(nonatomic,strong)NSString *userId;
@property(nonatomic,strong)NSMutableArray *noteArray;
@property(nonatomic,strong)UICollectionView *collectionView;
@end

@implementation MyNoteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSUserDefaults *udf = [NSUserDefaults standardUserDefaults];
    
    if (![udf objectForKey:@"userid"]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提 示" message:@"请登陆后查看" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    self.userId = [udf objectForKey:@"userid"];
    
    self.view.backgroundColor = [UIColor whiteColor];
    NSString *netWorkNetWork = @"myNote";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetWork:) name:netWorkNetWork object:nil];
    CheckNetworkManager *networkManger = [CheckNetworkManager shareCheckNetworkManager];
    [networkManger checkNetWorkWithNotName:netWorkNetWork];
}
-(void)writeNoteUI
{
    
}
-(void)checkNetWork:(NSNotification *)not
{
    NSDictionary *dict = not.userInfo;
    NSString *isConnected = [dict valueForKey:@"infoForNetWork"];
    if ([isConnected isEqualToString:@"yes"]) {
        [ProgressHUD showOnView:self.view];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData:) name:@"myNoteData" object:nil];
        LoadDataManager *manager = [LoadDataManager shareLoadDataManager];
        NSString *ownNoteUrl=[NSString stringWithFormat:NOTEDETAILFORME,self.userId];
        [manager loadDataWithURL:ownNoteUrl WithNotname:@"myNoteData"];
    }
    else
    {
        UIAlertView  *av = [[UIAlertView alloc]initWithTitle:@"提 示" message:@"未检测到网络，请检查你的网络设置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
    }
}
-(void)loadData:(NSNotification *)not
{
    self.noteArray = [NSMutableArray array];
    NSDictionary *dict = not.userInfo;
    NSLog(@"我得到的信息%@",dict);
    NSArray *array = dict[@"items"];
    for (NSDictionary *d in array) {
        NoteModel *model = [[NoteModel alloc]init];
        [model setValuesForKeysWithDictionary:d];
        [self.noteArray addObject:model];
        [self createCollectionView];
        [ProgressHUD hideAfterSuccessOnView:self.view];
    }
}
-(void)createCollectionView
{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    layout.itemSize = CGSizeMake(140, 80);
    layout.minimumInteritemSpacing = 5 ;
    layout.minimumLineSpacing = 5 ;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT-20) collectionViewLayout:layout];
    _collectionView.backgroundColor=[UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"MyNoteCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"cellid"];
    [self.view addSubview:_collectionView];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.noteArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyNoteCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellid" forIndexPath:indexPath];
    NoteModel *model = self.noteArray[indexPath.item];
    
    [cell configUI:model];
    
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    NoteDetailViewController *ctrl = [[NoteDetailViewController alloc]init];
    NoteModel *model= self.noteArray[indexPath.item];
    ctrl.model=model;
    [self.navigationController pushViewController:ctrl animated:YES];
}


@end