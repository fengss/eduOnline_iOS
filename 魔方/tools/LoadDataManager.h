//
//  LoadDataManager.h
//  3G学院
//
//  Created by coderss on 15/5/2.
//  Copyright (c) 2015年 coderss. All rights reserved.
//
#import <Foundation/Foundation.h>
@class AFHTTPSessionManager;
@interface LoadDataManager : NSObject
+(instancetype)shareLoadDataManager;
-(void)loadDataWithURL:(NSString *)urlStr WithNotname:(NSString *)notName;
@property(nonatomic,strong) AFHTTPSessionManager *manger;
@end
