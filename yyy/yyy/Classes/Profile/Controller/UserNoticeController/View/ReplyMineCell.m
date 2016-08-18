//
//  ReplyMineCell.m
//  yyy
//
//  Created by TangXing on 16/5/4.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import "ReplyMineCell.h"
#import "ReplyMineFrame.h"
#import "ReplyMineModel.h"

#import "YYYIconView.h"

@interface ReplyMineCell ()

/** 回复整体 */
@property (nonatomic, weak) UIView *replyView;
/** 头像 */
@property (nonatomic, weak) YYYIconView *iconView;
/** 头像点击按钮 */
@property (nonatomic, weak) UIButton *iconBtn;
/** 用户名 */
@property (nonatomic, weak) UIButton *nameBtn;
/** 时间 */
@property (nonatomic, weak) UILabel *timeLabel;
/** 回复的内容 */
@property (nonatomic, weak) UILabel *replyContentLabel;
/** 被回复的整体 */
@property (nonatomic, weak) UIView *repliedView;
/** 被回复的媒体信息 */
@property (nonatomic, weak) UILabel *repliedMediaInfoLabel;
/** cell分割线 */
@property (nonatomic, weak) UIView *cellLineView;

@end

@implementation ReplyMineCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"replyMineCell";
    ReplyMineCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[ReplyMineCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
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
        [self setupReplyMine];
        
    }
    return self;
}

- (void)setupReplyMine
{
    /** 回复整体 */
    UIView *replyView = [[UIView alloc] init];
    replyView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:replyView];
    self.replyView = replyView;
    
    /** 头像 */
    YYYIconView *iconView = [[YYYIconView alloc] init];
    [replyView addSubview:iconView];
    self.iconView = iconView;
    
    /** 头像事件按钮 */
    UIButton *iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:iconBtn];
    self.iconBtn = iconBtn;
    
    /** 用户名 */
    UIButton *nameBtn = [[UIButton alloc] init];
    nameBtn.titleLabel.font = ReplyMineCellNameFont;
    nameBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [replyView addSubview:nameBtn];
    self.nameBtn = nameBtn;
    
    /** 时间 */
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = ReplyMineCellTimeFont;
    timeLabel.textColor = YYYColor(200, 200, 200);
    [replyView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    /** 回复的内容 */
    UILabel *replyContentLabel = [[UILabel alloc] init];
    replyContentLabel.font = ReplyMineCellContentFont;
    replyContentLabel.numberOfLines = 0;
    [replyView addSubview:replyContentLabel];
    self.replyContentLabel = replyContentLabel;
    
    /** 被回复整体 */
    UIView *repliedView = [[UIView alloc] init];
    repliedView.backgroundColor = YYYColor(230, 230, 230);
    [self.contentView addSubview:repliedView];
    self.repliedView = repliedView;
    
    /** 被回复的媒体信息 */
    UILabel *repliedMediaInfoLabel = [[UILabel alloc] init];
    repliedMediaInfoLabel.font = ReplyMineCellMediaInfoFont;
    repliedMediaInfoLabel.textColor = YYYColor(150, 150, 150);
    repliedMediaInfoLabel.numberOfLines = 0;
    [repliedView addSubview:repliedMediaInfoLabel];
    self.repliedMediaInfoLabel = repliedMediaInfoLabel;
    
    /** cell分割线 */
    UIView *cellLineView = [[UIView alloc] init];
    cellLineView.backgroundColor = YYYBackGroundColor;
    [self.contentView addSubview:cellLineView];
    self.cellLineView = cellLineView;
}

- (void)setReplyMineFrame:(ReplyMineFrame *)replyMineFrame
{
    _replyMineFrame = replyMineFrame;
    
    ReplyMineModel *replyMine = replyMineFrame.replyMine;

    /** 回复整体 */
    self.replyView.frame = replyMineFrame.replyViewF;
    
    /** 头像 */
    self.iconView.frame = replyMineFrame.iconViewF;
    self.iconView.iconUrl = replyMine.userPhoto;
    /** 头像事件按钮 */
    self.iconBtn.frame = replyMineFrame.iconViewF;
    self.iconBtn.backgroundColor = [UIColor clearColor];
    [self.iconBtn addTarget:self action:@selector(touchUserPhoto) forControlEvents:UIControlEventTouchUpInside];
    /** 变圆 */
    self.iconView.layer.masksToBounds = YES;
    self.iconView.layer.cornerRadius = self.iconView.size.width * 0.5;
    /** 变圆 */
    self.iconBtn.layer.masksToBounds = YES;
    self.iconBtn.layer.cornerRadius = self.iconBtn.size.width * 0.5;
    
    /** 姓名 */
    self.nameBtn.frame = replyMineFrame.nameLabelF;
    self.nameBtn.highlighted = NO;
    self.nameBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.nameBtn.titleLabel.numberOfLines = 1;
    self.nameBtn.backgroundColor = [UIColor whiteColor];
    [self.nameBtn setTitle:replyMine.userName forState:UIControlStateNormal];
    [self.nameBtn setTitleColor:YYYMainColor forState:UIControlStateNormal];
    [self.nameBtn addTarget:self action:@selector(touchUserName) forControlEvents:UIControlEventTouchUpInside];
    
    /** 时间 */
    NSString *time = replyMine.replyTime;
    CGSize timeSize = [time sizeWithFont:ReplyMineCellTimeFont];
    CGFloat timeX = kScreenWidth - timeSize.width - ReplyMineCellBorderW;
    CGFloat timeY = ReplyMineCellBorderW;
    self.timeLabel.frame = (CGRect){{timeX, timeY}, timeSize};
    self.timeLabel.text = time;
    
    /** 回复的内容 */
    self.replyContentLabel.frame = replyMineFrame.replyContentLabelF;
    self.replyContentLabel.text = replyMine.replyContent;
    
    
    /** 被回复整体 */
    self.repliedView.frame = replyMineFrame.repliedViewF;
    self.repliedView.layer.masksToBounds = YES;
    self.repliedView.layer.cornerRadius = 5;
    
    /** 被回复的媒体信息 */
    self.repliedMediaInfoLabel.frame = replyMineFrame.replyMediaInfoLabelF;
    NSString *replyMediaInfoText = [NSString stringWithFormat:@"我的评论: %@",replyMine.replyMediaInfo];
    self.repliedMediaInfoLabel.text = replyMediaInfoText;
    
    /** cell分割线 */
    self.cellLineView.frame = replyMineFrame.cellLineViewF;
}

#pragma mark - ReplyMineDelegate
- (void)touchUserPhoto
{
    TSLog(@"replyMine");
}

- (void)touchUserName
{
    TSLog(@"replyMine2");
}

@end
