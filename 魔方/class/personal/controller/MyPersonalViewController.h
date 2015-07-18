//
//  MyPersonalViewController.h
//  Person
//
//  Created by 沈伟 on 15/5/12.
//  Copyright (c) 2015年 沈伟. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PhotoStackView.h"
#import "DBSphereView.h"
#import "AMLoginViewController.h"
@interface MyPersonalViewController : UIViewController
@property (nonatomic,strong) UITableView * tabview;
 //资料分栏
@property(nonatomic,strong) NSMutableArray * menuTitles;
//资料内的资料
@property(nonatomic,strong) NSMutableDictionary *dataDic;
@property(strong, nonatomic) UIScrollView *scrollView;
//相册
@property (nonatomic, strong) PhotoStackView *photoStack;
//陌生人
@property (nonatomic, retain) DBSphereView *sphereView;
//陌生人数据
@property(nonatomic,strong)NSMutableArray *MSViewArray;
//用于注销后更新头像
@property(nonatomic,assign)id<LoginDelegate> logindelegate;
@property(nonatomic,strong) NSString *isViewDid;
@end
