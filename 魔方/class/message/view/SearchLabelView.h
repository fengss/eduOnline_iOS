//
//  SearchLabelView.h
//  3G学院
//
//  Created by coderss on 15/5/9.
//  Copyright (c) 2015年 coderss. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SearchLabelView;
@class SearchLableCell;
@protocol SearchLabelViewDelegate<NSObject>
-(NSInteger)numberOfCellInSearchLableView:(SearchLabelView *) searchLabelView;
-(void)deleteCellAtIndex:(NSInteger) index inGridView:(SearchLabelView *) searchLabelView;
-(void)configCell:(SearchLableCell *) cell atIndex:(NSInteger) index inSearchView:(SearchLabelView *)searchLableView;
@end
@interface SearchLabelView : UIView
@property(nonatomic,strong)NSArray *titleLabelArray;
-(instancetype)initWithFrame:(CGRect)frame sectionInsets:(UIEdgeInsets) sectioninsets spaceX:(CGFloat) spaceX;
-(void)refreshData;
@property(nonatomic,weak)id<SearchLabelViewDelegate> delegate;
@end

@interface SearchLableCell : UIView
{
    UILabel  *_titleLabel;
    UIButton *_deleteBtn;
}
-(void)config:(NSString *)title;
@property(nonatomic,copy)void(^deleteBlock)(void);
@end