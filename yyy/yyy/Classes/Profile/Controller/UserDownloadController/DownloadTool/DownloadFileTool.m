//
//  DownloadFileTool.m
//  yyy
//
//  Created by TangXing on 16/3/17.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

// 已下载文件数据数组的存储路径
#define downloadedFilePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"downloadedFile.archive"]
// 正在下载文件数据数组的存储路径
#define downloadingFilePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"downloadingFile.archive"]

#import "DownloadFileTool.h"

@implementation DownloadFileTool

+ (void)saveDownloadedFile:(DownloadedFile *)downloadedFile
{
    [NSKeyedArchiver archiveRootObject:downloadedFile toFile:downloadedFilePath];
}

+ (DownloadedFile *)downloadedFile
{
    DownloadedFile *downloadedFile = [NSKeyedUnarchiver unarchiveObjectWithFile:downloadedFilePath];
    return downloadedFile;
}


+ (void)saveDownloadingFile:(DownloadingFile *)downloadingFile
{
    [NSKeyedArchiver archiveRootObject:downloadingFile toFile:downloadingFilePath];
}

+ (DownloadingFile *)downloadingFile
{
    DownloadingFile *downloadingFile = [NSKeyedUnarchiver unarchiveObjectWithFile:downloadingFilePath];
    return downloadingFile;
}

@end
