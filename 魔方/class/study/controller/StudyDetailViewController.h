//
//  StudyDetailViewController.h
//  魔方
//
//  Created by fengss on 15-5-15.
//  Copyright (c) 2015年 coderss. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StudyDetailViewController : UIViewController
@property(nonatomic,copy) NSString  * name;
@property (weak, nonatomic) IBOutlet UIWebView *webview;
@end
