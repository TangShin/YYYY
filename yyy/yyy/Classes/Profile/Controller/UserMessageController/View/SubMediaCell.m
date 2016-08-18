//
//  SubMediaCell.m
//  yyy
//
//  Created by TangXing on 16/5/11.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import "SubMediaCell.h"
#import "SubMediaFrame.h"
#import "SubMediaModel.h"

#import "YYYIconView.h"
#import "TTTAttributedLabel.h"
#import "YYYAttributeLabelView.h"

@interface SubMediaCell () <YYYAttributeLabelViewDelegate>

/** 用户Id */
@property (nonatomic, copy) NSString *userId;
/** 被回复用户Id */
@property (nonatomic, copy) NSString *reUserId;
/** 回复整体 */
@property (nonatomic, weak) UIView *subMediaView;
/** 头像 */
@property (nonatomic, weak) YYYIconView *iconView;
/** 头像事件按钮 */
@property (nonatomic, weak) UIButton *iconBtn;
/** 用户名 */
@property (nonatomic, weak) UIButton *nameBtn;
/** 点赞按钮 */
@property (nonatomic, weak) UIButton *likeBtn;
/** 点赞数 */
@property (nonatomic, weak) UILabel *likeCountLabel;
/** 时间 */
@property (nonatomic, weak) UILabel *timeLabel;
/** 子回复的内容 */
@property (nonatomic, weak) YYYAttributeLabelView  *subMediaLabel;
/** cell分割线 */
@property (nonatomic, weak) UIView *cellLineView;

@end

@implementation SubMediaCell

- (NSString *)userId
{
    if (!_userId) {
        self.userId = self.subMediaFrame.subMedia.userId;
    }
    return _userId;
}

- (NSString *)reUserId
{
    if (!_reUserId) {
        self.reUserId = self.subMediaFrame.subMedia.reUserId;
    }
    return _reUserId;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"subMediaCell";
    SubMediaCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[SubMediaCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
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
        [self setupSubMedia];
        
    }
    return self;
}

- (void)setupSubMedia
{
    /** 回复整体 */
    UIView *subMediaView = [[UIView alloc] init];
    subMediaView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:subMediaView];
    self.subMediaView = subMediaView;
    
    /** 头像 */
    YYYIconView *iconView = [[YYYIconView alloc] init];
    [subMediaView addSubview:iconView];
    self.iconView = iconView;
    
    /** 头像事件按钮 */
    UIButton *iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [subMediaView addSubview:iconBtn];
    self.iconBtn = iconBtn;
    
    /** 用户名 */
    UIButton *nameBtn = [[UIButton alloc] init];
    nameBtn.titleLabel.font = SubMediaCellNameFont;
    nameBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [subMediaView addSubview:nameBtn];
    self.nameBtn = nameBtn;
    
    /** 点赞按钮 */
    UIButton *likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [subMediaView addSubview:likeBtn];
    self.likeBtn = likeBtn;
    
    /** 点赞数 */
    UILabel *likeCountLabel = [[UILabel alloc] init];
    likeCountLabel.font = SubMediaCellSupportFont;
    likeCountLabel.textColor = YYYColor(200, 200, 200);
    [subMediaView addSubview:likeCountLabel];
    self.likeCountLabel = likeCountLabel;
    
    /** 时间 */
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = SubMediaCellTimeFont;
    timeLabel.textColor = YYYColor(200, 200, 200);
    [subMediaView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    /** 回复的内容 */
    YYYAttributeLabelView *subMediaLabel = [[YYYAttributeLabelView alloc] init];
    subMediaLabel.delegate = self;
    [subMediaView addSubview:subMediaLabel];
    self.subMediaLabel = subMediaLabel;
    
    /** cell分割线 */
    UIView *cellLineView = [[UIView alloc] init];
    cellLineView.backgroundColor = YYYBackGroundColor;
    [self.contentView addSubview:cellLineView];
    self.cellLineView = cellLineView;
}

