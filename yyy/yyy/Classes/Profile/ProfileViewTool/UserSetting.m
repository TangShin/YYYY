//
//  UserSetting.m
//  yyy
//
//  Created by TangXing on 16/4/1.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import "UserSetting.h"
#import "MJExtension.h"

@implementation UserSetting

+(instancetype)UserSettingWithDic:(NSDictionary *)dic;
{
    UserSetting *userSetting = [[self alloc] init];
    userSetting.autoPlay = [dic[@"autoPlay"] boolValue];
    userSetting.autoFullScreenPlay = [dic[@"autoFullScreenPlay"] boolValue];
    userSetting.netWorkSatePlay = [dic[@"netWorkSatePlay"] boolValue];
    userSetting.netWorkSateDownload = [dic[@"netWorkSateDownload"] boolValue];
    userSetting.sendErrorLog = [dic[@"sendErrorLog"] boolValue];
    
    return userSetting;
}

- (void)encodeWithCoder:(NSCoder *)enCoder
{
    [enCoder encodeObject:[NSNumber numberWithBool:self.autoPlay] forKey:@"autoPlay"];
    [enCoder encodeObject:[NSNumber numberWithBool:self.autoFullScreenPlay] forKey:@"autoFullScreenPlay"];
    [enCoder encodeObject:[NSNumber numberWithBool:self.netWorkSatePlay] forKey:@"netWorkSatePlay"];
    [enCoder encodeObject:[NSNumber numberWithBool:self.netWorkSateDownload] forKey:@"netWorkSateDownload"];
    [enCoder encodeObject:[NSNumber numberWithBool:self.sendErrorLog] forKey:@"sendErrorLog"];
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if (self = [super init]) {
        self.autoPlay = [[decoder decodeObjectForKey:@"autoPlay"] boolValue];
        self.autoFullScreenPlay = [[decoder decodeObjectForKey:@"autoFullScreenPlay"] boolValue];
        self.netWorkSatePlay = [[decoder decodeObjectForKey:@"netWorkSatePlay"] boolValue];
        self.netWorkSateDownload = [[decoder decodeObjectForKey:@"netWorkSateDownload"] boolValue];
        self.sendErrorLog = [[decoder decodeObjectForKey:@"sendErrorLog"] boolValue];
    }
    
    return self;
}

@end
