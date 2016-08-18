//
//  DownloadedFile.m
//  yyy
//
//  Created by TangXing on 16/3/17.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import "DownloadedFile.h"
#import "MJExtension.h"

@implementation DownloadedFile

+(instancetype)downloadedFileWithDic:(NSDictionary *)dic
{
    DownloadedFile *downloadedFile = [[self alloc] init];
    
    downloadedFile.downloadedFile = dic[@"downloadedFile"];
    
    return downloadedFile;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.downloadedFile forKey:@"downloadedFile"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.downloadedFile = [decoder decodeObjectForKey:@"downloadedFile"];
    }
    
    return self;
}

@end
