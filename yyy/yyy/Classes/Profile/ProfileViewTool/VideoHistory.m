//
//  VideoHistory.m
//  yyy
//
//  Created by TangXing on 16/3/29.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import "VideoHistory.h"
#import "MJExtension.h"

@implementation VideoHistory

+(instancetype)videoHistoryWithDic:(NSDictionary *)dic
{
    VideoHistory *videoHistory = [[self alloc] init];
    videoHistory.videoHistory = dic[@"videoHistory"];
    
    return videoHistory;
}

- (void)encodeWithCoder:(NSCoder *)enCoder
{
    [enCoder encodeObject:self.videoHistory forKey:@"videoHistory"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.videoHistory = [decoder decodeObjectForKey:@"videoHistory"];
    }
    
    return self;
}

@end
