//
//  ZTLetterIndex.h
//  ZTLetterIndexDemo
//
//  Created by 赵天福 on 2017/3/20.
//  Copyright © 2017年 赵天福. All rights reserved.
//

#import "ZTLetterIndex.h"

#define kAnimationDuration  0.2f

@interface ZTLetterIndex ()
{
    NSInteger _lastIndex;
    CALayer   *_slidr;
}

@end

@implementation ZTLetterIndex

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _lastIndex = 0;
        self.textColor = [UIColor lightGrayColor];
        self.selectedTextColor = [UIColor whiteColor];
        self.itemSize = CGSizeMake(12.0f, 16.0f);
        self.sliderSize = CGSizeMake(12.0f, 40.0f);
        self.sliderColor = [UIColor lightGrayColor];
        self.textFont = [UIFont fontWithName:@"PingFangSC-Medium" size:11.0f];
        self.sliderSpace = 4.0f;
    }
    return self;
}

- (void)setDataArray:(NSArray *)dataArray
{
    _dataArray = dataArray;
    [self setupItems];
}

- (void)setupItems
{
    _slidr = [CALayer layer];
    _slidr.frame = CGRectMake((self.bounds.size.width - self.sliderSize.width)/2, 0, self.sliderSize.width, self.sliderSize.height + 2*self.sliderSpace);
    _slidr.backgroundColor = [UIColor clearColor].CGColor;
    [self.layer addSublayer:_slidr];
    
    CALayer *slidrColor = [CALayer layer];
    slidrColor = [CALayer layer];
    slidrColor.frame = CGRectMake(0, self.sliderSpace, self.sliderSize.width, self.sliderSize.height);
    slidrColor.cornerRadius = slidrColor.bounds.size.width/2;
    slidrColor.backgroundColor = self.sliderColor.CGColor;
    [_slidr addSublayer:slidrColor];
    
    [self.dataArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UILabel *item = [[UILabel alloc] init];
        item.frame = CGRectMake((self.bounds.size.width - self.itemSize.width)/2, self.itemSize.height * idx + (_slidr.bounds.size.height - self.itemSize.height), self.itemSize.width, self.itemSize.height);
        item.backgroundColor = [UIColor clearColor];
        item.text = [NSString stringWithFormat:@"%@",obj];
        item.font = self.textFont;
        item.textAlignment = NSTextAlignmentCenter;
        item.textColor = self.textColor;
        item.tag = 999 + idx;
        item.layer.masksToBounds = NO;
        item.userInteractionEnabled = YES;
        [self addSubview:item];
        
        UITapGestureRecognizer *singleTapGR;
        UILongPressGestureRecognizer *longPressGR;
        
        longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(touchLong:)];
        longPressGR.allowableMovement=NO;
        longPressGR.minimumPressDuration = 0.2;
        
        singleTapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchDown:)];
        singleTapGR.numberOfTapsRequired = 1;
        singleTapGR.numberOfTouchesRequired = 1;
        [item addGestureRecognizer:longPressGR];
        [item addGestureRecognizer:singleTapGR];
    }];
    
    UILabel *firstItem = (UILabel *)[self viewWithTag:999];
    firstItem.frame = CGRectMake(0, 0, self.itemSize.width, _slidr.bounds.size.height);
    firstItem.textColor = self.selectedTextColor;
}

- (void)touchDown:(UITapGestureRecognizer *)recognizer
{
    UILabel *item = (UILabel *)recognizer.view;
    [self selectIndex:item.tag - 999];
    if (self.delegate && [self.delegate respondsToSelector:@selector(ZTLetterIndex:didSelectedItemWithIndex:)]) {
        [self.delegate ZTLetterIndex:self didSelectedItemWithIndex:item.tag - 999];
    }
}

- (void)touchLong:(UILongPressGestureRecognizer *)recognizer
{
    UILabel *item = (UILabel *)recognizer.view;
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        [self selectIndex:item.tag - 999];
        if (self.delegate && [self.delegate respondsToSelector:@selector(ZTLetterIndex:beginChangeItemWithIndex:)]) {
            [self.delegate ZTLetterIndex:self beginChangeItemWithIndex:item.tag - 999];
        }
    }
    else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CGPoint point = [recognizer locationInView:self];
        
        if (point.y < _lastIndex * self.itemSize.height && point.y > 0) {
            [self selectIndex:_lastIndex - 1];
        }
        else if (point.y > _lastIndex * self.itemSize.height + _slidr.bounds.size.height && point.y < self.itemSize.height * self.dataArray.count + _slidr.bounds.size.height - self.itemSize.height) {
            [self selectIndex:_lastIndex + 1];
        }
        if (self.delegate && [self.delegate respondsToSelector:@selector(ZTLetterIndex:isChangingItemWithIndex:)]) {
            [self.delegate ZTLetterIndex:self isChangingItemWithIndex:_lastIndex];
        }
    }
    else if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateCancelled) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(ZTLetterIndex:endChangeItemWithIndex:)]) {
            [self.delegate ZTLetterIndex:self endChangeItemWithIndex:_lastIndex];
        }
    }
    
}

- (void)selectIndex:(NSInteger)index;
{
    UILabel *item = (UILabel *)[self viewWithTag:index + 999];
    
    if (item.tag - 999 == _lastIndex) {
        return;
    }
    
    UILabel *oldItem = [self viewWithTag:_lastIndex + 999];
    
    [UIView animateWithDuration:kAnimationDuration
                     animations:^{
                         _slidr.frame = CGRectMake(_slidr.frame.origin.x, index*self.itemSize.height, _slidr.bounds.size.width, _slidr.bounds.size.height);
                     }
                     completion:^(BOOL finished) {
                         item.textColor = self.selectedTextColor;
                         oldItem.textColor = self.textColor;
                     }];
    
    if (oldItem.tag < item.tag) {
        oldItem.frame = CGRectMake(oldItem.frame.origin.x, oldItem.frame.origin.y + (_slidr.bounds.size.height - self.itemSize.height), self.itemSize.width, self.itemSize.height);
        for (int i = (int)_lastIndex; i < item.tag - 999; ++i) {
            UILabel *changeItem = [self viewWithTag:i + 999];
            changeItem.frame = CGRectMake(changeItem.frame.origin.x, changeItem.frame.origin.y - (_slidr.bounds.size.height - self.itemSize.height), changeItem.bounds.size.width, changeItem.bounds.size.height);
        }
        item.frame = _slidr.frame;
    }
    else if (oldItem.tag > item.tag) {
        oldItem.frame = CGRectMake(oldItem.frame.origin.x, oldItem.frame.origin.y + (_slidr.bounds.size.height - self.itemSize.height), self.itemSize.width, self.itemSize.height);
        for (int i = (int)item.tag - 999 + 1; i < _lastIndex; ++i) {
            UIButton *changeItem = [self viewWithTag:i + 999];
            changeItem.frame = CGRectMake(changeItem.frame.origin.x, changeItem.frame.origin.y + (_slidr.bounds.size.height - self.itemSize.height), changeItem.bounds.size.width, changeItem.bounds.size.height);
        }
        item.frame = _slidr.frame;
    }
    _lastIndex = item.tag - 999;
}

@end
