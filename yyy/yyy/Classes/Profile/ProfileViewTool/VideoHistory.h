//
//  VideoHistory.h
//  yyy
//
//  Created by TangXing on 16/3/29.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoHistory : NSObject <NSCoding>

/** 观看视频历史数组 */
@property (nonatomic,copy) NSArray *videoHistory;

+ (instancetype)videoHistoryWithDic:(NSDictionary *)dic;

@end