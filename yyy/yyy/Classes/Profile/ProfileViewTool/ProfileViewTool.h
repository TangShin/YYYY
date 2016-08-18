//
//  ProfileViewTool.h
//  yyy
//
//  Created by TangXing on 16/3/29.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "VideoHistory.h"
#import "UserSetting.h"

@interface ProfileViewTool : NSObject

+ (void)saveVideoHistory:(VideoHistory *)videoHistory;

+ (VideoHistory *)videoHistory;

+ (void)saveUserSetting:(UserSetting *)userSetting;

+ (UserSetting *)userSetting;


@end
