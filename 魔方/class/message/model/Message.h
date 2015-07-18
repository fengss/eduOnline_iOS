//
//  Message.h
//  魔方
//
//  Created by coderss on 15/5/12.
//  Copyright (c) 2015年 coderss. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject
@property(nonatomic,strong)NSString *addtime;
@property(nonatomic,strong)NSString *content;
@property(nonatomic,strong)NSString *id;
@property(nonatomic,strong)NSString *isbest;
@property(nonatomic,strong)NSString *ishot;
@property(nonatomic,strong)NSString *keyword;
@property(nonatomic,strong)NSString *scan;
@property(nonatomic,strong)NSString *status;
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *uid;
@property(nonatomic,copy) NSString  * username;
@property(nonatomic,copy) NSString  * name;
@property(nonatomic,copy) NSString  * picture;
@property(nonatomic,copy) NSString  * plnum;
@end