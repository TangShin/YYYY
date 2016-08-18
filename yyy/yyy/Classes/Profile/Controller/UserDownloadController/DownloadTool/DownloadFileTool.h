//
//  DownloadFileTool.h
//  yyy
//
//  Created by TangXing on 16/3/17.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DownloadedFile.h"
#import "DownloadingFile.h"

@interface DownloadFileTool : NSObject

+ (void)saveDownloadedFile:(DownloadedFile *)downloadedFile;
+ (DownloadedFile *)downloadedFile;

+ (void)saveDownloadingFile:(DownloadingFile *)downloadingFile;
+ (DownloadingFile *)downloadingFile;

@end
