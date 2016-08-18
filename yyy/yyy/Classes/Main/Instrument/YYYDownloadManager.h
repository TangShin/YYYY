//
//  YYYDownloadManager.h
//  yyy
//
//  Created by TangXing on 16/4/7.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

typedef void(^DownloadProgressBlock)(CGFloat progress, CGFloat totalMBRead, CGFloat totalMBExpectedToRead);
typedef void(^DownloadSuccessBlock)(AFHTTPRequestOperation *operation, id responseObject);
typedef void(^DownloadFailureBlock)(AFHTTPRequestOperation *operation, NSError *error);

@interface YYYDownloadManager : NSObject

#pragma mark - 类方法

/**
 *  开始下载文件
 *
 *  @param URLString     文件链接
 *  @param path          本地路径 (已做处理，传个 `xx.xxx` 即可，如 `demo.mp3`)
 *  @param progressBlock 进度回调
 *  @param successBlock  成功回调
 *  @param failureBlock  失败回调
 *
 *  @return 下载任务
 */
+ (AFHTTPRequestOperation *)downloadFileWithURLString:(NSString *)URLString
                                          toDirectory:(NSString *)directory
                                            cachePath:(NSString *)cachePath
                                             progress:(DownloadProgressBlock)progressBlock
                                              success:(DownloadSuccessBlock)successBlock
                                              failure:(DownloadFailureBlock)failureBlock;
/**
 *  暂停下载文件
 *
 *  @param operation 下载任务
 */
+ (void)pauseWithOperation:(AFHTTPRequestOperation *)operation;

/**
 *  获取文件大小
 *
 *  @param path 本地路径
 *
 *  @return 文件大小
 */
+ (unsigned long long)fileSizeForPath:(NSString *)path;

#pragma mark - 实例方法

/**
 *  开始下载文件
 *
 *  @param URLString     文件链接
 *  @param path          本地路径 (已做处理，传个 `xx.xxx` 即可，如 `demo.mp3`)
 *  @param progressBlock 进度回调
 *  @param successBlock  成功回调
 *  @param failureBlock  失败回调
 *
 *  @return 下载任务
 */
- (AFHTTPRequestOperation *)downloadFileWithURLString:(NSString *)URLString
                                          toDirectory:(NSString *)directory
                                            cachePath:(NSString *)cachePath
                                             progress:(DownloadProgressBlock)progressBlock
                                              success:(DownloadSuccessBlock)successBlock
                                              failure:(DownloadFailureBlock)failureBlock;
/**
 *  暂停下载文件
 *
 *  @param operation 下载任务
 */
- (void)pauseWithOperation:(AFHTTPRequestOperation *)operation;

/**
 *  获取文件大小
 *
 *  @param path 本地路径
 *
 *  @return 文件大小
 */
- (unsigned long long)fileSizeForPath:(NSString *)path;
@end
