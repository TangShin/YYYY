//
//  SearchHistory.m
//  yyy
//
//  Created by TangXing on 16/3/10.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import "SearchHistory.h"
#import "MJExtension.h"

@implementation SearchHistory

+(instancetype)searchHistoryWithDic:(NSDictionary *)dic
{
    SearchHistory *serarchHistory = [[self alloc] init];
    serarchHistory.searchHistory = dic[@"searchHistory"];
    
    return serarchHistory;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.searchHistory forKey:@"searchHistory"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.searchHistory = [decoder decodeObjectForKey:@"searchHistory"];
    }
    
    return self;
}

@end
