//  UIScrollView+MJRefresh.h
//  MJRefreshExample
//
//  Created by MJ Lee on 15/3/4.
//  Copyright (c) 2015年 小码哥. All rights reserved.
//  给ScrollView增加下拉刷新、上拉刷新的功能

#import <UIKit/UIKit.h>

@class MJRefreshHeader, MJRefreshFooter;

@interface UIScrollView (MJRefresh)
/** 下拉刷新控件 */
@property (strong, nonatomic) MJRefreshHeader *header;
/** 上拉刷新控件 */
@property (strong, nonatomic) MJRefreshFooter *footer;

#pragma mark - other
- (NSInteger)totalDataCount;
@property (copy, nonatomic) void (^reloadDataBlock)(NSInteger totalDataCount);
@end
