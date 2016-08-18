//
//  LCDownloadManager.m
//  TTlol
//
//  Created by 刘超 on 15/7/9.
//  Copyright (c) 2015年 Leo. All rights reserved.
//

#import "YYYDownloadManager.h"
#import "GlobalVariables.h"

@interface YYYDownloadManager ()

@property (nonatomic, strong) NSMutableArray *paths;
@property (nonatomic,retain) GlobalVariables *glo;

@end

@implementation YYYDownloadManager

- (NSMutableArray *)paths {
    
    if (!_paths) {
        
        _paths = [[NSMutableArray alloc] init];
    }
    
    return _paths;
}

#pragma mark - 类方法

+ (unsigned long long)fileSizeForPath:(NSString *)path {
    
    return [[self alloc] fileSizeForPath:path];
}

+ (AFHTTPRequestOperation *)downloadFileWithURLString:(NSString *)URLString toDirectory:(NSString *)directory cachePath:(NSString *)cachePath progress:(DownloadProgressBlock)progressBlock success:(DownloadSuccessBlock)successBlock failure:(DownloadFailureBlock)failureBlock {
    
    return [[self alloc] downloadFileWithURLString:URLString
                                       toDirectory:directory
                                         cachePath:cachePath
                                          progress:progressBlock
                                           success:successBlock
                                           failure:failureBlock];
}

+ (void)pauseWithOperation:(AFHTTPRequestOperation *)operation {
    
    [[self alloc] pauseWithOperation:operation];
}

#pragma mark - 实例方法

- (unsigned long long)fileSizeForPath:(NSString *)path {
    
    signed long long fileSize = 0;
    
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    
    if ([fileManager fileExistsAtPath:path]) {
        
        NSError *error = nil;
        
        NSDictionary *fileDict = [fileManager attributesOfItemAtPath:path error:&error];
        
        if (!error && fileDict) {
            
            fileSize = [fileDict fileSize];
        }
    }
    
    return fileSize;
}

- (AFHTTPRequestOperation *)downloadFileWithURLString:(NSString *)URLString toDirectory:(NSString *)directory cachePath:(NSString *)cachePath progress:(DownloadProgressBlock)progressBlock success:(DownloadSuccessBlock)successBlock failure:(DownloadFailureBlock)failureBlock {
    
    _glo = GlobalVariables.getInstance;
    if (!_glo.downloading) {
        return nil;
    }
    
//    NSString *docPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *docPath = [NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),directory];
    
    BOOL isDir = NO;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL existed = [fileManager fileExistsAtPath:docPath isDirectory:&isDir];
    
    if (!(isDir == YES && existed == YES)) {
        
        [fileManager createDirectoryAtPath:docPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    NSString *filePath = [docPath stringByAppendingPathComponent:cachePath];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:URLString]];
    unsigned long long downloadedBytes = 0;
    
    NSLog(@"%s -> Line:%d -> FilePath:\n%@", __func__, __LINE__, filePath);
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath]) {
        
        // 获取已下载的文件长度
        downloadedBytes = [self fileSizeForPath:filePath];
        
        // 检查文件是否已经下载了一部分
        if (downloadedBytes > 0) {
            
            NSMutableURLRequest *mutableURLRequest = [request mutableCopy];
            NSString *requestRange = [NSString stringWithFormat:@"bytes=%llu-", downloadedBytes];
            [mutableURLRequest setValue:requestRange forHTTPHeaderField:@"Range"];
            request = mutableURLRequest;
        }
    }
    
    // 不使用缓存，避免断点续传出现问题
    [[NSURLCache sharedURLCache] removeCachedResponseForRequest:request];
    
    // 下载请求
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    // 检查是否已经有该下载任务. 如果有, 释放掉...
    for (NSDictionary *dic in self.paths) {
        
        if ([cachePath isEqualToString:dic[@"path"]] && ![(AFHTTPRequestOperation *)dic[@"operation"] isPaused]) {
            
            return dic[@"operation"];
            
        } else {
            
            [(AFHTTPRequestOperation *)dic[@"operation"] cancel];
        }
    }
    NSDictionary *dicNew = @{@"path"      : cachePath,
                             @"operation" : operation};
    [self.paths addObject:dicNew];
    
    // 下载路径
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:filePath append:YES];
    
    // 下载进度回调
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        
        // 下载进度
        CGFloat progress = ((CGFloat)totalBytesRead + downloadedBytes) / (totalBytesExpectedToRead + downloadedBytes);
        
        progressBlock(progress, (totalBytesRead + downloadedBytes) / 1024 / 1024.0f, (totalBytesExpectedToRead + downloadedBytes) / 1024 / 1024.0f);
    }];
    
    // 成功和失败回调
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        successBlock(operation, responseObject);
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        failureBlock(operation, error);
    }];
    
    [operation start];
    
    // 为了做暂停功能，把这个下载任务返回
    return operation;
}

- (void)pauseWithOperation:(AFHTTPRequestOperation *)operation {
    
    NSLog(@"Pause download");
    
    [operation pause];
}

@end
