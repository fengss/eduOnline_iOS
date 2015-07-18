
//
//  ExamSelectCtrl.m
//  3G学院
//
//  Created by coderss on 15/5/5.
//  Copyright (c) 2015年 coderss. All rights reserved.
//

#import "ExamSelectCtrl.h"
#import "CheckNetworkManager.h"
#import "AFNetworkReachabilityManager.h"
#import "LoadDataManager.h"
#import "HeaderFile.h"
#import "TestPaper.h"
#import "examController.h"
#define kCellReusedId (@"cellId")
@interface ExamSelectCtrl ()<UICollectionViewDataSource,UICollectionViewDelegate>
{
     UICollectionView *_collectionView;
}
@property(nonatomic,strong)NSMutableArray *dataArray;
@end

@implementation ExamSelectCtrl
-(NSMutableArray *)dataArray
{
    if (_dataArray == nil) {
        _dataArray = [[NSMutableArray alloc]init];
    }
    return _dataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.navigationItem.title=@"试卷中心";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetWork:) name:@"testPaper" object:nil];
    CheckNetworkManager  *networkManager = [CheckNetworkManager shareCheckNetworkManager];
    [networkManager checkNetWorkWithNotName:@"testPaper"];
    }
-(void)checkNetWork:(NSNotification *)not
{
    NSDictionary *dict = not.userInfo;
    NSString *isConnected = [dict valueForKey:@"infoForNetWork"];
    if ([isConnected isEqualToString:@"yes"]) {
        [self createProgressUI];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadData:) name:@"testPaperData" object:nil];
        LoadDataManager *manager = [LoadDataManager shareLoadDataManager];
        NSString *str = [NSString stringWithFormat:@"%ld",self.whichType];
        NSString *url = [NSString stringWithFormat:@"%@%@",TESTPAPER,str];
        NSLog(@"%@",url);
        [manager loadDataWithURL:url WithNotname:@"testPaperData"];
    }
    else
    {
        UIAlertView  *av = [[UIAlertView alloc]initWithTitle:@"提 示" message:@"未检测到网络，请检查你的网络设置" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [av show];
    }
}

-(void)createCollectionView
{
    UICollectionViewFlowLayout   *layout = [[UICollectionViewFlowLayout alloc]init];
    layout.itemSize = CGSizeMake(140, 120);
    layout.minimumInteritemSpacing = 5;
    layout.minimumLineSpacing = 10;
    layout.minimumLineSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(5, 5, 5, 5);
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 20, 320, SCREEN_HEIGHT-20) collectionViewLayout:layout];
    _collectionView.backgroundColor = [[UIColor alloc]initWithRed:170 green:225 blue:255 alpha:35];
    _collectionView.layer.shadowColor=[UIColor blackColor].CGColor;
    _collectionView.layer.shadowOpacity=true;
    _collectionView.layer.shadowRadius=10.0f;
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kCellReusedId];
    [self.view addSubview:_collectionView];
}

-(void)loadData:(NSNotification *)not
{
    NSDictionary *dict  = not.userInfo;
    NSArray *array = dict[@"items"];
    NSLog(@"%@",array);
    for(NSDictionary *d in array)
    {
        TestPaper *model = [[TestPaper alloc]init];
        [model setValuesForKeysWithDictionary:d];
        [self.dataArray addObject:model];
    }
    [self createCollectionView];
    UIView *view = [self.view viewWithTag:100];
    [ProgressHUD hideOnView:view];
}

-(void)createProgressUI
{
    UIView *progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 64 - 49)];
    progressView.backgroundColor = [UIColor whiteColor];
    progressView.tag = 100;
    [self.view addSubview:progressView];
    [ProgressHUD showOnView:progressView];
}
-(void)navBackBtn
{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell= [collectionView dequeueReusableCellWithReuseIdentifier:kCellReusedId forIndexPath:indexPath];
    for (UIView  *oldView in cell.contentView.subviews) {
        [oldView removeFromSuperview];
    }
    cell.contentView.layer.cornerRadius =  30.0f;
    cell.contentView.layer.masksToBounds = YES;
    TestPaper *model = self.dataArray[indexPath.item];
    NSString *str = model.title;
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5, 30, 150, 40)];
    label.text = str;
    UILabel *label1 = [[UILabel alloc] initWithFrame:CGRectMake(5, 80, 150, 40)];
    label1.text = model.addtime;
    label1.font =[UIFont systemFontOfSize:10];
    [label setTintColor:[UIColor blackColor]];
    [cell.contentView addSubview:label];
    [cell.contentView addSubview:label1];
    cell.layer.borderColor=[UIColor blueColor].CGColor;
    cell.layer.borderWidth=0.3;
    cell.layer.masksToBounds=YES;
    cell.layer.cornerRadius=10.0f;
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    examController *exam = [[examController alloc]init];
    TestPaper *model = self.dataArray[indexPath.item];
    exam.id = model.id;
    [self.navigationController pushViewController:exam animated:YES];
}
@end
