//
//  DownloadingFile.h
//  yyy
//
//  Created by TangXing on 16/3/17.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadingFile : NSObject <NSCoding>

/** 正在下载文件数据数组 */
@property (nonatomic,copy) NSArray *downloadingFile;

+ (instancetype)downloadingFileWithDic:(NSDictionary *)dic;

@end
