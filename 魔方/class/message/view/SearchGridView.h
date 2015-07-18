//
//  SearchGridView.h
//  TestKitchen
//
//  Created by gaokunpeng on 15/5/8.
//  Copyright (c) 2015年 coderss. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchGridView;
@class SearchGridCell;
@protocol SearchGridViewDelegate <NSObject>

//返回多少个搜索条件
- (NSInteger)numberOfCellsInGridView:(SearchGridView *)gridView;
//每个cell的显示
- (void)configCell:(SearchGridCell *)searchGridCell atIndex:(NSInteger)index inGridView:(SearchGridView *)gridView;
//删除cell
- (void)deleteCellAtIndex:(NSInteger)index inGridView:(SearchGridView *)gridView;


@end

@interface SearchGridView : UIView

/*
 @param sectionInsets:控件内部上下左右的间距
 @param spaceX:两个cell横向的间距
 @param spaceY:两个cell纵向的间距
 @param cellSize:每个cell的大小
 @param placeHolder:默认的提示文字
 @param bgImageName:背景图片
 */
- (instancetype)initWithFrame:(CGRect)frame sectionInsets:(UIEdgeInsets)sectionInsets spaceX:(CGFloat)spaceX spaceY:(CGFloat)spaceY cellSize:(CGSize)cellSize placeHolder:(NSString *)placeHolder bgImageName:(NSString *)bgImageName;

//代理属性
@property (nonatomic,weak)id<SearchGridViewDelegate> delegate;

//刷新显示
- (void)refreshData;



@end


//每个cell的类型
@interface SearchGridCell : UIView
{
    //背景图片
    UIImageView *_bgImageView;
    //文字
    UILabel *_titleLabel;
    //按钮
    UIButton *_deleteBtn;
}
//显示文字
- (void)config:(NSString *)title;

//删除的方法
@property (nonatomic,copy) void (^deleteBlock)(void);


@end



