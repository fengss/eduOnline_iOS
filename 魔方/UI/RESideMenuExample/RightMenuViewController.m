//
//  DEMORightMenuViewController.m
//  RESideMenuExample
//
//  Created by Roman Efimov on 2/11/14.
//  Copyright (c) 2014 Roman Efimov. All rights reserved.
//

#import "RightMenuViewController.h"
#import "VideoViewController.h"
#import "NoteViewController.h"
#import "LeftMenuViewController.h"
#import "MyPersonalViewController.h"
#import "GeocodeViewController.h"
#import "AnnotationViewController.h"

@interface RightMenuViewController ()

@property (strong, readwrite, nonatomic) UITableView *tableView;

@end


@implementation RightMenuViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView = ({
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.frame.size.width/3, (self.view.frame.size.height - 54 * 2) / 2.0f, self.view.frame.size.width/2+30, 54 * 2) style:UITableViewStylePlain];
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

#pragma mark -
#pragma mark UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MyPersonalViewController *person=[[MyPersonalViewController alloc]init];
    
    switch (indexPath.row) {
        case 0:
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:person]
                                                         animated:YES];
            [self.sideMenuViewController hideMenuViewController];
            break;
        case 2:{
            GeocodeViewController *geo=[[GeocodeViewController alloc]initWithNibName:@"GeocodeViewController" bundle:nil];
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:geo] animated:YES];
            [self.sideMenuViewController hideMenuViewController];
        }
            break;
        case 1:{
            AnnotationViewController *ano=[[AnnotationViewController alloc]initWithNibName:@"AnnotationViewController" bundle:nil];
            [self.sideMenuViewController setContentViewController:[[UINavigationController alloc] initWithRootViewController:ano] animated:YES];
            [self.sideMenuViewController hideMenuViewController];
        }break;
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
    return 2;
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
    
    NSArray *titles = @[@"个人中心", @"附近好友",@"地图检索"];
    NSArray *images = @[@"IconHome", @"IconCalendar",@"IconCalendar"];
    cell.textLabel.text = titles[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:images[indexPath.row]];
    cell.textLabel.textAlignment = NSTextAlignmentRight;
    
    return cell;
}

@end
