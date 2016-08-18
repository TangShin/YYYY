//
//  SystemNoticeFrame.h
//  yyy
//
//  Created by TangXing on 16/5/3.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import <Foundation/Foundation.h>

// 时间字体
#define SystemNoticeCellTimeFont [UIFont systemFontOfSize:12]
// 私信字体
#define SystemNoticeCellContentFont [UIFont systemFontOfSize:14]

// cell之间的间距
#define SystemNoticeCellMargin 0

// cell的边框宽度
#define SystemNoticeCellBorderW 10

@class SystemNoticeModel;

@interface SystemNoticeFrame : NSObject

@property (strong,nonatomic) SystemNoticeModel *systemNotice;

/** 时间 */
@property (nonatomic, assign) CGRect timeLabelF;
/** 私信 */
@property (nonatomic, assign) CGRect contentLabelF;

/** cell的高度 */
@property (nonatomic, assign) CGFloat cellHeight;

@end
