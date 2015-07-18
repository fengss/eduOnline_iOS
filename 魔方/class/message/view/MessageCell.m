//
//  MessageCell.m
//  3G学院
//
//  Created by coderss on 15/5/8.
//  Copyright (c) 2015年 coderss. All rights reserved.
//

#import "MessageCell.h"

@implementation MessageCell
//-(void)config:(NSString *)title WithColor:(UIColor *) color
//{
//    self.titleLabel.text = title;
//    self.backgroundColor = color;
//}
-(void)config:(Message *)message
{
    self.bgImageView.layer.cornerRadius=14.0f;
    self.bgImageView.layer.masksToBounds=YES;
    self.title.text = message.title;
    if ([message.name isEqual:@"null"]) {
        [self.userName setTitle:[NSString stringWithFormat:@"楼主:%@",message.username] forState:UIControlStateNormal];
    }
    else{
        [self.userName setTitle:[NSString stringWithFormat:@"楼主:%@",message.name] forState:UIControlStateNormal];
    }
    self.addtime.text = message.addtime;
    if (message.plnum==nil) {
        message.plnum=@"0";
    }
    self.scanAndCom.text = [NSString stringWithFormat:@"浏览量:%@/用户ID:%@\n回复量:%@",message.scan,message.uid,message.plnum];
    [self.iconImageView setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:USERICO,message.username,message.picture]]];
}
@end
