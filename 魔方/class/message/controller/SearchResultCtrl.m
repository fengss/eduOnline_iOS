
//
//  SearchResultCtrl.m
//  3G学院
//
//  Created by coderss on 15/5/10.
//  Copyright (c) 2015年 coderss. All rights reserved.
//

#import "SearchResultCtrl.h"
#import "Message.h"
#import "MyLayout.h"
#import "MessageCell.h"
#import "HeaderFile.h"
#define kCellReuseId (@"cellID")
@interface SearchResultCtrl ()<UICollectionViewDataSource,UICollectionViewDelegate,MyLayoutDelegate>
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,strong)NSMutableArray *heightForCellArray;
@end

@implementation SearchResultCtrl

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    self.title=@"贴吧搜索结果";
    [self makeHeightForCell];
    [self createNumberLabel];
    [self createCollectionView];
}
-(void)createNumberLabel
{
    UILabel *label  = [[UILabel alloc]initWithFrame:CGRectMake(30, 65, 260, 30)];
    label.text = [NSString stringWithFormat:@"共为你搜索到%ld条帖子",self.messageArray.count];
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提 示" message:label.text delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}
-(void)makeHeightForCell
{
    self.heightForCellArray = [[NSMutableArray alloc]init];
    for(int i = 0 ; i < self.messageArray.count;i++)
    {
        NSNumber *height = [[NSNumber alloc]initWithInt:arc4random()%100+140];
        [_heightForCellArray addObject:height];
    }
}
-(void)createCollectionView
{
    MyLayout *layout = [[MyLayout alloc] init];
    layout.sectionInsets = UIEdgeInsetsMake(5, 5, 5, 5);
    layout.itemSpace = 5;
    layout.lineSpace = 10;
    layout.delegate = self;
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, 320, SCREEN_HEIGHT-64) collectionViewLayout:layout];
    _collectionView.delegate = self;
    _collectionView.backgroundColor=[UIColor whiteColor];
    _collectionView.dataSource = self;
    [_collectionView registerNib:[UINib nibWithNibName:@"MessageCell" bundle:nil] forCellWithReuseIdentifier:kCellReuseId];
    [self.view addSubview:_collectionView];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.messageArray.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MessageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellReuseId forIndexPath:indexPath];
    Message *model = self.messageArray[indexPath.row];
    NSLog(@"%@",model.title);
    [cell config:model];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    Message *model = self.messageArray[indexPath.item];
    NSLog(@"^^^^^^^^^^%@",model.title);
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
@end
