//
//  DownloadingFile.m
//  yyy
//
//  Created by TangXing on 16/3/17.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import "DownloadingFile.h"
#import "MJExtension.h"

@implementation DownloadingFile

+(instancetype)downloadingFileWithDic:(NSDictionary *)dic
{
    DownloadingFile *downloadingFile = [[self alloc] init];
    
    downloadingFile.downloadingFile = dic[@"downloadingFile"];
    
    return downloadingFile;
}

- (void)encodeWithCoder:(NSCoder *)encoder
{
    [encoder encodeObject:self.downloadingFile forKey:@"downloadingFile"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.downloadingFile = [decoder decodeObjectForKey:@"downloadingFile"];
    }
    
    return self;
}

@end
