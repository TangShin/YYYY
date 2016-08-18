//
//  SearchHistory.h
//  yyy
//
//  Created by TangXing on 16/3/10.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchHistory : NSObject <NSCoding>

/** 搜索历史数组 */
@property (nonatomic,copy) NSArray *searchHistory;

+ (instancetype)searchHistoryWithDic:(NSDictionary *)dic;

@end
