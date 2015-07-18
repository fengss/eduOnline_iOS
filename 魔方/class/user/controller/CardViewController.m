//
//  TestViewController.m
//  StrechyParallaxScrollView
//
//  Created by Cem Olcay on 12/09/14.
//  Copyright (c) 2014 questa. All rights reserved.
//

#import "CardViewController.h"
#import "Masonry.h"
#import "StrechyParallaxScrollView.h"
#import "User.h"

#define RGBCOLOR(r,g,b)     [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]

@interface CardViewController ()
//头像
@property(nonatomic,strong)UIImageView *circle;
//用户id
@property(nonatomic,strong) UILabel *label;
@end

@implementation CardViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

//数据载入
-(void)loadDataWithFrame:(UIImageView*)topView{
    AppDelegate *app=[UIApplication sharedApplication].delegate;
    NSString *url=[GETUSERDESC stringByAppendingString:[NSString stringWithFormat:@"&id=%@",self.userid]];
    [app.manger GET:url parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        if ([[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil] isKindOfClass:[NSDictionary class]]) {
            NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            self.user=[[User alloc]init];
            [self.user setValuesForKeysWithDictionary:dic];
             
            //添加元素
            StrechyParallaxScrollView *strechy = [[StrechyParallaxScrollView alloc] initWithFrame:self.view.frame andTopView:topView];
            [self.view addSubview:strechy];
            float itemStartY = topView.frame.size.height + 10;
            for (int i = 1; i <= 4; i++) {
                switch (i) {
                    case 1:
                        [strechy addSubview:[self scrollViewItemWithY:itemStartY andString:[NSString stringWithFormat:@"姓名 - %@",self.user.name]]];
                        break;
                    case 2:
                        [strechy addSubview:[self scrollViewItemWithY:itemStartY andString:[NSString stringWithFormat:@"年龄 - %@",self.user.age]]];
                        break;
                    case 3:
                        [strechy addSubview:[self scrollViewItemWithY:itemStartY andString:[NSString stringWithFormat:@"简介 - %@",self.user.introduce]]];
                        break;
                        
                    case 4:
                        [strechy addSubview:[self scrollViewItemWithY:itemStartY andString:[NSString stringWithFormat:@"邮件 - %@",self.user.email]]];
                        break;
                    default:
                        break;
                }
                
                itemStartY += 190;
            }
            [strechy setContentSize:CGSizeMake(SCREEN_WIDTH, itemStartY)];
            [self.circle setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:USERICO,self.user.username,self.user.picture]]];
            self.title=self.user.name;
            self.label.text=self.user.username;
        }
        
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent=NO;
    self.view.backgroundColor=[UIColor whiteColor];
    //top view
    CGFloat width = [[UIScreen mainScreen] bounds].size.width;
    UIImageView *topView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, 150)];
    [topView setImage:[UIImage imageNamed:@"bg.jpg"]];
    [topView setBackgroundColor:RGBCOLOR(128, 26, 26)];
    
    self.circle = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 80, 80)];
    [self.circle setImage:[UIImage imageNamed:@"profile.jpg"]];
    [self.circle setCenter:topView.center];
    [self.circle.layer setMasksToBounds:YES];
    [self.circle.layer setCornerRadius:40];
    [topView addSubview:self.circle];
    
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 120, width, 20)];
    [self.label setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:20]];
    [self.label setTextAlignment:NSTextAlignmentCenter];
    [self.label setTextColor:[UIColor whiteColor]];
    [topView addSubview:self.label];

    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo (self.circle.mas_bottom).offset (10);
        make.centerX.equalTo (topView);
    }];
    [self.circle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.equalTo ([NSValue valueWithCGSize:CGSizeMake(80, 80)]);
        make.center.equalTo (topView);
    }];
    
    
    
    
    //添加元素
    [self loadDataWithFrame:topView];
}

- (UILabel *)scrollViewItemWithY:(CGFloat)y andString:(NSString*)string {
    UILabel *item = [[UILabel alloc] initWithFrame:CGRectMake(10, y, [UIScreen mainScreen].bounds.size.width-20, 180)];
    [item setBackgroundColor:[self randomColor]];
    [item setText:[NSString stringWithFormat:@" %@ ", string]];
    [item setTextAlignment:NSTextAlignmentCenter];
    [item setFont:[UIFont fontWithName:@"HelveticaNeue-Light" size:26]];
    [item setTextColor:[UIColor whiteColor]];
    return item;
}

- (UIColor *)randomColor {
    CGFloat hue = ( arc4random() % 256 / 256.0 );  //  0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5;  //  0.5 to 1.0, away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
