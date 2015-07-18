//
//  NoteCreateViewController.h
//  魔方
//
//  Created by fengss on 15-5-14.
//  Copyright (c) 2015年 coderss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoteCreateViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *mytitle;
@property (weak, nonatomic) IBOutlet UITextView *content;

@property(nonatomic,strong) NSString  * vid;
@end
