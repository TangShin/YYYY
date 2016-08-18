//
//  UserNoticeFrame.h
//  yyy
//
//  Created by TangXing on 16/4/14.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import <Foundation/Foundation.h>

// 昵称字体
#define UserNoticeCellNameFont [UIFont systemFontOfSize:15]
// 时间字体
#define UserNoticeCellTimeFont [UIFont systemFontOfSize:12]
// 消息预览字体
#define UserNoticeCellPreviewMsgFont [UIFont systemFontOfSize:12]
// 未读消息计数
#define UserNoticeCellUnreadCountFont [UIFont systemFontOfSize:12]

// cell之间的间距
#define UserNoticeCellMargin 0

// cell的边框宽度
#define UserNoticeCellBorderW 10

@class UserNoticeModel;

@interface UserNoticeFrame : NSObject

@property (strong,nonatomic) UserNoticeModel *userNotice;

/** 头像 */
@property (nonatomic, assign) CGRect iconViewF;
/** 昵称 */
@property (nonatomic, assign) CGRect nameLabelF;
/** 时间 */
@property (nonatomic, assign) CGRect timeLabelF;
/** 消息预览 */
@property (nonatomic, assign) CGRect previewMsgLabelF;
/** 未读消息计数 */
@property (nonatomic, assign) CGRect unreadCountViewF;
/** cell分隔线 */
@property (nonatomic, assign) CGRect cellLineViewF;

/** cell的高度 */
@property (nonatomic, assign) CGFloat cellHeight;

@end
