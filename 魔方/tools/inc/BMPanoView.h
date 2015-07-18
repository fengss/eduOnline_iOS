//
//  BMPanoView.h
//  BMPanoView
//
//  Created by baidu on 14-4-8.
//  Copyright (c) 2014年 baidu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
//#import "BMPanoOverlay.h"
@class BMPanoOverlay;
@protocol PanoramaViewDelegate <NSObject>

/*!
 * @function loadDataEnd
 * 全景图加载开始回调函数
 *
 */
-(void)loadDataStart;

/*!
 * @function loadDataEnd
 * 全景图加载完成回调函数
 *
 */
-(void)loadDataEnd;

/*!
 * @function loadDataEnd
 * 全景图加载失败回调函数
 *
 */
-(void)loadDataFail;

/*!
 * @function loadDescreptionEnd
 * 单点描述json信息加载成功
 *
 */
-(void)loadDescreptionEnd;

/*!
 * @function loadDataEnd
 * 全景图中Overlay被点击回调函数
 *
 */
-(void)onClickOverlay;


@end

@interface BMPanoView : UIView

@property(nonatomic , assign) id<PanoramaViewDelegate> delegate;

/*!
 * @function setPanoramaImageLevel
 * 设置全景场景使用的图片级别
 *
 * @param   level  图片级别
 *
 */

-(void)setPanoramaImageLevel:(int) level;

/*!
 * @function setPanorama
 * 切换全景场景至指定的全景id
 *
 * @param   panoid  全景唯一的id
 *
 */
- (void)setPanorama:(NSString *)panoid;

/*!
 * @method setPanorama
 * 切换全景场景至指定的百度坐标
 *
  * @param   x  百度墨卡托投影坐标x
  * @param   y  百度墨卡托投影坐标y
 */
- (void)setPanoramaWithX:(NSInteger)x andY:(NSInteger)y;

/*!
 * @method setPanorama
 * 切换全景场景至指定的地理坐标
 *
 * @param   lon  地理坐标经度
 * @param   lat  地理坐标纬度
 */
- (void)setPanoramaWithLon:(double)lon andLat:(double)lat;

/*!
 * @method addOverlay
 * 添加叠加物到当前场景
 *
 */
-(BOOL)addOverlay:(BMPanoOverlay *)overlay;

/*!
 * @method addOverlay
 * 添加叠加物到当前场景
 *
 * @param   overlayId  叠加物唯一标识
 * @param   imagePath  叠加物图片路径
 * @param   x  百度墨卡托投影坐标x
 * @param   y  百度墨卡托投影坐标y
 */
- (void)addOverlay:(NSString *)overlayId andX:(NSInteger)x andY:(NSInteger)y andText:(NSString *)text;
/*!
 * @method addOverlay
 * 添加叠加物到当前场景
 *
 * @param   overlayId  叠加物唯一标识
 * @param   imagePath  叠加物图片路径
 * @param   x  百度墨卡托投影坐标x
 * @param   y  百度墨卡托投影坐标y
 */
- (void)addOverlay:(NSString *)overlayId andX:(NSInteger)x andY:(NSInteger)y andImage:(NSString *)imagePath;

/*!
 * @method updateOverlay
 * 更新当前场景指定的叠加物
 *
 * @param   overlayId  叠加物唯一标识
 */
- (void)updateOverlay:(NSString *)overlayId;

/*!
 * @method removeOverlay
 * 从当前场景移除指定的叠加物
 *
 * @param   overlayId  叠加物唯一标识
 */
- (void)removeOverlay:(NSString *)overlayId;

/*!
 * @method setPanoramaLevel
 * 设置场景level缩放级别
 *
 * @param   level  场景缩放级别
 */
- (void)setPanoramaLevel:(float)level;

/*!
 * @method setPanoramaHeading
 * 设置场景heading偏航角
 *
 * @param   heading 偏航角
 */
- (void)setPanoramaHeading:(float)heading;

/*!
 * @method setPanoramaPitch
 * 设置场景pitch俯仰角
 *
 * @param   pitch   俯仰角
 */
- (void)setPanoramaPitch:(float)pitch;

/*!
 * @method getPanoramaLevel
 * 获取当前场景level缩放级别
 *
 * @return   level  场景缩放级别
 */
- (float)getPanoramaLevel;

/*!
 * @method getPanoramaHeading
 * 获取当前场景heading偏航角
 *
 * @return   heading 偏航角
 */
- (float)getPanoramaHeading;

/*!
 * @method getPanoramaPitch
 *  获取当前场景pitch俯仰角
 *
 * @return   pitch   俯仰角
 */
- (float)getPanoramaPitch;

@end
