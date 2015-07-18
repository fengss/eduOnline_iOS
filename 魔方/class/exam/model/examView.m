
#import "examView.h"
@interface examView()

@end
@implementation examView

-(void)awakeFromNib{
    self.examContent.layer.cornerRadius=20.0f;
    self.examContent.layer.masksToBounds=YES;
}

- (IBAction)aBtnClick:(UIButton *)sender1 {
    sender1.imageView.hidden = NO;
    self.selectBtn = sender1;
    self.bBtn.imageView.hidden = YES;
    self.cBtn.imageView.hidden = YES;
    self.dBtn.imageView.hidden = YES;
}

- (IBAction)bBtnClick:(UIButton *)sender2 {
    self.selectBtn = sender2;
    sender2.imageView.hidden = NO;
    self.cBtn.imageView.hidden = YES;
    self.aBtn.imageView.hidden = YES;
    self.dBtn.imageView.hidden = YES;
}

- (IBAction)cBtnClick:(UIButton *)sender3 {
    self.selectBtn = sender3;
    sender3.imageView.hidden = NO;
    self.aBtn.imageView.hidden = YES;
    self.bBtn.imageView.hidden = YES;
    self.dBtn.imageView.hidden = YES;
}

- (IBAction)dBtnClick:(UIButton *)sender4 {
    self.selectBtn = sender4;
    sender4.imageView.hidden = NO;
    self.aBtn.imageView.hidden = YES;
    self.bBtn.imageView.hidden = YES;
    self.cBtn.imageView.hidden = YES;
}

-(void)config:(TestModel *)model
{
    self.aBtn.imageView.hidden = YES;
    self.bBtn.imageView.hidden = YES;
    self.cBtn.imageView.hidden = YES;
    self.dBtn.imageView.hidden = YES;
    self.anwer1.text = model.aA;
    self.answer2.text = model.aB;
    self.answer3.text = model.aC;
    self.answer4.text = model.aD;
    self.examContent.text = model.content;
}
@end
