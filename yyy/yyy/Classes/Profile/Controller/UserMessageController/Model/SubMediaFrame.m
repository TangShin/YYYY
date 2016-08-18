//
//  SubMediaFrame.m
//  yyy
//
//  Created by TangXing on 16/5/11.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import "SubMediaFrame.h"
#import "SubMediaModel.h"

@implementation SubMediaFrame

- (void)setSubMedia:(SubMediaModel *)subMedia
{
    _subMedia = subMedia;
    
    // cell的宽度
    CGFloat cellW = [UIScreen mainScreen].bounds.size.width;
    
    /* 头像 */
    CGFloat iconWH = 35;
    CGFloat iconX = SubMediaCellBorderW;
    CGFloat iconY = SubMediaCellBorderW;
    self.iconViewF = CGRectMake(iconX, iconY, iconWH, iconWH);
    
    /* 点赞数 */
    CGSize likeSize = [subMedia.supportCount sizeWithFont:SubMediaCellSupportFont];
    likeSize.width += 5;
    CGFloat likeX = cellW - likeSize.width - SubMediaCellBorderW;
    CGFloat likeY = iconY + 5;
    self.likeCountF = (CGRect){{likeX,likeY},likeSize};
    
    /* 点赞数图片 */
    UIImage *likeImg = [UIImage imageNamed:likeImgName];
    CGFloat likeImgY = iconY;
    CGFloat likeImgX = likeX - likeImg.size.width - SubMediaCellBorderW / 2;
    self.likeImgF = (CGRect){{likeImgX,likeImgY},likeImg.size};
    
    /** 回复用户昵称 */
    CGFloat nameX = CGRectGetMaxX(self.iconViewF) + SubMediaCellBorderW; //名字的X
    CGFloat nameY = iconY;
    CGFloat nameMaxW = likeImgX - nameX - SubMediaCellBorderW; //用户名最大宽度
    CGSize nameSize = [subMedia.userName singleLinesTextSizeWithFont:SubMediaCellNameFont maxW:nameMaxW];
    self.nameLabelF = (CGRect){{nameX, nameY}, nameSize};

    /* 时间 */
    CGFloat timeX = nameX;
    CGFloat timeY = CGRectGetMaxY(self.nameLabelF) + SubMediaCellBorderW;
    CGSize timeSize = [[subMedia.subTimeView creatMediaTime] sizeWithFont:SubMediaCellTimeFont];
    self.timeLabelF = (CGRect){{timeX,timeY},timeSize};
    
    /* 回复的内容 */
    CGFloat subMediaX = nameX;
    CGFloat subMediaY = CGRectGetMaxY(self.timeLabelF) + SubMediaCellBorderW;
    CGFloat subMediaMaxW = cellW - nameX - SubMediaCellBorderW;
    CGSize subMediaSize = [subMedia.content sizeWithFont:SubMediaCellContentFont maxW:subMediaMaxW];
    self.subMediaLabelF = (CGRect){{subMediaX,subMediaY},subMediaSize};
    
    /* 回复整体 */
    CGFloat subMediaViewX = 0;
    CGFloat subMediaViewY = SubMediaCellMargin;
    CGFloat subMediaViewW = cellW;
    CGFloat subMediaViewH = CGRectGetMaxY(self.subMediaLabelF) + SubMediaCellBorderW;
    self.subMediaViewF = CGRectMake(subMediaViewX, subMediaViewY, subMediaViewW, subMediaViewH);
    
    //cell高度
    self.cellHeight = CGRectGetMaxY(self.subMediaViewF) + SubMediaCellBorderW;
    
    //cellLine
    self.cellLineViewF = CGRectMake(nameX, self.cellHeight - 1, cellW - nameX, 1);
}

@end
