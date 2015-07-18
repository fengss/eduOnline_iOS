//
//  DEMOMenuViewController.m
//  RESideMenuExample
//
//  Created by Roman Efimov on 10/10/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "VideoViewController.h"
#import "NoteViewController.h"
#import "ExamViewController.h"
#import "MessageController.h"
#import "AMLoginViewController.h"
#import "MyPersonalViewController.h"
#import "StudyViewController.h"
#import "QuestionViewController.h"
@interface LeftMenuViewController ()<LoginDelegate>
{
    UIButton *iconBtn1;
    UILabel *label1;
    UILabel *introduceLabel1;
    
    //登陆方面
    UILabel *name;
    //简介方面
    UILabel *introducelabel;
    //头像
    UIButton *iconImageView;
    
}
@property (strong, readwrite, nonatomic) UITableView *tableView;

@end

@implementation LeftMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createUserLogin];
    
    [self initUser];
    
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, (self.view.frame.size.height - 54 * 7) / 2.0f+30, self.view.frame.size.width, 54 * 7) style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.opaque = NO;
        tableView.backgroundColor = [UIColor clearColor];
        tableView.backgroundView = nil;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.bounces = NO;
        tableView;
    });
    [self.view addSubview:self.tableView];
}

/**
 *  初始化更新
 */
-(void)initUser{
    //头像更新
    [iconImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:USERICO,[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"],[[NSUserDefaults standardUserDefaults]objectForKey:@"userIcon"]]] forState:UIControlStateNormal];
    //用户名更新
    [name setText:[[NSUserDefaults standardUserDefaults]objectForKey:@"userName"]];
    //简介更新
    [introducelabel setText:[[NSUserDefaults standardUserDefaults]objectForKey:@"introduce"]];
}

#pragma mark -用户登录
-(void)createUserLogin
{
    iconImageView= [UIButton buttonWithType:UIButtonTypeCustom];
    iconImageView.frame = CGRectMake(20, 50, 40, 40);
    CALayer *layer = iconImageView.layer;
    layer.cornerRadius = 18;
    layer.masksToBounds = YES;
    [iconImageView setImage:[UIImage imageNamed:@"IconProfile"] forState:UIControlStateNormal];
    [iconImageView addTarget:self action:@selector(registerOrLand) forControlEvents:UIControlEventTouchUpInside];
    iconBtn1 = iconImageView;
    [self.view addSubview:iconImageView];
    
    name = [[UILabel alloc]initWithFrame:CGRectMake(iconImageView.bounds.origin.x+30+iconImageView.bounds.size.width, 55, 200, 20)];
    name.font = [UIFont systemFontOfSize:17];
    name.textColor = [UIColor orangeColor];
    name.text = @"登录或注册";
    label1 = name;
    [self.view addSubview:name];
    
    introducelabel =[[UILabel alloc]initWithFrame:CGRectMake(iconImageView.bounds.origin.x+30+iconImageView.bounds.size.width, 75, 200, 40)];
    UITapGestureRecognizer *g = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(registerOrLand)];
    [introducelabel addGestureRecognizer:g];
    introducelabel.font = [UIFont systemFontOfSize:14];
    introducelabel.textColor = [UIColor whiteColor];
    introducelabel.text = @"暂无简介";
    introduceLabel1 = introducelabel;
    [self.view addSubview:introduceLabel1];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0.6 * self.view.bounds.size.width - 10, name.bounds.origin.y+50+name.bounds.size.height+20-3, 20, 20)];
    [btn setImage:[UIImage imageNamed:@"IconSettings"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(settingBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(10, btn.frame.origin.y +5+btn.frame.size.height+20, 0.6 * self.view.bounds.size.width, 1.5)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
}

-(void)registerOrLand
{
    //如果是已经登陆了可以直接跳入个人中心
    
    if ([[NSUserDefaults standardUserDefaults]objectForKey:@"userid"]) {
        MyPersonalViewController *person=[[MyPersonalViewController alloc]init];
        person.isViewDid = @"1";
        person.logindelegate = self;
        [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:person]
                                                     animated:YES];
        [self.sideMenuViewController hideMenuViewController];
        return;
    }
    AMLoginViewController *ctrl= [[AMLoginViewController alloc]init];
    ctrl.delegate=self;
    [self presentViewController:[[UINavigationController alloc]initWithRootViewController:ctrl] animated:YES completion:nil];
}
-(void)settingBtnClick{
    
    NSLog(@"设置");
}
#pragma mark UITableView Delegate
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (indexPath.row) {
        case 0:
            //视频控制器
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[[VideoViewController alloc] init]]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case 1:
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[[NoteViewController alloc] init]]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
            case 2:
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[[ExamViewController alloc] init]]
                                                         animated:YES];
                 [self.sideMenuViewController hideMenuViewController];
            break;
            case 3:
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[[MessageController alloc] init]]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
            case 4:
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:[[QuestionViewController alloc] init]]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case 5:
        {
            StudyViewController *study=[[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]]instantiateViewControllerWithIdentifier:@"CardViewController"];
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:study]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
        }
            break;
        default:
            break;
    }
}

#pragma mark -
#pragma mark UITableView Datasource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 54;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)sectionIndex
{
    return 6;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:21];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.highlightedTextColor = [UIColor lightGrayColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
    }
    
    NSArray *titles = @[@"教学视频", @"学习笔记", @"在线考试", @"贴吧讨论", @"问吧中心",@"学习资料"];
    NSArray *images = @[@"IconHome", @"IconCalendar", @"IconProfile", @"IconSettings", @"IconHome",@"IconHome"];
    cell.textLabel.text = titles[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:images[indexPath.row]];
    return cell;
}

#pragma mark login delegate
-(void)loginSuccessUpdate:(NSDictionary *)dic{
    NSLog(@"登陆成功");
    NSLog(@"名称:%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"username"]);
    //头像更新
    [iconImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:USERICO,[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"],[[NSUserDefaults standardUserDefaults]objectForKey:@"userIcon"]]] forState:UIControlStateNormal];
    //用户名更新
    [name setText:[[NSUserDefaults standardUserDefaults]objectForKey:@"userName"]];
    //简介更新
    [introducelabel setText:[[NSUserDefaults standardUserDefaults]objectForKey:@"introduce"]];
}
@end
