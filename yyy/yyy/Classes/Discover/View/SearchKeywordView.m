//
//  SearchHistoryView.m
//  yyy
//
//  Created by TangXing on 16/3/9.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import "SearchKeywordView.h"

#import "TextCollectionCell.h"
#import "SearchReusableView.h"

@interface SearchKeywordView () <UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>

@end

@implementation SearchKeywordView

static NSString *textID = @"textID";
static NSString *headerHistory = @"headerHistory";
static NSString *hotKeyword = @"hotKeyword";

- (instancetype)initWithFrame:(CGRect)frame
{
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    
    self.delegate = self;
    self.dataSource = self;
    
    [self registerClass:[TextCollectionCell class] forCellWithReuseIdentifier:textID];
    [self registerClass:[SearchReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader  withReuseIdentifier:headerHistory];
    [self registerClass:[SearchReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader  withReuseIdentifier:hotKeyword];
    [self registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter  withReuseIdentifier:@"footer"];
    
    return [self initWithFrame:frame collectionViewLayout:layout];
}

#pragma mark <UICollectionViewDataSource>
//定义每个item的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPathcollectionView
{
    return CGSizeMake((kScreenWidth-30)/2, 20);
}

//定义每个uicollectionview的margin
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 10, 0, 10);
}

//展示的section的个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (_searchHistory.count > 0) {
        return 2;
    }
    return 1;
}

//展示的cell的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0 && _searchHistory.count > 0) {
        return _searchHistory.count;
    }
    return _searchKeyword.count;
}

//每个cell展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    TextCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:textID forIndexPath:indexPath];
    
    if (indexPath.section == 0 && _searchHistory.count > 0) {
        cell.title.text = _searchHistory[_searchHistory.count - 1 - indexPath.row];
        return cell;
    }
    cell.title.text = _searchKeyword[indexPath.row];
    
    return cell;
}

//页眉
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {

    if (kind == UICollectionElementKindSectionHeader) {
        if (indexPath.section == 0 && _searchHistory.count > 0) {
            SearchReusableView *historyHeader = [collectionView  dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerHistory forIndexPath:indexPath];
            
            historyHeader.backgroundColor = [UIColor whiteColor];
            historyHeader.text = @"历史搜索";
            [historyHeader.clickBtn addTarget:self action:@selector(clearHistory) forControlEvents:UIControlEventTouchUpInside];
            return historyHeader;
        }
        SearchReusableView *hotKeywordHeader = [collectionView  dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:hotKeyword forIndexPath:indexPath];
        
        hotKeywordHeader.backgroundColor = [UIColor whiteColor];
        hotKeywordHeader.text = @"热门搜索";
        hotKeywordHeader.clickBtn.hidden = YES;
        return hotKeywordHeader;
    }
    
    if (kind == UICollectionElementKindSectionFooter) {
        UICollectionReusableView *footer = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
        return footer;
    }
    return nil;
}

//UIcollectionView被选中时调用的方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (_keywordDelegate) {
        [_keywordDelegate collectionView:self didSelectItemAtIndexPath:indexPath];
    }
}

//collection的页眉
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(kScreenWidth , 30);
}

//collection的页脚
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    return CGSizeMake(kScreenWidth, 40);
}

- (void)clearHistory
{
    if (_keywordDelegate) {
        [_keywordDelegate clearHistory];
        _searchHistory = nil;
        [self reloadData];
    }
}
@end
