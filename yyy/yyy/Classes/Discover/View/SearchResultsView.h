//
//  SearchResultsView.h
//  yyy
//
//  Created by TangXing on 16/3/7.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchResultsDelegate <NSObject>

- (void)searchResultsViewWillBeginDragging:(UIScrollView *)scrollView;

@end

@interface SearchResultsView : UIView

@property (strong,nonatomic) NSString *searchDiv;
@property (strong,nonatomic) NSString *searchText;//搜索关键字
@property (strong,nonatomic) UIViewController *fatherViewController;

@property (weak,nonatomic) id<SearchResultsDelegate> delegate;

- (UIView *)setUpSearchResultsViewWithButtonNames:(NSArray *)btnName;

- (void)loadSearchResultsViewsData:(NSString *)searchText;
- (void)reloadSlideViewOrigin;

@end
