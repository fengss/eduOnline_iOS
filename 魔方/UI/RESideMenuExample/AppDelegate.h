//
//  DEMOAppDelegate.h
//  RESideMenuExample
//
//  Created by Roman Efimov on 10/10/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RESideMenu.h"
#import <BaiduMapAPI/BMapKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, RESideMenuDelegate,BMKGeneralDelegate>

@property (strong, nonatomic) UIWindow *window;
@property(nonatomic,strong) AFHTTPSessionManager  * manger;
@end
