//
//  MyLayout.h
//  TestWaterLayout
//
//  Created by coderss on 15/5/5.
//  Copyright (c) 2015年 coderss. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol MyLayoutDelegate<NSObject>
-(NSInteger)numberOfColumns;
-(CGFloat)heightForCellAtIndexPath:(NSIndexPath *)indexPath;
@end
@interface MyLayout : UICollectionViewLayout
//上下左右的间距
@property(nonatomic,assign) UIEdgeInsets sectionInsets;
//横向
@property(nonatomic,assign)CGFloat  itemSpace;
//纵向
@property(nonatomic,assign)CGFloat  lineSpace;

@property(nonatomic,weak)id<MyLayoutDelegate> delegate;
@end
