//
//  ClientCell.h
//  PersonalTraining
//
//
//

#import <UIKit/UIKit.h>
#import "QuestionModel.h"
@class AsyncImageView;

@interface SampleCell : UITableViewCell {

}
-(void)configUI:(QuestionModel *)model;
@property (retain, nonatomic) IBOutlet UILabel *labelForPlace;
@property (retain, nonatomic) IBOutlet UILabel *labelForCountry;
@property (retain, nonatomic) IBOutlet UIImageView *myimageview;
@property (weak, nonatomic) IBOutlet UILabel *destLabel;
@property (weak, nonatomic) IBOutlet UILabel *status;

@end
