//
//  UserInfoTool.h
//  yyy
//
//  Created by TangXing on 15/11/12.
//  Copyright © 2015年 yiyinyue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserInfo.h"

@interface UserInfoTool : NSObject

/**
 *  存储账号信息
 *
 *  @param UserInfo 账号模型
 */
+ (void)saveUserInfo:(UserInfo *)userInfo;

/**
 *  返回账号信息
 *
 *  @return 账号模型（如果账号过期，返回nil）
 */
+ (UserInfo *)userInfo;

@end
