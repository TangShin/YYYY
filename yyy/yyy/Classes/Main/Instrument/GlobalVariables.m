//
//  GlobalVariables.m
//  yyy
//
//  Created by TangXing on 16/4/8.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import "GlobalVariables.h"

static GlobalVariables *globalVariables;

@implementation GlobalVariables

+ (GlobalVariables *)getInstance
{
    if (!globalVariables) {
        globalVariables = [[GlobalVariables alloc] init];
        globalVariables.downloading = NO;
        globalVariables.downloadingCellIndex = -1;
    }
    return globalVariables;
}

@end
