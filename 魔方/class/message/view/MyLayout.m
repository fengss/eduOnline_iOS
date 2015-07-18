
//
//  MyLayout.m
//  TestWaterLayout
//
//  Created by coderss on 15/5/5.
//  Copyright (c) 2015年 coderss. All rights reserved.
//

#import "MyLayout.h"

@implementation MyLayout
{
    NSInteger _column;
    NSMutableArray *_columnArray;
    //存储包含每个cell的frame的对象的数组
    NSMutableArray *_attrArray;
}
-(instancetype)init
{
    self = [super init];
    if (self) {
        _column = 2;
        _columnArray = [NSMutableArray array];
        _attrArray = [NSMutableArray array];
    }
    return self;
}
-(void)prepareLayout
{
    [super prepareLayout];
    //清除之前的数据
    [_columnArray removeAllObjects];
    [_attrArray removeAllObjects];
    //一共多少列
    if (self.delegate) {
        _column = [self.delegate numberOfColumns];
    }
    //初始化数组
    //默认y值都从上边缘开始
    for(int i = 0 ; i < _column;i++)
    {
        NSNumber  *h = [NSNumber numberWithFloat:self.sectionInsets.top];
        [_columnArray addObject:h];
    }
    NSInteger cellNum = [self.collectionView numberOfItemsInSection:0];
    CGFloat allW = self.collectionView.bounds.size.width -self.sectionInsets.left -self.sectionInsets.right-self.itemSpace*(_column -1);
    CGFloat width = allW /_column;
    for (int i = 0; i < cellNum; i++) {
        //计算每个cell的frame
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        CGFloat height = [self.delegate heightForCellAtIndexPath:indexPath];
        NSInteger col = [self findLowestColumnIndex];
        CGFloat x = self.sectionInsets.left +(width+self.itemSpace) *col;
        CGFloat y = [_columnArray[col] floatValue];
        CGRect frame = CGRectMake(x, y, width, height);
        //更新存储y值数组的内容
        _columnArray[col] = [NSNumber numberWithFloat:y+height+self.lineSpace];
        UICollectionViewLayoutAttributes *attr = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        attr.frame = frame;
        [_attrArray addObject:attr];
    }
}
-(CGSize)collectionViewContentSize
{
    NSInteger index = [self findHightestColumnIndex];
    CGFloat height = [_columnArray[index] floatValue];
    return CGSizeMake(self.collectionView.bounds.size.width,height);
}
-(NSInteger)findHightestColumnIndex
{
    NSInteger highestIndex = -1;
    CGFloat highestValue = CGFLOAT_MIN;
    for(int i = 0 ; i < _columnArray.count;i++)
    {
        NSNumber *n = _columnArray[i];
        if (n.floatValue > highestIndex) {
            highestValue = n.floatValue;
            highestIndex = i ;
        }
    }
    return highestIndex;
}
-(NSArray *)layoutAttributesForElementsInRect:(CGRect)rect
{
    return _attrArray;
}
//计算当前y值最小的列
-(NSInteger)findLowestColumnIndex
{
    CGFloat minValue = CGFLOAT_MAX;
    NSInteger lowestIndex = -1;
    for(int i = 0 ; i < _columnArray.count;i++)
    {
        NSNumber *n = _columnArray[i];
        if(n.floatValue < minValue)
        {
            minValue = n.floatValue;
            lowestIndex = i ;
        }
    }
    return lowestIndex;
}
@end
