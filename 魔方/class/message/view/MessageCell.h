//
//  MessageCell.h
//  3G学院
//
//  Created by coderss on 15/5/8.
//  Copyright (c) 2015年 coderss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"
@interface MessageCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIButton *userName;
@property (weak, nonatomic) IBOutlet UIView *bgImageView;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@property (weak, nonatomic) IBOutlet UILabel *addtime;
@property (weak, nonatomic) IBOutlet UILabel *scanAndCom;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
-(void)config:(Message *) message;
@end
