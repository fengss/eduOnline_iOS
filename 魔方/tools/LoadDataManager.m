//
//  LoadDataManager.m
//  3G学院
//
//  Created by coderss on 15/5/2.
//  Copyright (c) 2015年 coderss. All rights reserved.
//
#import "LoadDataManager.h"
#import "HeaderFile.h"
@implementation LoadDataManager
+(instancetype)shareLoadDataManager
{
    static LoadDataManager * loaddata;
    if (!loaddata) {
        loaddata=[[LoadDataManager alloc]init];
    }
    return loaddata;
   
}

-(AFHTTPSessionManager *)manger{
    if (_manger==nil) {
        _manger=[AFHTTPSessionManager manager];
        _manger.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    return _manger;
}

-(void)loadDataWithURL:(NSString *)urlStr WithNotname:(NSString *)notName
{
    [self.manger GET:urlStr parameters:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        id jsonData = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        if([jsonData isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dict = jsonData;
            [[NSNotificationCenter defaultCenter] postNotificationName:notName
                                                                object:nil userInfo:dict];
        }
        else
        {
            NSArray *dataArr = [NSArray arrayWithArray:jsonData];
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
            [dict setObject:dataArr forKey:@"items"];
            [[NSNotificationCenter defaultCenter]postNotificationName:notName object:nil
                                                             userInfo:dict];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];

}
@end
