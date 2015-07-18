//
//  ForumCell.m
//  3G学院
//
//  Created by coderss on 15/4/28.
//  Copyright (c) 2015年 coderss. All rights reserved.
//

#import "ForumCell.h"
@interface ForumCell()
@property (weak, nonatomic) IBOutlet UIImageView *bgImageView;
@property (weak, nonatomic) IBOutlet UILabel *forumTitle;

@end
@implementation ForumCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        {
         // self.layer
        }
    }
    return self;
}
-(void)makeForumCell:(NSString *)forumTitle bgImageStr:(NSString *)imageStr
{
    self.bgImageView.image = [UIImage imageNamed:imageStr];
    self.forumTitle.text = forumTitle;
}
@end
