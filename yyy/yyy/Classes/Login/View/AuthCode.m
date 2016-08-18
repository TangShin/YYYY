//
//  AuthCode.m
//  yyy
//
//  Created by TangXing on 16/3/14.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import "AuthCode.h"
#import "UIImage+AFNetworking.h"
#import "UIImageView+WebCache.h"

@implementation AuthCode

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self getAuthCode:YYYVeriCodeGetURL];
    }
    
    return self;
}

- (void)getAuthCode:(NSString *)url
{
    [_img removeFromSuperview];
    _img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:url]]];
    _img.image = image;
    [self addSubview:_img];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    [self  getAuthCode:YYYVeriCodeGetURL];
}

@end
