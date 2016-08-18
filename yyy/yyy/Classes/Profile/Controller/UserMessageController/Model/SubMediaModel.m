//
//  SubMediaModel.m
//  yyy
//
//  Created by TangXing on 16/5/10.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import "SubMediaModel.h"

@implementation SubMediaModel

- (NSString *)content
{
    if(_reUserId == nil) return _content;
    return [NSString stringWithFormat:@"回复 %@ : %@",_reUserName,_content];
}

@end
