//
//  MessageReplyModel.h
//  魔方
//
//  Created by 沈伟 on 15/5/20.
//  Copyright (c) 2015年 coderss. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageReplyModel : NSObject

@property(nonatomic,strong) NSString *id;
@property(nonatomic,strong) NSString *mid;
@property(nonatomic,strong) NSString *uid;
@property(nonatomic,strong) NSString *addtime;
@property(nonatomic,strong) NSString *content;
@property(nonatomic,strong) NSString *pid;
@property(nonatomic,strong) NSString *status;

@end
