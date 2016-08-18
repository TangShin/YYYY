//
//  YYYTitleView.m
//  yyy
//
//  Created by TangXing on 15/10/20.
//  Copyright © 2015年 yiyinyue. All rights reserved.
//

#import "YYYTitleView.h"

@implementation YYYTitleView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    
    return self;
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:CGRectMake(0, 0, self.superview.bounds.size.width, self.superview.bounds.size.height)];
}

@end
