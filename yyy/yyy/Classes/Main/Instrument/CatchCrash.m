//
//  CatchCrash.m
//  test1
//
//  Created by TangXing on 16/4/5.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import "CatchCrash.h"

@implementation CatchCrash

void uncaughtExceptionHandler(NSException *exception)
{
    //异常的堆栈信息
    NSArray *stackArray = [exception callStackSymbols];
    
    //出现异常的原因
    NSString *reason = [exception reason];
    
    //异常名称
    NSString *name = [exception name];
    
    NSString *exceptionInfo = [NSString stringWithFormat:@"Exception reason:%@\nException name:%@\nException stack:%@",name,reason,stackArray];
    
    NSMutableArray *tmpArray = [NSMutableArray arrayWithArray:stackArray];
    
    [tmpArray insertObject:reason atIndex:0];
    
    //保存到本地，下次启动的时候，上传到后台
    [exceptionInfo writeToFile:[NSString stringWithFormat:@"%@/Documents/error.log",NSHomeDirectory()] atomically:YES encoding:NSUTF8StringEncoding error:nil];
}

@end
