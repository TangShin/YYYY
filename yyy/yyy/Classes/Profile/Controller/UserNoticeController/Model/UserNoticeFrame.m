//
//  UserNoticeFrame.m
//  yyy
//
//  Created by TangXing on 16/4/14.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import "UserNoticeFrame.h"
#import "UserNoticeModel.h"

@implementation UserNoticeFrame

- (void)setUserNotice:(UserNoticeModel *)userNotice
{
    _userNotice = userNotice;
    
    // cell的宽度
    CGFloat cellW = [UIScreen mainScreen].bounds.size.width;
    
    /** 头像 */
    CGFloat iconWH = 50;
    CGFloat iconX = UserNoticeCellBorderW;
    CGFloat iconY = UserNoticeCellBorderW;
    self.iconViewF = CGRectMake(iconX, iconY, iconWH, iconWH);
    
    /** 时间 */
    CGSize timeSize = [userNotice.lastestMessageDate sizeWithFont:UserNoticeCellTimeFont];
    CGFloat timeX = cellW - timeSize.width - UserNoticeCellBorderW;
    CGFloat timeY = iconY;
    self.timeLabelF = (CGRect){{timeX, timeY}, timeSize};
    
    /** 昵称 */
    CGFloat nameX = CGRectGetMaxX(self.iconViewF) + UserNoticeCellBorderW;
    CGFloat nameY = iconY;
    CGFloat nameMaxW = cellW - nameX - timeSize.width - 2 * UserNoticeCellBorderW;
    CGSize nameSize = [userNotice.userName singleLinesTextSizeWithFont:UserNoticeCellNameFont maxW:nameMaxW];
    self.nameLabelF = (CGRect){{nameX, nameY}, nameSize};
    
    /** 消息预览 */
    CGFloat previewMsgX = nameX;
    CGFloat previewMsgY = CGRectGetMaxY(self.nameLabelF) + UserNoticeCellBorderW;
    CGFloat previewMsgMaxW = cellW - previewMsgX - 3 * UserNoticeCellBorderW;
    CGSize previewMsgSize = [userNotice.previewMessage sizeWithFont:UserNoticeCellPreviewMsgFont maxW:previewMsgMaxW];
    previewMsgSize.height = 20;
    self.previewMsgLabelF = (CGRect){{previewMsgX, previewMsgY}, previewMsgSize};
    
    /** 未读消息计数视图 */
    CGSize unreadCountViewSize = [userNotice.unreadMessageCount sizeWithFont:UserNoticeCellUnreadCountFont];
    
    if (unreadCountViewSize.width < 20) {
        unreadCountViewSize.width = 20;
    } else {
        unreadCountViewSize.width += 5;
    }
    unreadCountViewSize.height = 20;
    
    CGFloat unreadCountViewX = cellW - UserNoticeCellBorderW - unreadCountViewSize.width;
    CGFloat unreadCountViewY = previewMsgY;
    
    self.unreadCountViewF = (CGRect){{unreadCountViewX,unreadCountViewY},unreadCountViewSize};
    
    /* cell的高度 */
    self.cellHeight = CGRectGetMaxY(self.previewMsgLabelF) + UserNoticeCellBorderW;
    
    //cellLine
    self.cellLineViewF = CGRectMake(nameX, self.cellHeight - 1, cellW - nameX, 1);
}

@end
