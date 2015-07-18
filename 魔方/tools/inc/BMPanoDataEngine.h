//
//  DataEngine.h
//  StreetViewDemo
//
//  Created by baidu on 14-6-26.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BMPanoDataEngine : NSObject

+ (BMPanoDataEngine*) sharedInstance;

/**
 *  获取当前点全景描述信息
 */
- (NSString *) GetCurrnetPanoramaInfo;

/**
 *  获取指定全景描述信息
 */
- (NSString *) GetIDDescreptionJson:(NSString *)pid;

/*!
 * @method setPanorama
 * 切换全景场景至指定的百度坐标
 *
 * @param   x  百度墨卡托投影坐标x
 * @param   y  百度墨卡托投影坐标y
 */
- (NSString *)GetIDDescreptionJsonWithX:(NSInteger)x andY:(NSInteger)y;

/*!
 * @method setPanorama
 * 切换全景场景至指定的地理坐标
 *
 * @param   lon  地理坐标经度
 * @param   lat  地理坐标纬度
 */
- (NSString *)GetIDDescreptionJsonWithLon:(double)lon andLat:(double)lat;

/**
 *  获取指定内景描述信息
 */
- (NSString *) GetIIDDescreptionJson:(NSString *)iid;

/**
 *  获取指定全景推荐信息
 */

- (NSString *) GetGIDescreptionJson:(NSString *)pid;

@end
