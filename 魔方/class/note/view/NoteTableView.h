//
//  NoteTableView.h
//  3G学院
//
//  Created by coderss on 15/5/7.
//  Copyright (c) 2015年 coderss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteModel.h"
@interface NoteTableView : UIView
@property(nonatomic,copy)void(^DetailNoteblock)(NoteModel *);
@property(nonatomic,copy)void(^block)(NSString *);
@property(nonatomic,copy)void(^myblock)( );
@end
