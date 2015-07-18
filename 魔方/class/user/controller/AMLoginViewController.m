//
//  AMLoginViewController.m
//  魔方
//
//  Created by coderss on 15/5/13.
//  Copyright (c) 2015年 coderss. All rights reserved.
//

#import "AMLoginViewController.h"
#import "HeaderFile.h"
#import "User.h"
#import "UserRegisterViewController.h"
@interface AMLoginViewController ()
{
    UITextField * usernameTf;
    UITextField * passwordTf;
}

@end

@implementation AMLoginViewController
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
    bgImageView.image  = [UIImage imageNamed:@"MenuBackground"];
    [self.view addSubview:bgImageView];
    bgImageView.userInteractionEnabled = YES;
    [self setViewItems];
   
   
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(20,40, 50, 50)];
    [backBtn setImage:[UIImage imageNamed:@"delete4"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    [bgImageView addSubview:backBtn];
    
    UIButton *registerBtn = [[UIButton alloc]initWithFrame:CGRectMake(320-70,40, 50, 50)];
    [registerBtn setImage:[UIImage imageNamed:@"register"] forState:UIControlStateNormal];
    [registerBtn addTarget:self action:@selector(resgisterClick) forControlEvents:UIControlEventTouchUpInside];
   [bgImageView addSubview:registerBtn];
    
    
    //GESTURE - Dismiss the keyboard when tapped on the controller's view
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
    tap.delegate = self;
}
-(void)resgisterClick
{
    UserRegisterViewController *ctrl = [[UserRegisterViewController alloc]init];
//    [self presentViewController:ctrl animated:YES completion:nil];
    //ctrl.modalTransitionStyle = UIModalTransitionStylePartialCurl;
    //[self presentViewController:ctrl animated:YES completion:nil];
    [self.navigationController pushViewController:ctrl animated:YES];
}
-(void)backClick
{
//    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
-(void) dismissKeyboard
{
    [usernameTf resignFirstResponder];
    [passwordTf resignFirstResponder];
}

- (void) setViewItems
{
    UIImageView * loginImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 110, 110)];
    [loginImage setImage:[UIImage imageNamed:@"logoclubby.png"]];
    loginImage.center = CGPointMake(self.view.frame.size.width/2, 120);
    [self.view addSubview:loginImage];
    
    _usernameView = [[UIView alloc] initWithFrame:CGRectMake(22.5, 195, 270, 50)];
    _usernameView.backgroundColor = [UIColor colorWithRed:0.925 green:0.941 blue:0.945 alpha:0.3];
    
    _passwordView = [[UIView alloc] initWithFrame:CGRectMake(22.5, 250, 270, 50)];
    _passwordView.backgroundColor = [UIColor colorWithRed:0.925 green:0.941 blue:0.945 alpha:0.3];
    
    _sendButtonView = [[UIView alloc] initWithFrame:CGRectMake(22.5, 320, 270, 50)];
    _sendButtonView.backgroundColor = [UIColor colorWithRed:0.925 green:0.941 blue:0.945 alpha:0.7];
    
    //BUTTON
    UIButton * sendButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, _sendButtonView.frame.size.width, _sendButtonView.frame.size.height)];
    [sendButton setTitle:@"LOGIN" forState:UIControlStateNormal];
    [sendButton setTitleColor:[UIColor colorWithRed:0.173 green:0.243 blue:0.314 alpha:1] forState:UIControlStateNormal];
    [sendButton addTarget:self action:@selector(loginClick) forControlEvents:UIControlEventTouchUpInside];
    [_sendButtonView addSubview:sendButton];
    
    //USERNAME Text Field
    UIImageView * userImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 61, 50)];
    [userImage setImage:[UIImage imageNamed:@"user.png"]];
    
    [_usernameView addSubview:userImage];
    
    
    usernameTf = [[UITextField alloc]initWithFrame:CGRectMake(100, 10, 150, 30)];
    usernameTf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"USERNAME" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    usernameTf.textColor = [UIColor whiteColor];
    [_usernameView addSubview:usernameTf];
    
    
    UIImageView * lockImage = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 61, 50)];
    [lockImage setImage:[UIImage imageNamed:@"lock.png"]];
    [_passwordView addSubview:lockImage];
    
    passwordTf = [[UITextField alloc]initWithFrame:CGRectMake(100, 10, 150, 30)];
    passwordTf.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"PASSWORD" attributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]}];
    passwordTf.textColor = [UIColor whiteColor];
    [_passwordView addSubview:passwordTf];
    passwordTf.secureTextEntry = YES;
    

    [self.view addSubview:_usernameView];
    [self.view addSubview:_passwordView];
    [self.view addSubview:_sendButtonView];
    
}
-(void)loginClick
{
    [self.usernameView resignFirstResponder];
    [self.passwordView resignFirstResponder];
    [ProgressHUD showOnView:self.view];
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    NSDictionary *dic = @{@"email":usernameTf.text,@"password":passwordTf.text};
    [manager GET:USERLOGINURL parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id jsonData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"%@",jsonData);
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:jsonData];
        NSString *id = dic[@"id"];
        if (!(id == nil)) {
            User *model = [[User alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"islogin"];
             NSString *islogin = [[NSUserDefaults standardUserDefaults] objectForKey:@"islogin"];
            [[NSUserDefaults standardUserDefaults] setObject:dic[@"id"] forKey:@"userid"];
            [[NSUserDefaults standardUserDefaults] setObject:dic[@"username"] forKey:@"userName"];
            [[NSUserDefaults standardUserDefaults] setObject:dic[@"picture"] forKey:@"userIcon"];
            [[NSUserDefaults standardUserDefaults] setObject:dic[@"introduce"] forKey:@"introduce"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self dismissViewControllerAnimated:YES completion:nil];
            
            //登陆成功
            [self.delegate loginSuccessUpdate:nil];
            
            [ProgressHUD hideAfterSuccessOnView:self.view];
        }
        else
        {
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"登录失败" message:@"请正确输入用户名及密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [av show];
            [ProgressHUD hideOnView:self.view];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          [ProgressHUD hideOnView:self.view];
    }];
    
}

@end
