//
//  UserLand1.m
//  3G学院
//
//  Created by coderss on 15/5/2.
//  Copyright (c) 2015年 coderss. All rights reserved.
//
#import "HeaderFile.h"
#import "UserLand1.h"
#import "User.h"
@interface UserLand1()<UITextViewDelegate>

@end
@implementation UserLand1

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSLog(@"%@",NSStringFromCGRect(frame));
        self = [[NSBundle mainBundle]loadNibNamed:@"UserLand" owner:nil options:nil][0];
        self.nameFiled.clearButtonMode = UITextFieldViewModeWhileEditing;
        self.passwdFiled.secureTextEntry = YES;
    }
    return self;
}
- (IBAction)loadClick:(id)sender {
    [ProgressHUD  showOnView:self];
    [self.nameFiled resignFirstResponder];
    [self.passwdFiled resignFirstResponder];
    NSLog(@"%@  %@",self.nameFiled.text,self.passwdFiled.text);
    //开始网络请求
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *dic = @{@"email":self.nameFiled.text,@"password":self.passwdFiled.text};
    [manager GET:USERLOGINURL parameters:dic success:^(AFHTTPRequestOperation *operation, id responseObject) {
        id jsonData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:jsonData];
        NSString *id = dic[@"id"];
        NSLog(@"%@",dic);
        if (!(id == nil)) {
            User *model = [[User alloc]init];
            [model setValuesForKeysWithDictionary:dic];
            [ProgressHUD hideOnView:self];
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"islogin"];
           
             NSString *islogin = [[NSUserDefaults standardUserDefaults] objectForKey:@"islogin"];
            [[NSUserDefaults standardUserDefaults] setObject:dic[@"id"] forKey:@"userid"];
            [[NSUserDefaults standardUserDefaults] setObject:dic[@"username"] forKey:@"userName"];
            [[NSUserDefaults standardUserDefaults] setObject:dic[@"picture"] forKey:@"userIcon"];
            [[NSUserDefaults standardUserDefaults] setObject:dic[@"introduce"] forKey:@"introduce"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            self.backblock();
        }
        else
        {
            UIAlertView *av = [[UIAlertView alloc]initWithTitle:@"登录失败" message:@"请正确输入用户名及密码" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [av show];
            [ProgressHUD hideOnView:self];
        }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

- (IBAction)registerClick:(id)sender {
    self.navBlock();
}
@end
