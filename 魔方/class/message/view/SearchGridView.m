//
//  SearchGridView.m
//  TestKitchen
//
//  Created by gaokunpeng on 15/5/8.
//  Copyright (c) 2015年 coderss. All rights reserved.
//

#import "SearchGridView.h"
#import "MyUtil.h"
@implementation SearchGridView
{
    //上下左右的间距
    UIEdgeInsets _sectionInsets;
    CGFloat _spaceX;
    CGFloat _spaceY;
    CGSize _cellSize;
    
    //文字
    UILabel *_textLabel;
}

-(instancetype)initWithFrame:(CGRect)frame sectionInsets:(UIEdgeInsets)sectionInsets spaceX:(CGFloat)spaceX spaceY:(CGFloat)spaceY cellSize:(CGSize)cellSize placeHolder:(NSString *)placeHolder bgImageName:(NSString *)bgImageName
{
    if (self = [super initWithFrame:frame]) {
        
        //背景图片
        UIImageView *bgImageView = [MyUtil createImageView:self.bounds imageName:bgImageName];
        [self addSubview:bgImageView];
        
        //确定cell位置的成员变量
        _sectionInsets = sectionInsets;
        _spaceX = spaceX;
        _spaceY = spaceY;
        _cellSize = cellSize;
        
        //默认的文字
        if (placeHolder) {
            _textLabel = [MyUtil createLabelFrame:CGRectMake(20, 30, self.bounds.size.width-40, 20) title:placeHolder font:[UIFont systemFontOfSize:12]];
            _textLabel.textAlignment = NSTextAlignmentCenter;
            [self addSubview:_textLabel];
        }
        
        
    }
    return self;
}

//重新显示搜索条件的内容
-(void)refreshData
{
    //删除之前选择的cell
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[SearchGridCell class]]) {
            [subView removeFromSuperview];
        }
    }
    
    //添加cell
    //有多少个搜索条件
    NSInteger num = [self.delegate numberOfCellsInGridView:self];
    //循环添加cell
    for (int i=0; i<num; i++) {
        //cell的frame
        int row = i/3;
        int col = i%3;
        
        CGRect frame = CGRectMake(_sectionInsets.left+(_cellSize.width+_spaceX)*col, _sectionInsets.top+(_cellSize.height+_spaceY)*row, _cellSize.width, _cellSize.height);
        SearchGridCell *cell = [[SearchGridCell alloc] initWithFrame:frame];
        
        //删除事件
        cell.deleteBlock = ^{            
            [self.delegate deleteCellAtIndex:i inGridView:self];
        };
        
        //显示cell的内容
        [self.delegate configCell:cell atIndex:i inGridView:self];
        
        //添加到父视图
        [self addSubview:cell];
        
    }
    
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end


@implementation SearchGridCell

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //背景图片
        _bgImageView = [MyUtil createImageView:self.bounds imageName:@"搜索-材料背景"];
        [self addSubview:_bgImageView];
        
        //文字
        _titleLabel = [MyUtil createLabelFrame:CGRectMake(0, 0, self.bounds.size.width-20, self.bounds.size.height) title:nil font:[UIFont systemFontOfSize:16]];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
        
        //按钮
        _deleteBtn = [MyUtil createBtnFrame:CGRectMake(self.bounds.size.width-20, (self.bounds.size.height-20)/2, 20, 20) image:@"智能选菜-删除" selectImage:nil highlightImage:@"智能选菜-删除-选" target:self action:@selector(deleteAction:)];
        [self addSubview:_deleteBtn];
        
    }
    return self;
}

- (void)deleteAction:(id)sender
{
    if (self.deleteBlock) {
        self.deleteBlock();
    }
}

-(void)config:(NSString *)title
{
    _titleLabel.text = title;
}

@end


