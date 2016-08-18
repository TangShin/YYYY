//
//  ReplyMineFrame.m
//  yyy
//
//  Created by TangXing on 16/5/4.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import "ReplyMineFrame.h"
#import "ReplyMineModel.h"

@implementation ReplyMineFrame

- (void)setReplyMine:(ReplyMineModel *)replyMine
{
    _replyMine = replyMine;
    
    // cell的宽度
    CGFloat cellW = [UIScreen mainScreen].bounds.size.width;
    
    /* 回复 */
    
    /* 头像 */
    CGFloat iconWH = 35;
    CGFloat iconX = ReplyMineCellBorderW;
    CGFloat iconY = ReplyMineCellBorderW;
    self.iconViewF = CGRectMake(iconX, iconY, iconWH, iconWH);
    
    /** 名字在头像与时间文本之间，宽度根据名字长度不固定，所以先计算时间文本宽度 */
    /* 时间 */
    CGSize timeSize = [replyMine.replyTime sizeWithFont:ReplyMineCellTimeFont];
    CGFloat timeX = cellW - timeSize.width - ReplyMineCellBorderW;
    CGFloat timeY = iconY;
    self.timeLabelF = (CGRect){{timeX,timeY},timeSize};
    
    /** 昵称 */
    CGFloat nameX = CGRectGetMaxX(self.iconViewF) + ReplyMineCellBorderW;
    CGFloat nameY = iconY;
    CGFloat nameMaxW = cellW - nameX - timeSize.width - ReplyMineCellBorderW * 2;
    CGSize nameSize = [replyMine.userName singleLinesTextSizeWithFont:ReplyMineCellNameFont maxW:nameMaxW];
    self.nameLabelF = (CGRect){{nameX, nameY}, nameSize};
    
    /* 回复的内容 */
    CGFloat replyContentX = nameX;
    CGFloat replyContentY = CGRectGetMaxY(self.nameLabelF) + ReplyMineCellBorderW;
    CGFloat replyContentMaxW = cellW - nameX - ReplyMineCellBorderW;
    CGSize replyContentSize = [replyMine.replyContent sizeWithFont:ReplyMineCellContentFont maxW:replyContentMaxW];
    self.replyContentLabelF = (CGRect){{replyContentX,replyContentY},replyContentSize};
    
    /* 回复整体 */
    CGFloat replyViewX = 0;
    CGFloat replyViewY = ReplyMineCellMargin;
    CGFloat replyViewW = cellW;
    CGFloat replyViewH = CGRectGetMaxY(self.replyContentLabelF) + ReplyMineCellBorderW;
    self.replyViewF = CGRectMake(replyViewX, replyViewY, replyViewW, replyViewH);
    
    /* 被回复的媒体信息 */
    CGFloat replyMediaInfoX = ReplyMineCellBorderW / 2;
    CGFloat replyMediaInfoY = ReplyMineCellBorderW / 2;
    CGFloat replyMediaMaxW = cellW - nameX - ReplyMineCellBorderW * 3;
    NSString *replyMediaInfoText = [NSString stringWithFormat:@"我的评论: %@",replyMine.replyMediaInfo];
    CGSize replyMediaInfoSize = [replyMediaInfoText sizeWithFont:ReplyMineCellMediaInfoFont maxW:replyMediaMaxW];
    self.replyMediaInfoLabelF = (CGRect){{replyMediaInfoX,replyMediaInfoY},replyMediaInfoSize};
    
    /** 被回复的整体 */
    CGFloat repliedViewX = nameX;
    CGFloat repliedViewY = CGRectGetMaxY(self.replyViewF);
    CGFloat repliedViewW = cellW - nameX - ReplyMineCellBorderW;
    CGFloat repliedViewH = CGRectGetMaxY(self.replyMediaInfoLabelF) + ReplyMineCellBorderW / 2;
    self.repliedViewF = CGRectMake(repliedViewX, repliedViewY, repliedViewW, repliedViewH);
    
    //cell高度
    self.cellHeight = CGRectGetMaxY(self.repliedViewF) + ReplyMineCellBorderW;
    
    //cellLine
    self.cellLineViewF = CGRectMake(nameX, self.cellHeight - 1, cellW - nameX, 1);
}

@end
