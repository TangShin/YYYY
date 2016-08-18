//
//  MediaFrame.h
//  yyy
//
//  Created by TangXing on 16/5/6.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import <Foundation/Foundation.h>

#define likeImgName @"support"
#define subMediaImgName @"sub_media"

// 用户名字体
#define MediaCellNameFont [UIFont systemFontOfSize:14]
// 时间字体
#define MediaCellTimeFont [UIFont systemFontOfSize:12]
//点赞数字体
#define MediaCellSupportFont MediaCellTimeFont
//子回复数字体
#define MediaCellSubMediaFont MediaCellTimeFont
// 留言内容字体
#define MediaCellContentFont MediaCellNameFont

// cell之间的间距
#define MediaCellMargin 10

// cell的边框宽度
#define MediaCellBorderW 10

@class MediaModel;

@interface MediaFrame : NSObject

@property (strong,nonatomic) MediaModel *media;

/** 回复整体 */
@property (nonatomic, assign) CGRect mediaViewF;
/** 头像 */
@property (nonatomic, assign) CGRect iconViewF;
/** 用户名 */
@property (nonatomic, assign) CGRect nameLabelF;
/** 子回复数 */
@property (nonatomic, assign) CGRect subMediaCountF;
/** 子回复数图片 */
@property (nonatomic, assign) CGRect subMediaImgF;
/** 点赞数 */
@property (nonatomic, assign) CGRect likeCountF;
/** 点赞数图片*/
@property (nonatomic, assign) CGRect likeImgF;
/** 时间 */
@property (nonatomic, assign) CGRect timeLabelF;
/** 回复内容 */
@property (nonatomic, assign) CGRect mediaLabelF;

/** cell的高度 */
@property (nonatomic, assign) CGFloat cellHeight;
/** cell分割线 */
@property (nonatomic, assign) CGRect cellLineViewF;

@end
