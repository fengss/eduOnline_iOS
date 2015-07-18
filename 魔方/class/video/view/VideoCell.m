//
//  VideoCell.m
//  3G学院
//
//  Created by coderss on 15/4/27.
//  Copyright (c) 2015年 coderss. All rights reserved.
//

#import "VideoCell.h"
#import "UIImageView+WebCache.h"
#import "HeaderFile.h"
@interface VideoCell()
@property (weak, nonatomic) IBOutlet UIImageView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *destLabel;
@end
@implementation VideoCell
+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *cellID = @"cellID";
    VideoCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (cell == nil) {
        
        cell = [[NSBundle mainBundle] loadNibNamed:@"VideoCell" owner:nil options:nil][0];
    }
    return cell;
}
-(void)setCellModel:(VideoItemModel *)cellModel
{
    self.bgView.image = [UIImage imageNamed:@"滚动图片2"];
    self.titleLabel.text = cellModel.name;
    NSString *bgImageUrl = [VIDEOCATPICURL stringByAppendingFormat:@"%@",cellModel.picture];
    NSLog(@"%@",bgImageUrl);
    [self.bgView setImageWithURL:[NSURL URLWithString:bgImageUrl]];
}
- (void)showImage:(UIImage *)image
{
    self.bgView.image = image;
    [self.contentView bringSubviewToFront:self.bgView];
}
@end
