//
//  ProfileViewTool.m
//  yyy
//
//  Created by TangXing on 16/3/29.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

// 视频观看历史的存储路径
#define videoHistoryPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"videoHistory.archive"]
// 用户设置配置的存储路径
#define userSettingPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"userSetting.archive"]

#import "ProfileViewTool.h"

@implementation ProfileViewTool

+ (void)saveVideoHistory:(VideoHistory *)videoHistory
{
    [NSKeyedArchiver archiveRootObject:videoHistory toFile:videoHistoryPath];
}

+ (VideoHistory *)videoHistory
{
    VideoHistory *videoHistory = [NSKeyedUnarchiver unarchiveObjectWithFile:videoHistoryPath];
    return videoHistory;
}

+ (void)saveUserSetting:(UserSetting *)userSetting
{
    [NSKeyedArchiver archiveRootObject:userSetting toFile:userSettingPath];
}

+ (UserSetting *)userSetting
{
    UserSetting *userSetting = [NSKeyedUnarchiver unarchiveObjectWithFile:userSettingPath];
    return userSetting;
}

@end
