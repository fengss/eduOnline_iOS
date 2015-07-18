//
//  MessageDetailVC.m
//  魔方
//
//  Created by coderss on 15/5/17.
//  Copyright (c) 2015年 coderss. All rights reserved.
//

#import "MessageDetailVC.h"
#import "MessageDetailView.h"
@interface MessageDetailVC ()

@end

@implementation MessageDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    MessageDetailView *detailView =  [[[NSBundle mainBundle]loadNibNamed:@"MessageDetailView" owner:nil options:nil] lastObject];
    
    [detailView config:self.message];
    [self.view  addSubview:detailView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}
@end
