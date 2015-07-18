#import <UIKit/UIKit.h>
#import "LibraryModel.h"

@interface PassCell : UICollectionViewCell

@property (nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic) IBOutlet UIButton *infoButton;
@property (nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIButton *userName;
@property (weak, nonatomic) IBOutlet UIButton *type;
@property(nonatomic,strong) LibraryModel  * model;
@property(nonatomic,weak) UIViewController  * mainViewController;
- (IBAction)goLook:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *lookDesc;

- (void)flipTransitionWithOptions:(UIViewAnimationOptions)options halfway:(void (^)(BOOL finished))halfway completion:(void (^)(BOOL finished))completion;

-(void)configUI:(LibraryModel*)model;
@end
