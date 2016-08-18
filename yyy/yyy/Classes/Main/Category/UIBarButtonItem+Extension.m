//
//  UIBarButtonItem+Extension.m
//  TangShin微博
//
//  Created by TangShin on 15/6/15.
//  Copyright (c) 2015年 tangshin. All rights reserved.
//

#import "UIBarButtonItem+Extension.h"

@implementation UIBarButtonItem (Extension)

+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [btn setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:highImage] forState:UIControlStateHighlighted];
    
    btn.size = btn.currentBackgroundImage.size;   //获取图片的尺寸并设置成按钮的尺寸

    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action name:(NSString *)name color:(UIColor *)color
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [btn setTitle:name forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    
//    //根据计算文字的长度改变button大小
//    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14]};
//    NSString *labelValue = name;
//    CGFloat length = [labelValue boundingRectWithSize:CGSizeMake(60, 20) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
//    btn.size = CGSizeMake(length, 20);   //获取图片的尺寸并设置成按钮的尺寸
    btn.titleLabel.font = [UIFont systemFontOfSize:16.0];
    btn.frame = CGRectMake(0, 0, 40, 20);
    
    return [[UIBarButtonItem alloc] initWithCustomView:btn];
}

@end
