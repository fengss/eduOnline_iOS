//
//  Util.m
//  魔方
//
//  Created by fengss on 15-5-13.
//  Copyright (c) 2015年 coderss. All rights reserved.
//

#import "Util.h"

@implementation Util
+(int)returnNumberFormString:(NSString *)string{
    NSMutableString *numberString = [[NSMutableString alloc] init];
    NSString *tempStr;
    NSScanner *scanner = [NSScanner scannerWithString:string];
    NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    
    while (![scanner isAtEnd]) {
        [scanner scanUpToCharactersFromSet:numbers intoString:NULL];
        
        // Collect numbers.
        [scanner scanCharactersFromSet:numbers intoString:&tempStr];
        [numberString appendString:tempStr];
        tempStr = @"";
    }
    int number = [numberString integerValue];
    return number;
}

+(void)calculateTimeWithTimeUpload:(NSString *)timeUpload label:(UILabel *)label{
    //现在的时间
    NSDateFormatter *dateF = [[NSDateFormatter alloc] init];
    dateF.dateFormat = @"yyyy-MM-dd-HH-mm-ss";
    NSDate *date = [NSDate date];
    NSString *dateStr = [dateF stringFromDate:date];
    NSArray *timeNow = [dateStr  componentsSeparatedByString:@"-"];
    
    //发布的时间
    //需要根据源数据进行分割
    NSArray *timeBefore = [timeUpload componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"- :"]];
    int year = [timeNow[0] intValue] -[timeBefore[0] intValue];
    int month = [timeNow[1] intValue] -[timeBefore[1] intValue];
    int day = [timeNow[2] intValue] -[timeBefore[2] intValue];
    int hour = [timeNow[3] intValue] -[timeBefore[3] intValue];
    int minute = [timeNow[4] intValue] -[timeBefore[4] intValue];
    int sencond = [timeNow[5] intValue] -[timeBefore[5] intValue];
    
    int resultValue = sencond + 60*(minute+ 60*(hour + 24*(day + 30*(month + 12*(year)))));
    if (resultValue < 60) {
        label.text = [NSString stringWithFormat:@"%d 秒",resultValue];
    }else if (60 <= resultValue && resultValue < (60 * 60)) {
        label.text = [NSString stringWithFormat:@"%d 分",(resultValue/60)];
    }else if ((60 * 60) <= resultValue && resultValue < (60 * 60 * 24)) {
        label.text = [NSString stringWithFormat:@"%d 小时",(resultValue/(60*60))];
    }else if ((60 * 60 * 24) <= resultValue && resultValue < (60 * 60 * 24 * 30)) {
        label.text = [NSString stringWithFormat:@"%d 天",(resultValue/(60*60*24))];
    }else if ((60 * 60 * 24 * 30) <= resultValue && resultValue < (60 * 60 * 24 * 30 * 12)) {
        label.text = [NSString stringWithFormat:@"%d 月",(resultValue/(60*60*24*30))];
    }else if ((60 * 60 * 24 * 30 * 12) <= resultValue) {
        label.text = [NSString stringWithFormat:@"%d 年",(resultValue/(60*60*24*30*12))];
    }
}
@end
