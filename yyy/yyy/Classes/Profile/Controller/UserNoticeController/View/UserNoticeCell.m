//
//  UserNoticeCell.m
//  yyy
//
//  Created by TangXing on 16/4/14.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import "UserNoticeCell.h"
#import "UserNoticeModel.h"
#import "UserNoticeFrame.h"
#import "YYYIconView.h"

@interface UserNoticeCell ()

/** 头像 */
@property (nonatomic, weak) YYYIconView *iconView;
/** 昵称 */
@property (nonatomic, weak) UILabel *nameLabel;
/** 时间 */
@property (nonatomic, weak) UILabel *timeLabel;
/** 消息预览 */
@property (nonatomic, weak) UILabel *previewMsgLabel;
/** 未读消息计数视图 */
@property (nonatomic, weak) UIButton *unreadCountView;
/** cell分割线 */
@property (nonatomic, weak) UIView *cellLineView;

@end

@implementation UserNoticeCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"userNoticeCell";
    UserNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UserNoticeCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
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
        
        self.backgroundColor = [UIColor whiteColor];
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        // 初始化用户消息
        [self setupUserNotice];
        
    }
    return self;
}

- (void)setupUserNotice
{
    /** 头像 */
    YYYIconView *iconView = [[YYYIconView alloc] init];
    [self.contentView addSubview:iconView];
    self.iconView = iconView;
    
    /** 昵称 */
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.font = UserNoticeCellNameFont;
    nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    /** 时间 */
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = UserNoticeCellTimeFont;
    [self.contentView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    /** 消息预览 */
    UILabel *previewMsgLabel = [[UILabel alloc] init];
    previewMsgLabel.font = UserNoticeCellPreviewMsgFont;
    [self.contentView addSubview:previewMsgLabel];
    self.previewMsgLabel = previewMsgLabel;
    
    /** 未读消息计数 */
    UIButton *unreadCountView = [[UIButton alloc] init];
    unreadCountView.backgroundColor = [UIColor redColor];
    unreadCountView.titleLabel.font = UserNoticeCellUnreadCountFont;
    unreadCountView.enabled = NO;
    [self.contentView addSubview:unreadCountView];
    self.unreadCountView = unreadCountView;
    
    /** cell分割线 */
    UIView *cellLineView = [[UIView alloc] init];
    cellLineView.backgroundColor = YYYBackGroundColor;
    [self.contentView addSubview:cellLineView];
    self.cellLineView = cellLineView;
}

- (void)setUserNoticeFrame:(UserNoticeFrame *)userNoticeFrame
{
    _userNoticeFrame = userNoticeFrame;
    
    UserNoticeModel *userNotice = userNoticeFrame.userNotice;
    
    /** 头像 */
    self.iconView.frame = userNoticeFrame.iconViewF;
    self.iconView.iconUrl = userNotice.userPhoto;
    /** 变圆 */
    self.iconView.layer.masksToBounds = YES;
    self.iconView.layer.cornerRadius = self.iconView.size.width * 0.5;
    
    /** 昵称 */
    self.nameLabel.text = userNotice.userName;
    self.nameLabel.frame = userNoticeFrame.nameLabelF;
    
    /** 时间 */
    self.timeLabel.text = userNotice.lastestMessageDate;
    self.timeLabel.frame = userNoticeFrame.timeLabelF;
    self.timeLabel.textColor = YYYColor(150, 150, 150);
    
    /** 消息预览 */
    self.previewMsgLabel.text = userNotice.previewMessage;
    self.previewMsgLabel.frame = userNoticeFrame.previewMsgLabelF;
    self.previewMsgLabel.textColor = YYYColor(150, 150, 150);
    
    /** 未读消息计数视图 */
    self.unreadCountView.frame = userNoticeFrame.unreadCountViewF;
    [self.unreadCountView setTitle:userNotice.unreadMessageCount forState:UIControlStateNormal];
    [self.unreadCountView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    /** 变圆 */
    self.unreadCountView.layer.masksToBounds = YES;
    self.unreadCountView.layer.cornerRadius = 20 * 0.5;
    /** 未读数为0不显示 */
    if ([userNotice.unreadMessageCount intValue] == 0) {
        self.unreadCountView.hidden = YES;
    } else {
        self.unreadCountView.hidden = NO;
    }
    
    /** cell分割线 */
    self.cellLineView.frame = userNoticeFrame.cellLineViewF;
}

@end
