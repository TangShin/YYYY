//
//  UserMessageView.m
//  yyy
//
//  Created by TangXing on 16/5/6.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import "UserMessageView.h"
#import "UserInfoTool.h"

@implementation UserMessageView

- (void)viewDidLoad
{
    [super setMediaId:[UserInfoTool userInfo].userId];
    
    [super viewDidLoad];
}

@end
