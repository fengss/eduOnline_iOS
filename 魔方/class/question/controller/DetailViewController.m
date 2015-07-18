//
//  DetailViewController.m
//  AnimationMaximize
//
//  Created by mayur on 7/31/13.
//  Copyright (c) 2013 mayur. All rights reserved.
//

#import "DetailViewController.h"
#import "UIImageView+WebCache.h"
#import "HeaderFile.h"
@interface DetailViewController ()

@end

@implementation DetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //进入后判断  是否已经收藏
    self.navigationController.navigationBar.hidden = YES;
    
    [self animateOnEntry];
    
    //载入数据
    [self loadData];
}
- (void) animateOnEntry
{
    self.backgroundImageView.alpha = 0;
    
    self.userName.frame = CGRectMake(25, self.yOrigin + MAIN_LABEL_Y_ORIGIN, self.userName.frame.size.width, self.userName.frame.size.height);
    self.timeLabel.frame = CGRectMake(25, self.yOrigin + MAIN_LABEL_Y_ORIGIN, self.timeLabel.frame.size.width, self.timeLabel.frame.size.height);
    self.label1.frame = CGRectMake(25, self.yOrigin + MAIN_LABEL_Y_ORIGIN, self.label1.frame.size.width, self.label1.frame.size.height);
    self.label.frame = CGRectMake(25, self.yOrigin + MAIN_LABEL_Y_ORIGIN, self.label.frame.size.width, self.label.frame.size.height);
    self.question.frame = CGRectMake(25, self.yOrigin + MAIN_LABEL_Y_ORIGIN, self.question.frame.size.width, self.question.frame.size.height);
    self.questionContent.frame = CGRectMake(25, self.yOrigin + MAIN_LABEL_Y_ORIGIN, self.questionContent.frame.size.width, self.questionContent.frame.size.height);
    self.backgroundImageView.frame = CGRectMake(0, self.yOrigin + MAIN_LABEL_Y_ORIGIN, self.view.frame.size.width, self.labelForPlace.frame.size.height + self.labelForCountry.frame.size.height-80);
    self.labelForPlace.frame = CGRectMake(25, self.yOrigin + MAIN_LABEL_Y_ORIGIN, self.labelForPlace.frame.size.width, self.labelForPlace.frame.size.height);
    self.labelForCountry.frame = CGRectMake(25, self.labelForPlace.frame.origin.y + self.labelForCountry.frame.size.height, self.labelForCountry.frame.size.width, self.labelForCountry.frame.size.height);
    self.imageView.frame = CGRectMake(30, self.yOrigin + IMAGEVIEW_Y_ORIGIN, 30, 30);
    self.collectBtn.frame = CGRectMake(25, self.collectBtn.frame.origin.y + self.collectBtn.frame.size.height, self.collectBtn.frame.size.width, self.collectBtn.frame.size.height);
    [self.doneBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    self.doneBtn.frame = CGRectMake(self.doneBtn.frame.origin.x, 0-self.doneBtn.frame.size.height-20, self.doneBtn.frame.size.width, self.doneBtn.frame.size.height);
    [self.collectBtn addTarget:self action:@selector(collectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [UIView animateWithDuration:0.4f
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^(void)
     {
         self.labelForPlace.frame = CGRectMake(128, 131, 150, 21);
         self.labelForCountry.frame = CGRectMake(128, 110, 250,21);
         
         self.doneBtn.frame = CGRectMake(self.doneBtn.frame.origin.x, 20, self.doneBtn.frame.size.width, self.doneBtn.frame.size.height);
         self.backgroundImageView.frame = CGRectMake(0, 0, self.view.frame.size.width, 250);
     
         self.backgroundImageView.alpha = 1;
         self.collectBtn.frame = CGRectMake(190, 250, 150, 30);
         self.userName.frame = CGRectMake(56, 110, 100, 21);
         self.timeLabel.frame = CGRectMake(56, 131, 60, 21);
         self.label.frame = CGRectMake(56, 154, 42, 21);
         self.label1.frame = CGRectMake(128, 154, 142, 21);
         self.question.frame = CGRectMake(56, 177, 42, 21);
         self.questionContent.frame = CGRectMake(128, 177, 176, 50);
         self.questionContent.numberOfLines = 5;
         NSLog(@"width %f height %f",self.imageView.frame.size.width,self.imageView.frame.size.height);
         
         self.imageView.frame = CGRectMake(98, 26,60, 60);
     }
                     completion:NULL];
}

-(void)loadData{
    AppDelegate *app=[UIApplication sharedApplication].delegate;
    [app.manger GET:[NSString stringWithFormat:@"http://edu.coderss.cn/index.php/Question/showForIos/id/%@",self.model.id] parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
 
            NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            self.labelForPlace.text =self.model.addtime;
            self.labelForCountry.text = self.model.username;
            self.label1.text = [dic objectForKey:@"cname"];
            self.questionContent.text = self.model.content;
            self.questionContent.numberOfLines = 5;
            [self.imageView  setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:USERICO,self.model.username,self.model.picture]] placeholderImage:[UIImage imageNamed:@"images-6"]];
            self.reply_username.text=[dic objectForKey:@"tname"];
            self.reply_content.text=[dic objectForKey:@"replay"];
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

#warning 收藏路径有问题
-(void)collectBtnClick
{
   /*
    问吧收藏功能
    post传递
    vv:n
    mid:你的帖子
    uid 用户的id
    如果返回yes为成功否则no为失败
    如果返回yes为成功 否则no
    */
    NSDictionary *dict = @{@"uid":[[NSUserDefaults standardUserDefaults]objectForKey:@"userid"],@"mid":self.model.id,@"vv":@"n"};
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFCompoundResponseSerializer serializer];
    [manager POST:QUESTIONLIKEURL  parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSString *str=[[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@",str);
        //测试用NO
        if ([str isEqualToString:@"no"]) {
            self.collectBtn.titleLabel.text = @"已收藏";
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)doneBtnPressed:(id)sender
{
    [UIView animateWithDuration:0.4f animations:^
     {
         self.backgroundImageView.frame = CGRectMake(0, self.yOrigin + MAIN_LABEL_Y_ORIGIN, self.view.frame.size.width, self.labelForPlace.frame.size.height + self.labelForCountry.frame.size.height);
         self.labelForPlace.frame = CGRectMake(70, self.yOrigin + MAIN_LABEL_Y_ORIGIN, self.labelForPlace.frame.size.width, self.labelForPlace.frame.size.height);
         self.labelForCountry.frame = CGRectMake(70, self.labelForPlace.frame.origin.y + self.labelForPlace.frame.size.height, self.labelForCountry.frame.size.width, self.labelForCountry.frame.size.height);
         self.imageView.frame = CGRectMake(10, self.yOrigin + IMAGEVIEW_Y_ORIGIN, CGRectGetWidth(self.imageView.frame) / 2, CGRectGetHeight(self.imageView.frame) / 2);
         self.doneBtn.frame = CGRectMake(self.doneBtn.frame.origin.x, 0-self.doneBtn.frame.size.height-20, self.doneBtn.frame.size.width, self.doneBtn.frame.size.height);
         self.backgroundImageView.alpha = 0;
         self.userName.frame = CGRectMake(56, self.yOrigin + MAIN_LABEL_Y_ORIGIN, 50, 21);
         self.userName.alpha = 0 ;
         self.timeLabel.frame = CGRectMake(56, self.yOrigin + MAIN_LABEL_Y_ORIGIN, 60, 21);
         self.timeLabel.alpha = 0;
         self.label.frame = CGRectMake(56, self.yOrigin + MAIN_LABEL_Y_ORIGIN, 42, 21);
         self.label.alpha = 0 ;
         self.label1.frame = CGRectMake(123, self.yOrigin + MAIN_LABEL_Y_ORIGIN, 142, 21);
         self.label1.alpha = 0 ;
         self.question.frame = CGRectMake(56, self.yOrigin + MAIN_LABEL_Y_ORIGIN, 42, 21);
         self.question.alpha = 0 ;
         self.questionContent.frame = CGRectMake(123, self.yOrigin + MAIN_LABEL_Y_ORIGIN, 176, 21);
         self.questionContent.alpha = 0 ;
         self.collectBtn.frame = CGRectMake(247, self.yOrigin + MAIN_LABEL_Y_ORIGIN, 100, 21);
         self.collectBtn.alpha = 0 ;
        
     }
                     completion:^(BOOL finished)
     {
         self.navigationController.navigationBar.hidden = NO;
         [self.navigationController popViewControllerAnimated:NO];
     }
     ];
}

@end
