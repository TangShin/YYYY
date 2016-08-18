//
//  SearchHistoryView.h
//  yyy
//
//  Created by TangXing on 16/3/9.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchKeywordDelegate <NSObject>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;
- (void)clearHistory;

@end

@interface SearchKeywordView : UICollectionView

@property (copy,nonatomic) NSArray *searchKeyword;
@property (copy,nonatomic) NSArray *searchHistory;

@property (nonatomic,assign)id <SearchKeywordDelegate> keywordDelegate;

@end
