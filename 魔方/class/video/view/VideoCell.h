//
//  VideoCell.h
//  3G学院
//
//  Created by coderss on 15/4/27.
//  Copyright (c) 2015年 coderss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VideoItemModel.h"
#import "HeaderFile.h"
@interface VideoCell : UITableViewCell
+(instancetype)cellWithTableView:(UITableView *)tableView;
@property(nonatomic,strong)VideoItemModel *cellModel;
@end
