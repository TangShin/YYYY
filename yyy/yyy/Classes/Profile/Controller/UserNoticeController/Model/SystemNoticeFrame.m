//
//  SystemNoticeFrame.m
//  yyy
//
//  Created by TangXing on 16/5/3.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import "SystemNoticeFrame.h"
#import "SystemNoticeModel.h"

@implementation SystemNoticeFrame

- (void)setSystemNotice:(SystemNoticeModel *)systemNotice
{
    _systemNotice = systemNotice;
    
    //  cell的宽度
    CGFloat cellW = [UIScreen mainScreen].bounds.size.width;
    
    /** 时间 */
    CGSize timeSize = [systemNotice.sendTime sizeWithFont:SystemNoticeCellTimeFont];
    CGFloat timeX = (cellW - timeSize.width) / 2;
    CGFloat timeY = SystemNoticeCellBorderW;
    self.timeLabelF = (CGRect){{timeX,timeY},timeSize};
    
    /** 内容 */
    CGFloat contentMaxW = cellW - SystemNoticeCellBorderW * 4;
    CGSize contentSize = [systemNotice.content sizeWithFont:SystemNoticeCellContentFont maxW:contentMaxW];
    
    /** 不让内容紧贴文本边框 */
    contentSize.height += 20;
    
    CGFloat contentX = 20;
    CGFloat contentY = CGRectGetMaxY(self.timeLabelF) + SystemNoticeCellBorderW / 2;
    self.contentLabelF = (CGRect){{contentX,contentY},contentSize};
    
    /* cell的高度 */
    self.cellHeight = CGRectGetMaxY(self.contentLabelF);
}

@end