- (void)setSubMediaFrame:(SubMediaFrame *)subMediaFrame
{
    _subMediaFrame = subMediaFrame;
    
    SubMediaModel *subMedia = subMediaFrame.subMedia;
    
    /** 回复整体 */
    self.subMediaView.frame = subMediaFrame.subMediaViewF;
    
    /** 头像 */
    self.iconView.frame = subMediaFrame.iconViewF;
    self.iconView.iconUrl = subMedia.userPhoto;
    /** 头像事件按钮 */
    self.iconBtn.frame = subMediaFrame.iconViewF;
    self.iconBtn.backgroundColor = [UIColor clearColor];
    [self.iconBtn addTarget:self action:@selector(touchUserPhoto) forControlEvents:UIControlEventTouchUpInside];
    /** 变圆 */
    self.iconView.layer.masksToBounds = YES;
    self.iconView.layer.cornerRadius = self.iconView.size.width * 0.5;
    self.iconBtn.layer.masksToBounds = YES;
    self.iconBtn.layer.cornerRadius = self.iconBtn.size.width * 0.5;
    
    /** 回复用户名 */
    self.nameBtn.frame = subMediaFrame.nameLabelF;
    self.nameBtn.highlighted = NO;
    self.nameBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.nameBtn.backgroundColor = [UIColor whiteColor];
    [self.nameBtn setTitle:subMedia.userName forState:UIControlStateNormal];
    [self.nameBtn setTitleColor:YYYMainColor forState:UIControlStateNormal];
    [self.nameBtn addTarget:self action:@selector(touchUserName) forControlEvents:UIControlEventTouchUpInside];
    
    /** 点赞数 */
    self.likeCountLabel.frame = subMediaFrame.likeCountF;
    self.likeCountLabel.text = subMedia.supportCount;
    
    /** 点赞按钮 */
    self.likeBtn.frame = subMediaFrame.likeImgF;
    self.likeBtn.highlighted = NO;
    [self.likeBtn setImage:[UIImage imageNamed:likeImgName] forState:UIControlStateNormal];
    [self.likeBtn addTarget:self action:@selector(addLike) forControlEvents:UIControlEventTouchUpInside];
    
    /** 时间 */
    NSString *time = [subMedia.subTimeView creatMediaTime];
    CGSize timeSize = [time sizeWithFont:SubMediaCellTimeFont];
    CGFloat timeX = CGRectGetMaxX(subMediaFrame.iconViewF) + SubMediaCellBorderW;;
    CGFloat timeY = CGRectGetMaxY(subMediaFrame.nameLabelF) + SubMediaCellBorderW;
    self.timeLabel.frame = (CGRect){{timeX, timeY}, timeSize};
    self.timeLabel.text = time;
    
    /** 回复的内容 */
    self.subMediaLabel.frame = subMediaFrame.subMediaLabelF;
    [self.subMediaLabel setup];
    self.subMediaLabel.linkColor = YYYMainColor;
    self.subMediaLabel.activeLinkColor = YYYMainColor;
    
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    style.lineSpacing              = 2.f;//行间距
//    style.paragraphSpacing         = style.lineSpacing * 4;//段落间距
    style.alignment                = NSTextAlignmentCenter;
    
    NSAttributedString *attributedString  = \
    [subMedia.content createAttributedStringAndConfig:@[[ConfigAttributedString foregroundColor:[UIColor blackColor] range:subMedia.content.range],
                                              [ConfigAttributedString paragraphStyle:style range:subMedia.content.range],
                                              [ConfigAttributedString font:SubMediaCellNameFont range:subMedia.content.range]]];
    self.subMediaLabel.attributedString   = attributedString;
    
    // 添加超链接
    if (subMedia.reUserName != nil) {
        NSRange reUserNameRang = [subMedia.content rangeOfString:subMedia.reUserName];
        [self.subMediaLabel addLinkStringRange:reUserNameRang flag:subMedia.reUserId];
    }
    
    // 进行渲染
    [self.subMediaLabel render];
    [self.subMediaLabel resetSize];
    
    /** cell分割线 */
    self.cellLineView.frame = subMediaFrame.cellLineViewF;
}

- (void)YYYAttributeLabelView:(YYYAttributeLabelView *)attributeLabelView linkFlag:(NSString *)flag
{
    NSLog(@"%@", flag);
}

#pragma mark - SubMediaDelegate
- (void)touchUserName
{
    if (_subMediaDelegate) {
        [_subMediaDelegate touchUserName:self.userId];
    }
}

- (void)touchReUserName
{
    if (_subMediaDelegate) {
        [_subMediaDelegate touchReUserName:self.reUserId];
    }
}

- (void)addLike
{
    if (_subMediaDelegate) {
        [_subMediaDelegate addLike:self.userId];
    }
}

- (void)touchUserPhoto
{
    if (_subMediaDelegate) {
        [_subMediaDelegate touchUserPhotoWithUserId:self.userId];
    }
}

@end
