//
//  MyNoteCell.h
//  魔方
//
//  Created by fengss on 15-5-13.
//  Copyright (c) 2015年 coderss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteModel.h"

@interface MyNoteCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UIImageView *icoImageView;


-(void)configUI:(NoteModel*)note;
@end
