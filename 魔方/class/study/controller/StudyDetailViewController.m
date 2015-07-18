//
//  StudyDetailViewController.m
//  魔方
//
//  Created by fengss on 15-5-15.
//  Copyright (c) 2015年 coderss. All rights reserved.
//

#import "StudyDetailViewController.h"
#import "HeaderFile.h"
@interface StudyDetailViewController ()

@end

@implementation StudyDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"资料详情";
    [ProgressHUD showOnView:self.view];
}
-(void)viewDidAppear:(BOOL)animated
{
      [super viewDidAppear:YES];
      [self loadDocument:self.name inView:self.webview];
}
 -(void)loadDocument:(NSString *)documentName inView:(UIWebView *)webView
 {
     
     NSString *path = [NSString stringWithFormat:LIBRARAYDETAIL,documentName];
     NSURL *url = [NSURL URLWithString:path];
     NSURLRequest *request=[[NSURLRequest alloc]initWithURL:url];
     NSURLResponse *respnose=nil;
     NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&respnose error:NULL];
     [webView loadData:data MIMEType:respnose.MIMEType textEncodingName:@"utf-8" baseURL:nil];
     [ProgressHUD hideAfterSuccessOnView:self.view];
 }
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
