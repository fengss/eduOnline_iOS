

//
//  SearchLabelView.m
//  3G学院
//
//  Created by coderss on 15/5/9.
//  Copyright (c) 2015年 coderss. All rights reserved.
//

#import "SearchLabelView.h"
#import "MyUtil.h"
@implementation SearchLabelView
{
    //上下左右的间距
    UIEdgeInsets _sectionInsets;
    //左右间距
    CGFloat _spaceX;
    UILabel *_textLabel;
}
-(instancetype)initWithFrame:(CGRect)frame sectionInsets:(UIEdgeInsets) sectioninsets spaceX:(CGFloat) spaceX
{
    if (self = [super initWithFrame:frame]) {
        _sectionInsets = sectioninsets;
        _spaceX = spaceX;
        _textLabel  = [MyUtil createLabelFrame:CGRectMake(20, self.center.y-20, self.bounds.size.width-40, 20)
                                         title:@"最多选择三个标签" font:[UIFont systemFontOfSize:12]];
        _textLabel.alpha = 0.5;
        
        _textLabel.textColor = [UIColor blueColor];
        _textLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_textLabel];
    }
    return self;
}
-(void)refreshData
{
    for(UIView *subView in self.subviews)
    {
        if ([subView isKindOfClass:[SearchLableCell class]]) {
            [subView removeFromSuperview];
        }
    }
    //添加cell 有多少个搜索条件
    NSInteger num = [self.delegate numberOfCellInSearchLableView:self];
    if (num == 0) {
        _textLabel.hidden = NO;
    }
    else
    {
        _textLabel.hidden = YES;
    }
    CGFloat width = (self.bounds.size.width - _spaceX*4) / 3;
    for(int i = 0 ; i < num;i++)
    {
        CGRect frame = CGRectMake(_spaceX+(_spaceX+width)*i,5, width,self.bounds.size.height-10);
        SearchLableCell *cell = [[SearchLableCell alloc]initWithFrame:frame];
        cell.deleteBlock = ^{
            [self.delegate deleteCellAtIndex:i inGridView:self];
        };
        //显示cell的内容
        [self.delegate configCell:cell atIndex:i inSearchView:self];
        cell.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gray.jpg"]];
        [self addSubview:cell];
        
    }
}
@end

@implementation SearchLableCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel = [MyUtil createLabelFrame:CGRectMake(5, self.center.y-10, self.bounds.size.width-20, self.bounds.size.height-20) title:nil font:[UIFont systemFontOfSize:12]];
        CALayer *layer = self.layer;
        layer.borderColor = [UIColor blueColor].CGColor;
        layer.borderWidth = 1.0;
        layer.cornerRadius = 10;
        layer.masksToBounds = YES;
        
        _deleteBtn = [MyUtil createBtnFrame:CGRectMake(self.bounds.size.width-20, (self.bounds.size.height-20)/2, 20, 20) image:nil selectImage:nil highlightImage:nil target:self action:@selector(deleteAction:)];
        [_deleteBtn setImage:[UIImage imageNamed:@"20150515040848684_easyicon_net_24"] forState:UIControlStateNormal];
        [self addSubview:_titleLabel];
        [self addSubview:_deleteBtn];
    }
    return self;
}
-(void)deleteAction:(id)sender
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