//
//  NoNetworkView.m
//  yyy
//
//  Created by TangXing on 16/5/6.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import "NoNetworkView.h"

@implementation NoNetworkView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUpUI:frame];
    }
    return self;
}

- (void)setUpUI:(CGRect)frame
{
    self.backgroundColor = [UIColor whiteColor];
    
    UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [refreshBtn setImage:[UIImage imageNamed:@"noNetwork.jpg"] forState:UIControlStateNormal];
    [refreshBtn setFrame:CGRectMake(0, 0, 184, 200)];
    [refreshBtn setBackgroundColor:[UIColor whiteColor]];
    [refreshBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    refreshBtn.center = self.center;
    
    [self addSubview:refreshBtn];
}

- (void)buttonClick:(UIButton *)sender
{
    if (_noNetworkDelegate) {
        [_noNetworkDelegate NoNetworkViewClick];
    }
}

@end
