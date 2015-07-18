//
//  NetWorking.h
//  NetWorking
//
//  Created by ZSQ on 15-4-12.
//  Copyright (c) 2015年 ZSQ. All rights reserved.
//

#import <Foundation/Foundation.h>

//void (^block)(int);
//void (^block1)(NSURLResponse *response, NSData *data, NSError *connectionError);
@interface NetWorking : NSObject


/**
 *  异步下载数据
 *
 *  @param urlStr          下载资源的地址
 *  @param cachePolicy     缓存策略
 *  @param timeoutInterval 超时时间
 *  @param handler         处理下载状态的代码块
 */
+ (void)sendAsynchronousRequestWithURLString:(NSString *)urlStr cachePolicy:(NSURLRequestCachePolicy)cachePolicy timeoutInterval:(NSTimeInterval)timeoutInterval completionHandler:(void (^)(NSURLResponse *response, NSData *data, NSError *connectionError))handler;


/**
 *  异步下载数据 ，这个方法中默认缓存策略为   默认超时时间为30秒
 *
 *  @param urlStr          下载资源的地址
 *  @param handler         处理下载状态的代码块
 */
+ (void)sendAsynchronousRequestWithURLString:(NSString *)urlStr  completionHandler:(void (^)(NSURLResponse *response, NSData *data, NSError *connectionError))handler;

@end
