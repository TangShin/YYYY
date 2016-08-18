//
//  UIBarButtonItem+Extension.h
//  TangShin微博
//
//  Created by TangShin on 15/6/15.
//  Copyright (c) 2015年 tangshin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Extension)

+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action image:(NSString *)image highImage:(NSString *)highImage;
+ (UIBarButtonItem *)itemWithTarget:(id)target action:(SEL)action name:(NSString *)name color:(UIColor *)color;

@end
