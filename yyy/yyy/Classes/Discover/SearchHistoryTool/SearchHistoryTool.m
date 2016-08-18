//
//  SearchHistoryTool.m
//  yyy
//
//  Created by TangXing on 16/3/10.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

// 搜索历史的存储路径
#define searchHistoryPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"searchHistory.archive"]

#import "SearchHistoryTool.h"

@implementation SearchHistoryTool

+ (void)saveSearchHistory:(SearchHistory *)searchHistory
{
    [NSKeyedArchiver archiveRootObject:searchHistory toFile:searchHistoryPath];
}

+ (SearchHistory *)searchHistory
{
    SearchHistory *searchHistory = [NSKeyedUnarchiver unarchiveObjectWithFile:searchHistoryPath];
    return searchHistory;
}

@end
