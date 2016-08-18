//
//  YYYScrollView.m
//  yyy
//
//  Created by TangXing on 15/10/23.
//  Copyright © 2015年 yiyinyue. All rights reserved.
//

#import "YYYScrollView.h"

@implementation YYYScrollView

//- (BOOL)touchesShouldBegin:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event inContentView:(UIView *)view
//{
//    TSLog(@"tangshin123");
//    return YES;
//}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    if ([view isKindOfClass:[UIButton class]]) {
        return YES;
    }
    return [super touchesShouldCancelInContentView:view];
}

@end
