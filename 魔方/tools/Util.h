//
//  Util.h
//  魔方
//
//  Created by fengss on 15-5-13.
//  Copyright (c) 2015年 coderss. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Util : NSObject
/**
 *  从文字中抽数组出来
 *
 *  @param string 数字
 */
+(int)returnNumberFormString:(NSString*)string;


/**
 *  返回距离现在的时间
 *
 *  @param timeUpload
 *  @param label
 */
+(void)calculateTimeWithTimeUpload:(NSString *)timeUpload label:(UILabel *)label;
@end
