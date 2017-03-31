//
//  ZTLetterIndex.h
//  ZTLetterIndexDemo
//
//  Created by 赵天福 on 2017/3/20.
//  Copyright © 2017年 赵天福. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZTLetterIndex;

@protocol ZTLetterIndexDelegate <NSObject>

/**
 点击回调
 */
- (void)ZTLetterIndex:(ZTLetterIndex *)indexView didSelectedItemWithIndex:(NSInteger)index;

/**
 滑动时回调
 */
- (void)ZTLetterIndex:(ZTLetterIndex *)indexView isChangingItemWithIndex:(NSInteger)index;

/**
 滑动开始回调
 */
- (void)ZTLetterIndex:(ZTLetterIndex *)indexView beginChangeItemWithIndex:(NSInteger)index;

/**
 滑动结束回调
 */
- (void)ZTLetterIndex:(ZTLetterIndex *)indexView endChangeItemWithIndex:(NSInteger)index;

@end

@interface ZTLetterIndex : UIView

/**
 必填参数,数据源,其他属性赋值后最后赋值
 */
@property(nonatomic, strong) NSArray *dataArray;

/**
 item尺寸,默认CGSizeMake(12.0f, 16.0f)
 */
@property(nonatomic, assign) CGSize itemSize;

/**
 滑块Size,默认宽度等于itemSize,CGSizeMake(12.0f, 40.0f)
 */
@property(nonatomic, assign) CGSize sliderSize;

/**
 文字字体，默认PingFangSC-Medium size:11
 */
@property(nonatomic, strong) UIFont *textFont;
/**
 文字颜色，默认lightGrayColor
 */
@property(nonatomic, strong) UIColor *textColor;

/**
 选中文字颜色，默认whiteColor
 */
@property(nonatomic, strong) UIColor *selectedTextColor;

/**
 slider颜色，默认lightGrayColor
 */
@property(nonatomic, strong) UIColor *sliderColor;

/**
 slider与上下Item间隙，默认4.0f
 */
@property(nonatomic, assign) CGFloat sliderSpace;

- (void)selectIndex:(NSInteger)index;

@property(nonatomic, assign) id<ZTLetterIndexDelegate>delegate;

@end
