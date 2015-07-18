//
//  CheckNetworkManager.h
//  3G学院
//
//  Created by coderss on 15/5/2.
//  Copyright (c) 2015年 coderss. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface CheckNetworkManager : NSObject
+(instancetype)shareCheckNetworkManager;
-(void)checkNetWorkWithNotName:(NSString *)notname;
@end
