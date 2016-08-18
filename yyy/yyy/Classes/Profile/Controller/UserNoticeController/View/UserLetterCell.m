//
//  UserLetterCell.m
//  yyy
//
//  Created by TangXing on 16/4/18.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import "UserLetterCell.h"
#import "UserLetterModel.h"
#import "UserLetterFrame.h"
#import "YYYIconView.h"

#import "UserInfoTool.h"

@interface UserLetterCell ()

/** 时间 */
@property (nonatomic, weak) UILabel *timeLabel;
/** 头像 */
@property (nonatomic, weak) YYYIconView *iconView;
/** 头像点击按钮 */
@property (nonatomic, weak) UIButton *iconBtn;
/** 私信 */
@property (nonatomic, weak) UILabel *contentLabel;

@end

@implementation UserLetterCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"userLetterCell";
    UserLetterCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UserLetterCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    return cell;
}

/**
 *  cell的初始化方法，一个cell只会调用一次
 *  一般在这里添加所有可能显示的子控件，以及子控件的一次性设置
 */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        self.contentView.backgroundColor = [UIColor clearColor];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 初始化用户私信
        [self setupUserLetter];
        
    }
    return self;
}

-(void)setupUserLetter
{
    UserLetterModel *userLetter = _userLetterFrame.userLetter;
    /** 时间 */
    if (!userLetter.timehidden) {
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.font = UserLetterCellTimeFont;
        [self.contentView addSubview:timeLabel];
        self.timeLabel = timeLabel;
    }
    
    /** 头像 */
    YYYIconView *iconView = [[YYYIconView alloc] init];
    [self.contentView addSubview:iconView];
    self.iconView = iconView;
    
    /** 头像事件按钮 */
    UIButton *iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:iconBtn];
    self.iconBtn = iconBtn;
    
    /** 消息预览 */
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.font = UserLetterCellContentFont;
    [self.contentView addSubview:contentLabel];
    self.contentLabel = contentLabel;
}

- (void)setUserLetterFrame:(UserLetterFrame *)userLetterFrame
{
    _userLetterFrame = userLetterFrame;
    
    UserLetterModel *userLetter = userLetterFrame.userLetter;
    
    UserInfo *userInfo = [UserInfoTool userInfo];
    
    /** 时间 */
    self.timeLabel.text = [userLetter.sendTime creatLetterTime];
    self.timeLabel.frame = userLetterFrame.timeLabelF;
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.textColor = YYYColor(200, 200, 200);
    
    /** 头像 */
    self.iconView.frame = userLetterFrame.iconViewF;
    if ([userInfo.userId isEqualToString:userLetter.userId]) {
        self.iconView.iconImage = userInfo.userPhoto;
    } else {
        self.iconView.iconUrl = userLetter.otherSideUserPhoto;
    }
    /** 头像事件按钮 */
    self.iconBtn.frame = userLetterFrame.iconViewF;
    self.iconBtn.backgroundColor = [UIColor clearColor];
    [self.iconBtn addTarget:self action:@selector(touchUserPhoto) forControlEvents:UIControlEventTouchUpInside];
    /** 变圆 */
    self.iconView.layer.masksToBounds = YES;
    self.iconView.layer.cornerRadius = self.iconView.size.width * 0.5;
    /** 变圆 */
    self.iconBtn.layer.masksToBounds = YES;
    self.iconBtn.layer.cornerRadius = self.iconBtn.size.width * 0.5;
    
    /** 私信 */
    self.contentLabel.frame = userLetterFrame.contentLabelF;
    self.contentLabel.text = userLetter.content;
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.textAlignment = NSTextAlignmentCenter;
    self.contentLabel.textColor = [UIColor whiteColor];
    self.contentLabel.layer.masksToBounds = YES;
    self.contentLabel.layer.cornerRadius = 5;
    self.contentLabel.backgroundColor = YYYMainColor;
}

#pragma mark - UserLetterDelegate
- (void)touchUserPhoto
{
    TSLog(@"UserLetter");
}

@end
