//
//  ViewController.m
//  ZTLetterIndexDemo
//
//  Created by 赵天福 on 2017/3/30.
//  Copyright © 2017年 zt. All rights reserved.
//

#import "ViewController.h"
#import "ZTLetterIndex.h"

#define kScreenWidth ([[UIScreen mainScreen]bounds].size.width)
#define kScreenHeight ([[UIScreen mainScreen]bounds].size.height)


@interface ViewController ()<UITableViewDataSource, UITableViewDelegate, ZTLetterIndexDelegate>
{
    NSMutableArray *_dataSource;
    NSMutableArray *_letterArray;
    ZTLetterIndex  *_letterIndex;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _dataSource = [NSMutableArray array];
    for (int i = 0; i < 26; ++i) {
        NSMutableArray *temp = [NSMutableArray array];
        for (int i = 0; i < arc4random()%5+3; ++i) {
            [temp addObject:[NSString stringWithFormat:@"%d",arc4random()%10000]];
        }
        [_dataSource addObject:temp];
    }
    
    _letterArray = [NSMutableArray array];
    for (char c='A';c<='Z';c++) {
        [_letterArray addObject:[NSString stringWithFormat:@"%c",c]];
    }
    
    _letterIndex = [[ZTLetterIndex alloc] initWithFrame:CGRectMake(kScreenWidth-20, (kScreenHeight - 16*25 - 40)/2, 12, 16*25 + 40)];
    _letterIndex.dataArray = _letterArray; //在其他用于展示的属性赋值之后赋值
    _letterIndex.delegate = self;
    [self.view addSubview:_letterIndex];
}

#pragma mark - ZTLetterIndexDelegate
- (void)ZTLetterIndex:(ZTLetterIndex *)indexView didSelectedItemWithIndex:(NSInteger)index
{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (void)ZTLetterIndex:(ZTLetterIndex *)indexView beginChangeItemWithIndex:(NSInteger)index
{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (void)ZTLetterIndex:(ZTLetterIndex *)indexView endChangeItemWithIndex:(NSInteger)index
{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

- (void)ZTLetterIndex:(ZTLetterIndex *)indexView isChangingItemWithIndex:(NSInteger)index
{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:index] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

#pragma mark - UITableViewDelegate&DateSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    }
    cell.textLabel.text = _dataSource[indexPath.section][indexPath.row];

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return _letterArray[section];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _dataSource.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataSource[section] count];
}

#pragma mark -UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:scrollView.contentOffset];
    [_letterIndex selectIndex:indexPath.section];
}

@end
