//
//  ClientCell.m
//  PersonalTraining
//
//
//

#import "SampleCell.h"
#import "HeaderFile.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#define CLIENT_IMG_WIDTH 41
#define CLIENT_IMG_HEIGHT 41
/*
 @property (retain, nonatomic) IBOutlet UILabel *labelForPlace;
 @property (retain, nonatomic) IBOutlet UILabel *labelForCountry;
 @property (retain, nonatomic) IBOutlet UIImageView *imageview;
 @property (weak, nonatomic) IBOutlet UITextView *descText;
 */
@implementation SampleCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
    }
    return self;
}
-(void)configUI:(QuestionModel *)model
{
    CALayer *layer = self.myimageview.layer;
    layer.cornerRadius = 40;
    layer.masksToBounds = YES;
    self.labelForPlace.text = model.username;
    self.labelForCountry.text = model.addtime;
    self.destLabel.text = model.content;
    NSLog(@"*****%@",model.content);
    NSString *status = model.status;
    if ([status isEqualToString:@"0"]) {
        self.status.text = @"已回复";
        self.status.backgroundColor = [UIColor lightGrayColor];
        CALayer *layer = self.status.layer;
        layer.cornerRadius = 10;
        layer.borderWidth = 1.0;
        layer.masksToBounds = YES;
        layer.borderColor = [UIColor  orangeColor].CGColor;
    }
    else
    {
        self.status.text = @"未回复";
        self.status.backgroundColor = [UIColor lightGrayColor];
        CALayer *layer = self.status.layer;
        layer.cornerRadius = 10;
        layer.borderWidth = 1.0;
        layer.masksToBounds = YES;
        layer.borderColor = [UIColor  greenColor].CGColor;
    }
    [self.myimageview setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:USERICO,model.username,model.picture]]];
    
}
@end
