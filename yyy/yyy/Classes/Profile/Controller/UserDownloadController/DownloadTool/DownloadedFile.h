//
//  DownloadedFile.h
//  yyy
//
//  Created by TangXing on 16/3/17.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadedFile : NSObject <NSCoding>

/** 已下载文件数据数组 */
@property (nonatomic,copy) NSArray *downloadedFile;

+ (instancetype)downloadedFileWithDic:(NSDictionary *)dic;

@end
