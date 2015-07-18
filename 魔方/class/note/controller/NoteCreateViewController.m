//
//  NoteCreateViewController.m
//  魔方
//
//  Created by fengss on 15-5-14.
//  Copyright (c) 2015年 coderss. All rights reserved.
//

#import "NoteCreateViewController.h"

@interface NoteCreateViewController ()<UITextFieldDelegate,UITextViewDelegate>

@end

@implementation NoteCreateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"笔记创建";
    UIBarButtonItem *item=[[UIBarButtonItem alloc]initWithTitle:@"创建" style:UIBarButtonItemStyleDone target:self action:@selector(createNote)];
    
    //初始化
    self.mytitle.delegate=self;
    self.content.delegate=self;
    
    self.navigationItem.rightBarButtonItem=item;
}

-(void)createNote{
    AppDelegate *app=[UIApplication sharedApplication].delegate;
    
    if ([self.content.text isEqual:@"笔记内容"]||self.content.text==nil||self.mytitle.text==nil||[self.mytitle.text isEqual:@""]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提 示" message:@"请填写笔记内容" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        return;
    }
    
    NSDictionary *dic=@{
                        @"uid":[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"],
                        @"vid":self.vid,
                        @"content":self.content.text,
                        @"title":self.mytitle.text
                        };
    [app.manger POST:NOTEADD parameters:dic success:^(NSURLSessionDataTask *task, id responseObject) {
        NSString *str=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        if ([str isEqual:@"yes"]) {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提 示" message:@"笔记记录成功!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
        else{
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提 示" message:@"笔记记录失败!" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}

#pragma mark textField delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}


#pragma mark textView delegate
-(void)textViewDidBeginEditing:(UITextView *)textView{
    textView.text=@"";
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
