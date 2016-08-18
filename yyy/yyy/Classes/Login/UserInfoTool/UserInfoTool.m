//
//  UserInfoTool.m
//  yyy
//
//  Created by TangXing on 15/11/12.
//  Copyright © 2015年 yiyinyue. All rights reserved.
//

// 账号的存储路径
#define UserInfoPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"userInfo.archive"]

#import "UserInfoTool.h"

@implementation UserInfoTool

/**
 *  存储账号信息
 *
 *  @param UserInfo 账号模型
 */
+ (void)saveUserInfo:(UserInfo *)userInfo
{
    // 自定义对象的存储必须用NSKeyedArchiver，不再有什么writeToFile方法
    [NSKeyedArchiver archiveRootObject:userInfo toFile:UserInfoPath];
}

/**
 *  返回账号信息
 *
 *  @return 账号模型（如果账号过期，返回nil）
 */
+ (UserInfo *)userInfo
{
    // 加载模型
    UserInfo *userInfo = [NSKeyedUnarchiver unarchiveObjectWithFile:UserInfoPath];
    
    return userInfo;
}

@end
