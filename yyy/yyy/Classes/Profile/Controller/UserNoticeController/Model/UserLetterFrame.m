//
//  UserLetterFrame.m
//  yyy
//
//  Created by TangXing on 16/4/18.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import "UserLetterFrame.h"
#import "UserLetterModel.h"
#import "UserInfoTool.h"

@implementation UserLetterFrame

- (void)setUserLetter:(UserLetterModel *)userLetter
{
    _userLetter = userLetter;
    
    UserInfo *loginUser = [UserInfoTool userInfo];
    
    BOOL timehidden = userLetter.timehidden;
    
    //  cell的宽度
    CGFloat cellW = [UIScreen mainScreen].bounds.size.width;
    
    /** 时间 */
    if (!timehidden) {
        CGSize timeSize = [[userLetter.sendTime creatLetterTime] sizeWithFont:UserLetterCellTimeFont];
        CGFloat timeX = (cellW - timeSize.width) / 2;
        CGFloat timeY = UserLetterCellBorderW;
        self.timeLabelF = (CGRect){{timeX,timeY},timeSize};
    }
    
    /** 头像 */
    CGFloat iconWH = 40;
    CGFloat iconX = UserLetterCellBorderW;
    CGFloat iconY = CGRectGetMaxY(self.timeLabelF) + UserLetterCellBorderW;
    CGFloat loginUserIconX = cellW - UserLetterCellBorderW - iconWH;
    
    /** 计算时间没有隐藏时的frame */
    if ([loginUser.userId isEqualToString:userLetter.userId]) {
        //计算登录用户发送的私信frame
        self.iconViewF = CGRectMake(loginUserIconX, iconY, iconWH, iconWH);
    } else {
        //计算私信对象发送的私信frame
        self.iconViewF = CGRectMake(iconX, iconY, iconWH, iconWH);
    }
    
    /** 私信 */
    CGFloat contentMaxW = cellW - iconWH - UserLetterCellBorderW * 5;
    CGSize contentSize = [userLetter.content sizeWithFont:UserLetterCellContentFont maxW:contentMaxW];
    if (contentSize.height < iconWH) {
        contentSize.height = iconWH;
    }
    contentSize.width += 10;
    contentSize.height += 10;
    CGFloat contentX = CGRectGetMaxX(self.iconViewF) + UserLetterCellBorderW;
    CGFloat contentY = iconY;
    CGFloat loginUserContentX = loginUserIconX - contentSize.width - UserLetterCellBorderW;
    
    /** 计算时间没有隐藏时的frame */
    if ([loginUser.userId isEqualToString:userLetter.userId]) {
        //计算登录用户发送的私信frame
        self.contentLabelF = (CGRect){{loginUserContentX,contentY},contentSize};
    } else {
        //计算私信对象发送的私信frame
        self.contentLabelF = (CGRect){{contentX,contentY},contentSize};
    }
    
    /** 返回时间没有隐藏时的cell高度 */
    self.cellHeight = CGRectGetMaxY(self.contentLabelF) + UserLetterCellBorderW;
}

@end
