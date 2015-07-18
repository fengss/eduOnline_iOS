//
//  MessageReplyCell.h
//  魔方
//
//  Created by 沈伟 on 15/5/20.
//  Copyright (c) 2015年 coderss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageReplyModel.h"

@interface MessageReplyCell : UITableViewCell

-(void)configUI:(MessageReplyModel*)model;
@end
