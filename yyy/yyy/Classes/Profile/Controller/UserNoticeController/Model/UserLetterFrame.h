//
//  UserLetterFrame.h
//  yyy
//
//  Created by TangXing on 16/4/18.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import <Foundation/Foundation.h>

// 时间字体
#define UserLetterCellTimeFont [UIFont systemFontOfSize:12]
// 私信字体
#define UserLetterCellContentFont [UIFont systemFontOfSize:14]

// cell之间的间距
#define UserLetterCellMargin 0

// cell的边框宽度
#define UserLetterCellBorderW 10

@class UserLetterModel;

@interface UserLetterFrame : NSObject

@property (nonatomic, strong) UserLetterModel *userLetter;

/** 时间 */
@property (nonatomic, assign) CGRect timeLabelF;
/** 头像 */
@property (nonatomic, assign) CGRect iconViewF;
/** 私信 */
@property (nonatomic, assign) CGRect contentLabelF;

/** cell的高度 */
@property (nonatomic, assign) CGFloat cellHeight;

@end
