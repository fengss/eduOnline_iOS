//
//  NetWorking.m
//  NetWorking
//
//  Created by ZSQ on 15-4-12.
//  Copyright (c) 2015年 ZSQ. All rights reserved.
//

#import "NetWorking.h"

typedef void (^Completion_Handle)(NSURLResponse *, NSData *, NSError *);

@interface HttpRequest : NSObject <NSURLConnectionDataDelegate, NSURLConnectionDelegate>
/**
 *  下载资源的地址
 */
@property (nonatomic, copy) NSString * urlStr;

/**
 *  缓存策略
 */
@property (nonatomic, assign) NSURLRequestCachePolicy cachePolicy;

/**
 *  超时时间
 */
@property (nonatomic, assign) NSTimeInterval timeoutInterval;


/**
 *  保存处理加载完成后的代码块
 */
@property (nonatomic, copy) Completion_Handle  handle;

/**
 *  保存服务器返回的应答包数据
 */
@property (nonatomic, strong) NSURLResponse * response;

/**
 *  保存服务器返回的实际下载数据
 */
@property (nonatomic, strong) NSMutableData * data;

/**
 *  保存下载出错信息
 */
@property (nonatomic, strong) NSError * error;

/**
 *  启动异步下载数据
 */
- (void)start;
@end

@implementation HttpRequest

- (void)start
{
    // 1. 构建URL
    NSURL *url = [NSURL URLWithString:self.urlStr];
    
    // 2. 构建请求数据包
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:self.cachePolicy timeoutInterval:self.timeoutInterval];
    
    // 3. 创建连接对象，发送异步下载的请求
    [NSURLConnection connectionWithRequest:request delegate:self];
}


- (NSMutableData *)data
{
    if (_data == nil) {
        _data = [NSMutableData data];
    }
    
    return _data;
}

#pragma mark - 协议方法
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    // 下载失败，保存错误信息
    self.error = error;
    // 处理出错状况
    self.handle(self.response, self.data, self.error);
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // 保存服务器返回的应答数据
    self.response = response;
    
    // 清空原来数据
    [self.data setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    // 保存下载的数据
    [self.data appendData:data];
}


- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    self.handle(self.response, self.data, self.error);
}

@end


@implementation NetWorking

+ (void)sendAsynchronousRequestWithURLString:(NSString *)urlStr cachePolicy:(NSURLRequestCachePolicy)cachePolicy timeoutInterval:(NSTimeInterval)timeoutInterval completionHandler:(void (^)(NSURLResponse *, NSData *, NSError *))handler
{
    // 下载数据有HttpRequest来坐
    HttpRequest *request = [[HttpRequest alloc] init];
    request.urlStr = urlStr;
    request.cachePolicy = cachePolicy;
    request.timeoutInterval = timeoutInterval;
    request.handle = handler;
    
    // 启动下载
    [request start];
}

+ (void)sendAsynchronousRequestWithURLString:(NSString *)urlStr completionHandler:(void (^)(NSURLResponse *, NSData *, NSError *))handler
{
    [self sendAsynchronousRequestWithURLString:urlStr cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30 completionHandler:handler];
}
@end
