//
//  SearchHistoryTool.h
//  yyy
//
//  Created by TangXing on 16/3/10.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SearchHistory.h"

@interface SearchHistoryTool : NSObject

+ (void)saveSearchHistory:(SearchHistory *)searchHistory;

+ (SearchHistory *)searchHistory;

@end
