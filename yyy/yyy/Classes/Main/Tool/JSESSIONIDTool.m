//
//  JSESSIONID.m
//  yyy
//
//  Created by TangXing on 15/11/23.
//  Copyright © 2015年 yiyinyue. All rights reserved.
//
#define JsessionIdPath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"jsessionId.archive"]

#import "JSESSIONIDTool.h"

@implementation JSESSIONIDTool

/**
 *  存储JSESSIONID
 *
 *  @param JsessionId JSESSIONID模型
 */
+ (void)saveJsessionId:(JSESSIONID *)jsessionId
{
    // 自定义对象的存储必须用NSKeyedArchiver，不再有什么writeToFile方法
    [NSKeyedArchiver archiveRootObject:jsessionId toFile:JsessionIdPath];
}

/**
 *  返回JSESSIONID
 *
 *  @return JSESSIONID模型
 */
+ (JSESSIONID *)jsessionId
{
    // 加载模型
    JSESSIONID *jsessionId = [NSKeyedUnarchiver unarchiveObjectWithFile:JsessionIdPath];
    
    return jsessionId;
}

@end
