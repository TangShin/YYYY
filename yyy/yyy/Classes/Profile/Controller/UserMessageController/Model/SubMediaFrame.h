//
//  SubMediaFrame.h
//  yyy
//
//  Created by TangXing on 16/5/11.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import <Foundation/Foundation.h>

#define likeImgName @"support"

// 用户名字体
#define SubMediaCellNameFont [UIFont systemFontOfSize:14]
// 时间字体
#define SubMediaCellTimeFont [UIFont systemFontOfSize:12]
//点赞数字体
#define SubMediaCellSupportFont SubMediaCellTimeFont
// 留言内容字体
#define SubMediaCellContentFont SubMediaCellNameFont

// cell之间的间距
#define SubMediaCellMargin 10

// cell的边框宽度
#define SubMediaCellBorderW 10

@class SubMediaModel;

@interface SubMediaFrame : NSObject

@property (strong,nonatomic) SubMediaModel *subMedia;

/** 回复整体 */
@property (nonatomic, assign) CGRect subMediaViewF;
/** 头像 */
@property (nonatomic, assign) CGRect iconViewF;
/** 回复用户名 */
@property (nonatomic, assign) CGRect nameLabelF;
/** 点赞数 */
@property (nonatomic, assign) CGRect likeCountF;
/** 点赞数图片*/
@property (nonatomic, assign) CGRect likeImgF;
/** 时间 */
@property (nonatomic, assign) CGRect timeLabelF;
/** 回复内容 */
@property (nonatomic, assign) CGRect subMediaLabelF;

/** cell的高度 */
@property (nonatomic, assign) CGFloat cellHeight;
/** cell分割线 */
@property (nonatomic, assign) CGRect cellLineViewF;

@end
