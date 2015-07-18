#import "StudyViewController.h"
#import "PassCell.h"
#import "MTCardLayout.h"
#import "UICollectionView+CardLayout.h"
#import "LSCollectionViewLayoutHelper.h"
#import "UICollectionView+Draggable.h"
#import "SearchViewController.h"
#import "LibraryModel.h"

@interface StudyViewController ()<SearchViewControllerDelegate, UICollectionViewDataSource_Draggable>

@property (nonatomic, strong) SearchViewController *searchViewController;
@property (nonatomic, strong) NSMutableArray * items;
@property(nonatomic,strong) NSMutableArray  * dataArr;
@end

@implementation StudyViewController

-(NSMutableArray *)dataArr{
    if (_dataArr==nil) {
        _dataArr=[NSMutableArray arrayWithCapacity:0];
    }
    return _dataArr;
}

#pragma mark Status Bar color

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark 加载数据
-(void)loadData{
    AppDelegate *app=[UIApplication sharedApplication].delegate;
    [app.manger GET:LIBRARYURL parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        if ([[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil] isKindOfClass:[NSDictionary class]]) {
            
            NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            
            NSArray *arr=[dic objectForKey:@"list"];
            for (NSDictionary *mydic in arr) {
                LibraryModel *model=[[LibraryModel alloc]init];
                [model setValuesForKeysWithDictionary:mydic];
                [self.dataArr addObject:model];
            }
            //刷新视图
            [self.collectionView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

#pragma mark - View Lifecycle

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.collectionView setPresenting:YES animated:YES completion:nil];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
    
    self.title=@"资料中心";
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu_left"] style:UIBarButtonItemStylePlain target:self action:@selector(presentLeftMenuViewController:)];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu_right"]  style:UIBarButtonItemStylePlain target:self action:@selector(presentRightMenuViewController:)];
    

    self.searchViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SearchViewController"];
    self.searchViewController.delegate = self;
	self.collectionView.backgroundView = self.searchViewController.view;

	UIImageView *dropOnToDeleteView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"trashcan"] highlightedImage:[UIImage imageNamed:@"trashcan_red"]];
	dropOnToDeleteView.center = CGPointMake(50, 300);
	self.collectionView.dropOnToDeleteView = dropOnToDeleteView;
	
	UIImageView *dragUpToDeleteConfirmView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"trashcan"] highlightedImage:[UIImage imageNamed:@"trashcan_red"]];
	self.collectionView.dragUpToDeleteConfirmView = dragUpToDeleteConfirmView;
    
    [self loadData];
}

#pragma mark - UICollectionViewDatasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
	return self.dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
	PassCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"pass" forIndexPath:indexPath];

    LibraryModel *model=self.dataArr[indexPath.row];
    
    [cell configUI:model];
    cell.mainViewController=self;
    
	return cell;
}

- (UIImage *)collectionView:(UICollectionView *)collectionView imageForDraggingItemAtIndexPath:(NSIndexPath *)indexPath
{
	UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
	CGSize size = cell.bounds.size;
	size.height = 72.0;
	
	UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
	CGContextRef context = UIGraphicsGetCurrentContext();
	[cell.layer renderInContext:context];
	
	UIImage * image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
	
	return image;
}

- (CGAffineTransform)collectionView:(UICollectionView *)collectionView transformForDraggingItemAtIndexPath:(NSIndexPath *)indexPath duration:(NSTimeInterval *)duration
{
	return CGAffineTransformMakeScale(1.05f, 1.05f);
}

- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    NSString * item = self.items[fromIndexPath.item];
    [self.items removeObjectAtIndex:fromIndexPath.item];
    [self.items insertObject:item atIndex:toIndexPath.item];
}

- (void)collectionView:(UICollectionView *)collectionView didMoveItemAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}

- (BOOL)collectionView:(UICollectionView *)collectionView canDeleteItemAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView deleteItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.items removeObjectAtIndex:indexPath.item];
}

- (void)collectionView:(UICollectionView *)collectionView didDeleteItemAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark SearchCell

- (void)searchControllerWillBeginSearch:(SearchViewController *)controller
{
    if (!self.collectionView.presenting)
    {
        [self.collectionView setPresenting:YES animated:YES completion:nil];
    }
}

- (void)searchControllerWillEndSearch:(SearchViewController *)controller
{
    if (self.collectionView.presenting)
    {
        [self.collectionView setPresenting:NO animated:YES completion:nil];
    }
}

#pragma mark Backside

- (IBAction)flip:(id)sender
{
	PassCell *cell = (PassCell *)[self.collectionView cellForItemAtIndexPath:[[self.collectionView indexPathsForSelectedItems] firstObject]];
	if (sender == cell.infoButton)
	{
		[cell flipTransitionWithOptions:UIViewAnimationOptionTransitionFlipFromLeft halfway:^(BOOL finished) {
			cell.infoButton.hidden = YES;
			cell.doneButton.hidden = NO;
		} completion:nil];
	}
	else
	{
		[cell flipTransitionWithOptions:UIViewAnimationOptionTransitionFlipFromRight halfway:^(BOOL finished) {
			cell.infoButton.hidden = NO;
			cell.doneButton.hidden = YES;
		} completion:nil];
	}
}

@end
