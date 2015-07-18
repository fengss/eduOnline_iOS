//
//  MessageForum.h
//  3G学院
//
//  Created by coderss on 15/4/28.
//  Copyright (c) 2015年 coderss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"
@interface MessageForum : UIView
@property (weak, nonatomic) IBOutlet UIButton *MessageBtn;
@property (weak, nonatomic) IBOutlet UIButton *AllMessageBtn;
@property (weak, nonatomic) IBOutlet UIButton *publishMessagebBtn;
@property (weak, nonatomic) IBOutlet UIButton *MessagePersonalCenterBtn;
@property (weak, nonatomic) IBOutlet UIView *mycollectionView;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;

@end
