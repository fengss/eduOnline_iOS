//
//  UserRegisterViewController.m
//  魔方
//
//  Created by coderss on 15/5/13.
//  Copyright (c) 2015年 coderss. All rights reserved.
//

#import "UserRegisterViewController.h"
#import "HeaderFile.h"
@interface UserRegisterViewController ()<UIGestureRecognizerDelegate>
{
    UITextField * usernameTf;
    UITextField * passwordTf;
    UITextField * repasswordTf;
    UITextField * emailTf;
}
@property (strong, nonatomic) UIView *usernameView;
@property (strong, nonatomic) UIView *passwordView;
@property(strong,nonatomic)   UIView *repasswordView;
@property(strong,nonatomic)   UIView *emailView;
@property (strong, nonatomic) UIView *sendButtonView;
@end

@implementation UserRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    bgImageView.image  = [UIImage imageNamed:@"MenuBackground"];
    [self.view addSubview:bgImageView];
    bgImageView.userInteractionEnabled = YES;
    
    UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(120-30, 60, 60, 60)];
    view.image = [UIImage imageNamed:@"register1"];
    [self.view addSubview:view];

    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(20,40, 50, 50)];
    [backBtn setImage:[UIImage imageNamed:@"delete4"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [bgImageView addSubview:backBtn];
    
    
    [self setViewItems];
   
}
- (void) setViewItems
{
    _usernameView = [[UIView alloc] initWithFrame:CGRectMake(20, 145, 280, 50)];
    _usernameView.backgroundColor = [UIColor colorWithRed:0.925 green:0.941 blue:0.945 alpha:0.3];
    
    _passwordView = [[UIView alloc] initWithFrame:CGRectMake(20, 195, 280, 50)];
    _passwordView.backgroundColor = [UIColor colorWithRed:0.925 green:0.941 blue:0.945 alpha:0.3];
    
    _repasswordView = [[UIView alloc] initWithFrame:CGRectMake(20, 245, 280, 50)];
    _repasswordView.backgroundColor = [UIColor colorWithRed:0.925 green:0.941 blue:0.945 alpha:0.3];

    
    _emailView = [[UIView alloc] initWithFrame:CGRectMake(20, 295, 280, 50)];
    _emailView.backgroundColor = [UIColor colorWithRed:0.925 green:0.941 blue:0.945 alpha:0.3];

    
    _sendButtonView = [[UIView alloc] initWithFrame:CGRectMake(20, 355, 280, 50)];
    _sendButtonView.backgroundColor = [UIColor colorWithRed:0.925 green:0.941 blue:0.945 alpha:0.7];
    
    //BUTTON
    UIButton * sendButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, _sendButtonView.frame.size.width, _sendButtonView.frame.size.height)];
    [sendButton setTitle:@"REGISTER" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor colorWithRed:0.173 green:0.243 blue:0.314 alpha:1] forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(registerClick) forControlEvents:UIControlEventTouchUpInside];
    [_sendButtonView addSubview:sendButton];
    
    //USERNAME Text Field
    UIImageView * userImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 61, 50)];
    [userImage setImage:[UIImage imageNamed:@"user.png"]];
    [_usernameView addSubview:userImage];
    usernameTf = [[UITextField alloc]initWithFrame:CGRectMake(60, 10, 150, 30)];
    usernameTf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"USERNAME" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    usernameTf.textColor = [UIColor whiteColor];
    [_usernameView addSubview:usernameTf];
    
    
    
    UIImageView * lockImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 61, 50)];
    [lockImage setImage:[UIImage imageNamed:@"lock.png"]];
    [_passwordView addSubview:lockImage];
    passwordTf = [[UITextField alloc]initWithFrame:CGRectMake(60, 10, 150, 30)];
    passwordTf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"PASSWORD" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    passwordTf.textColor = [UIColor whiteColor];
    [_passwordView addSubview:passwordTf];
    passwordTf.secureTextEntry = YES;
    
    UIImageView * relockImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 61, 50)];
    [relockImage setImage:[UIImage imageNamed:@"lock.png"]];
    [_repasswordView addSubview:relockImage];
    repasswordTf = [[UITextField alloc]initWithFrame:CGRectMake(60, 10, 150, 30)];
    repasswordTf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"确认密码" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    repasswordTf.textColor = [UIColor whiteColor];
    [_repasswordView addSubview:repasswordTf];
    repasswordTf.secureTextEntry = YES;

    
    UIImageView * emailImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 61, 50)];
    [emailImage setImage:[UIImage imageNamed:@"lock.png"]];
    [_emailView addSubview:emailImage];
     emailTf = [[UITextField alloc]initWithFrame:CGRectMake(60, 10, 150, 30)];
     emailTf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"EMAIL" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
     emailTf.textColor = [UIColor whiteColor];
    [_emailView addSubview:emailTf];
    
    [self.view addSubview:_usernameView];
    [self.view addSubview:_passwordView];
    [self.view addSubview:_repasswordView];
    [self.view addSubview:_emailView];
    [self.view addSubview:_sendButtonView];
}
-(void)registerClick
{
    NSString *userName = usernameTf.text;
    NSString *paswd = passwordTf.text;
    NSString *repasswd = repasswordTf.text;
    NSString *email = emailTf.text;
    if ([userName isEqualToString:@""]||[paswd isEqualToString:@""]||[repasswd isEqualToString:@""]||[email isEqualToString:@""]) {
        UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请将信息填写完整" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil, nil];
        [av show];
    }
    else
    {
        if (![paswd isEqualToString:repasswd]) {
            UIAlertView *view = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请确认两次输入的密码一致" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [view show];
        }
        else
        {
            AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
            manager.responseSerializer  = [AFHTTPResponseSerializer serializer];
            NSDictionary *dic = @{@"email":email,@"userpass":paswd,@"reuserpass":repasswd,@"username":userName};
            NSLog(@"%@  %@",USERREGISTER,dic);
            [manager GET:USERREGISTER parameters:dic
                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
                     id  jsonData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                     //注册成功
                     //注册有问题
                     [self dismissViewControllerAnimated:YES completion:nil];
                 } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                     
                 }];
        }

    }

}
-(void)backClick
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
@end
