//
//  UIView+TSFrame.h
//  TangShin微博
//
//  Created by TangShin on 15/6/11.
//  Copyright (c) 2015年 tangshin. All rights reserved.
//  此分类能够直接设置UIView发Frame的X,Y值或者size的值

#import <UIKit/UIKit.h>

@interface UIView (TSFrame)

@property (assign,nonatomic) CGFloat x;
@property (assign,nonatomic) CGFloat y;
@property (assign,nonatomic) CGFloat centerX;
@property (assign,nonatomic) CGFloat centerY;
@property (assign,nonatomic) CGFloat width;
@property (assign,nonatomic) CGFloat height;
@property (assign,nonatomic) CGSize size;
@property (assign,nonatomic) CGPoint origin;

/**
 *  上 < Shortcut for frame.origin.y
 */
@property (nonatomic) CGFloat top;

/**
 *  下 < Shortcut for frame.origin.y + frame.size.height
 */
@property (nonatomic) CGFloat bottom;

/**
 *  左 < Shortcut for frame.origin.x.
 */
@property (nonatomic) CGFloat left;

/**
 *  右 < Shortcut for frame.origin.x + frame.size.width
 */
@property (nonatomic) CGFloat right;

/**
 *  设置镂空中间的视图
 *
 *  @param centerFrame 中间镂空的框架
 */

- (void)setHollowWithCenterFrame:(CGRect)centerFrame;

/**
 *  获取屏幕图片
 *  @return image
 */
- (UIImage *)imageFromSelfView;

@end
