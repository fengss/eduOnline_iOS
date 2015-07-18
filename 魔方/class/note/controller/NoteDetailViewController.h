//
//  NoteDetailViewController.h
//  魔方
//
//  Created by coderss on 15/5/12.
//  Copyright (c) 2015年 coderss. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteModel.h"
#import "KOPopupView.h"
@interface NoteDetailViewController : UIViewController
@property(nonatomic,strong)NSString *id;
@property(nonatomic,strong)NoteModel *model;
//弹出框
@property (nonatomic, strong) KOPopupView *popup;
@end
