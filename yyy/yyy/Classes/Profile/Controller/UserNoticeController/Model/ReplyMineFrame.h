//
//  ReplyMineFrame.h
//  yyy
//
//  Created by TangXing on 16/5/4.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import <Foundation/Foundation.h>

// 用户名字体
#define ReplyMineCellNameFont [UIFont systemFontOfSize:14]
// 时间字体
#define ReplyMineCellTimeFont [UIFont systemFontOfSize:12]
// 回复内容字体
#define ReplyMineCellContentFont ReplyMineCellNameFont
// 被回复的媒体信息字体
#define ReplyMineCellMediaInfoFont ReplyMineCellNameFont
// 被回复的用户名字体
#define ReplyMineCellRepliedNameFont ReplyMineCellNameFont

// cell之间的间距
#define ReplyMineCellMargin 10

// cell的边框宽度
#define ReplyMineCellBorderW 10

@class ReplyMineModel;

@interface ReplyMineFrame : NSObject

@property (strong,nonatomic) ReplyMineModel *replyMine;

/** 回复整体 */
@property (nonatomic, assign) CGRect replyViewF;
/** 头像 */
@property (nonatomic, assign) CGRect iconViewF;
/** 用户名 */
@property (nonatomic, assign) CGRect nameLabelF;
/** 时间 */
@property (nonatomic, assign) CGRect timeLabelF;
/** 回复内容 */
@property (nonatomic, assign) CGRect replyContentLabelF;
/** 被回复的媒体信息 */
@property (nonatomic, assign) CGRect replyMediaInfoLabelF;
/** 被回复的用户名 */
@property (nonatomic, assign) CGRect repliedNameLabelF;
/** 被回复整体 */
@property (nonatomic, assign) CGRect repliedViewF;

/** cell的高度 */
@property (nonatomic, assign) CGFloat cellHeight;
/** cell分割线 */
@property (nonatomic, assign) CGRect cellLineViewF;

@end
