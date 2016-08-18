//
//  UserSetting.h
//  yyy
//
//  Created by TangXing on 16/4/1.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserSetting : NSObject

//自动播放
@property (assign,nonatomic) BOOL autoPlay;
//自动全屏播放
@property (assign,nonatomic) BOOL autoFullScreenPlay;
//2G/3G/4G下自动播放
@property (assign,nonatomic) BOOL netWorkSatePlay;
//2G/3G/4G下自动下载
@property (assign,nonatomic) BOOL netWorkSateDownload;
//是否发送错误日志
@property (assign,nonatomic) BOOL sendErrorLog;

+ (instancetype)UserSettingWithDic:(NSDictionary *)dic;

@end
