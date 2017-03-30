# ZTLetterIndex

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

- (void)selectIndex:(NSInteger)index;

@property(nonatomic, assign) id<ZTLetterIndexDelegate>delegate;
