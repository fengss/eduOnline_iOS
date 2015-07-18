
//
//  CheckNetworkManager.m
//  3G学院
//
//  Created by coderss on 15/5/2.
//  Copyright (c) 2015年 coderss. All rights reserved.
//
#import "CheckNetworkManager.h"
#import "AFNetworkReachabilityManager.h"
@implementation CheckNetworkManager
+(instancetype)shareCheckNetworkManager
{
    static CheckNetworkManager *checkNetworkManager = nil;
    checkNetworkManager = [[CheckNetworkManager alloc]init];
    return checkNetworkManager;
}
-(void)checkNetWorkWithNotName:(NSString *)notname
{
    AFNetworkReachabilityManager  *manager = [AFNetworkReachabilityManager sharedManager];
    [manager startMonitoring];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status)
     {
         NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
         switch (status)
         {
             case AFNetworkReachabilityStatusNotReachable:
                 [dict setObject:@"no" forKey:@"infoForNetWork"];
                 [[NSNotificationCenter defaultCenter] postNotificationName:notname
                                                                     object:nil userInfo:dict];
                 break;
             case AFNetworkReachabilityStatusReachableViaWiFi:
             case AFNetworkReachabilityStatusReachableViaWWAN:
                 [dict setObject:@"yes" forKey:@"infoForNetWork"];
                 [[NSNotificationCenter defaultCenter] postNotificationName:notname
                                                                     object:nil userInfo:dict];
                 break;
             default:
                 break;
         }
     }];
}
@end

