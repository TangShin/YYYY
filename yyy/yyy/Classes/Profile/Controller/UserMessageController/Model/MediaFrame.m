//
//  MediaFrame.m
//  yyy
//
//  Created by TangXing on 16/5/6.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import "MediaFrame.h"
#import "MediaModel.h"

@implementation MediaFrame

- (void)setMedia:(MediaModel *)media
{
    _media = media;
    
    // cell的宽度
    CGFloat cellW = [UIScreen mainScreen].bounds.size.width;
    
    /* 头像 */
    CGFloat iconWH = 35;
    CGFloat iconX = MediaCellBorderW;
    CGFloat iconY = MediaCellBorderW;
    self.iconViewF = CGRectMake(iconX, iconY, iconWH, iconWH);
    
    /* 点赞数 */
    CGSize likeSize = [media.supportCount sizeWithFont:MediaCellSupportFont];
    likeSize.width += 5;
    CGFloat likeX = cellW - likeSize.width - MediaCellBorderW;
    CGFloat likeY = iconY + 5;
    self.likeCountF = (CGRect){{likeX,likeY},likeSize};
    
    /* 点赞数图片 */
    UIImage *likeImg = [UIImage imageNamed:likeImgName];
    CGFloat likeImgY = iconY;
    CGFloat likeImgX = likeX - likeImg.size.width - MediaCellBorderW / 2;
    self.likeImgF = (CGRect){{likeImgX,likeImgY},likeImg.size};
    
    /* 子回复数 */
    CGFloat nameX = CGRectGetMaxX(self.iconViewF) + MediaCellBorderW; //名字的X
    CGFloat nameMaxW = likeImgX - nameX - MediaCellBorderW; //子回复为0，名字最大宽度
    
    if ([media.subMediaCount integerValue] > 0) {
        CGSize subMediaSize = [media.subMediaCount sizeWithFont:MediaCellSubMediaFont];
        subMediaSize.width += 5;
        CGFloat subMediaX = likeImgX - subMediaSize.width - MediaCellBorderW;
        CGFloat subMediaY = iconY + 5;
        self.subMediaCountF = (CGRect){{subMediaX,subMediaY},subMediaSize};
        
        /* 子回复数图片 */
        UIImage *subMediaImg = [UIImage imageNamed:subMediaImgName];
        CGFloat subMediaImgX = subMediaX - subMediaImg.size.width - MediaCellBorderW;
        CGFloat subMediaImgY = iconY;
        self.subMediaImgF = (CGRect){{subMediaImgX,subMediaImgY},subMediaImg.size};
        
        nameMaxW = subMediaImgX - nameX - MediaCellBorderW; //子回复不为0,名字最大宽度
    }
    
    /** 昵称 */
    CGFloat nameY = iconY;
    CGSize nameSize = [media.userName singleLinesTextSizeWithFont:MediaCellNameFont maxW:nameMaxW];
    self.nameLabelF = (CGRect){{nameX, nameY}, nameSize};
    
    /* 时间 */
    CGFloat timeX = nameX;
    CGFloat timeY = CGRectGetMaxY(self.nameLabelF) + MediaCellBorderW;
    CGSize timeSize = [[media.timeView creatMediaTime] sizeWithFont:MediaCellTimeFont];
    self.timeLabelF = (CGRect){{timeX,timeY},timeSize};
    
    /* 回复的内容 */
    CGFloat mediaX = nameX;
    CGFloat mediaY = CGRectGetMaxY(self.timeLabelF) + MediaCellBorderW;
    CGFloat mediaMaxW = cellW - nameX - MediaCellBorderW;
    CGSize mediaSize = [media.content sizeWithFont:MediaCellContentFont maxW:mediaMaxW];
    self.mediaLabelF = (CGRect){{mediaX,mediaY},mediaSize};
    
    /* 回复整体 */
    CGFloat mediaViewX = 0;
    CGFloat mediaViewY = MediaCellMargin;
    CGFloat mediaViewW = cellW;
    CGFloat mediaViewH = CGRectGetMaxY(self.mediaLabelF) + MediaCellBorderW;
    self.mediaViewF = CGRectMake(mediaViewX, mediaViewY, mediaViewW, mediaViewH);
    
    //cell高度
    self.cellHeight = CGRectGetMaxY(self.mediaViewF) + MediaCellBorderW;
    
    //cellLine
    self.cellLineViewF = CGRectMake(nameX, self.cellHeight - 1, cellW - nameX, 1);
}

@end
