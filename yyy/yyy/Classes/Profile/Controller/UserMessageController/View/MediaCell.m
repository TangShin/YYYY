//
//  MediaCell.m
//  yyy
//
//  Created by TangXing on 16/5/9.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import "MediaCell.h"
#import "MediaFrame.h"
#import "MediaModel.h"

#import "YYYIconView.h"

@interface MediaCell ()

/** 用户Id */
@property (nonatomic, copy) NSString *userId;
/** 回复整体 */
@property (nonatomic, weak) UIView *mediaView;
/** 头像 */
@property (nonatomic, weak) YYYIconView *iconView;
/** 头像事件按钮 */
@property (nonatomic, weak) UIButton *iconBtn;
/** 用户名 */
@property (nonatomic, weak) UIButton *nameBtn;
/** 子回复图片 */
@property (nonatomic, weak) UIImageView *subMediaImgView;
/** 子回复数 */
@property (nonatomic, weak) UILabel *subMediaCountLabel;
/** 点赞按钮 */
@property (nonatomic, weak) UIButton *likeBtn;
/** 点赞数 */
@property (nonatomic, weak) UILabel *likeCountLabel;
/** 时间 */
@property (nonatomic, weak) UILabel *timeLabel;
/** 回复的内容 */
@property (nonatomic, weak) UILabel *mediaLabel;
/** cell分割线 */
@property (nonatomic, weak) UIView *cellLineView;

@end

@implementation MediaCell

- (NSString *)userId
{
    if (!_userId) {
        self.userId = self.mediaFrame.media.userId;
    }
    return _userId;
}

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"mediaCell";
    MediaCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[MediaCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
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
        [self setupMedia];
        
    }
    return self;
}

- (void)setupMedia
{
    /** 回复整体 */
    UIView *mediaView = [[UIView alloc] init];
    mediaView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:mediaView];
    self.mediaView = mediaView;
    
    /** 头像 */
    YYYIconView *iconView = [[YYYIconView alloc] init];
    [mediaView addSubview:iconView];
    self.iconView = iconView;
    
    /** 头像事件按钮 */
    UIButton *iconBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [mediaView addSubview:iconBtn];
    self.iconBtn = iconBtn;
    
    /** 用户名 */
    UIButton *nameBtn = [[UIButton alloc] init];
    nameBtn.titleLabel.font = MediaCellNameFont;
    nameBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    [mediaView addSubview:nameBtn];
    self.nameBtn = nameBtn;
    
    /** 子回复图片 */
    UIImageView *subMediaImgView = [[UIImageView alloc] init];
    subMediaImgView.image = [UIImage imageNamed:subMediaImgName];
    [mediaView addSubview:subMediaImgView];
    self.subMediaImgView = subMediaImgView;
    
    /** 子回复数 */
    UILabel *subMediaCountLabel = [[UILabel alloc] init];
    subMediaCountLabel.font = MediaCellSubMediaFont;
    subMediaCountLabel.textColor = YYYColor(200, 200, 200);
    [mediaView addSubview:subMediaCountLabel];
    self.subMediaCountLabel = subMediaCountLabel;
    
    /** 点赞按钮 */
    UIButton *likeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [mediaView addSubview:likeBtn];
    self.likeBtn = likeBtn;
    
    /** 点赞数 */
    UILabel *likeCountLabel = [[UILabel alloc] init];
    likeCountLabel.font = MediaCellSupportFont;
    likeCountLabel.textColor = YYYColor(200, 200, 200);
    [mediaView addSubview:likeCountLabel];
    self.likeCountLabel = likeCountLabel;
    
    /** 时间 */
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = MediaCellTimeFont;
    timeLabel.textColor = YYYColor(200, 200, 200);
    [mediaView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    /** 回复的内容 */
    UILabel *mediaLabel = [[UILabel alloc] init];
    mediaLabel.font = MediaCellContentFont;
    mediaLabel.numberOfLines = 0;
    [mediaView addSubview:mediaLabel];
    self.mediaLabel = mediaLabel;
    
    /** cell分割线 */
    UIView *cellLineView = [[UIView alloc] init];
    cellLineView.backgroundColor = YYYBackGroundColor;
    [self.contentView addSubview:cellLineView];
    self.cellLineView = cellLineView;
}

- (void)setMediaFrame:(MediaFrame *)mediaFrame
{
    _mediaFrame = mediaFrame;
    
    MediaModel *media = mediaFrame.media;
    
    /** 回复整体 */
    self.mediaView.frame = mediaFrame.mediaViewF;
    
    /** 头像 */
    self.iconView.frame = mediaFrame.iconViewF;
    self.iconView.iconUrl = media.userPhoto;
    /** 头像事件按钮 */
    self.iconBtn.frame = mediaFrame.iconViewF;
    self.iconBtn.backgroundColor = [UIColor clearColor];
    [self.iconBtn addTarget:self action:@selector(touchUserPhoto) forControlEvents:UIControlEventTouchUpInside];
    /** 变圆 */
    self.iconView.layer.masksToBounds = YES;
    self.iconView.layer.cornerRadius = self.iconView.size.width * 0.5;
    self.iconBtn.layer.masksToBounds = YES;
    self.iconBtn.layer.cornerRadius = self.iconBtn.size.width * 0.5;
    
    /** 用户名 */
    self.nameBtn.frame = mediaFrame.nameLabelF;
    self.nameBtn.highlighted = NO;
    self.nameBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.nameBtn.titleLabel.numberOfLines = 1;
    self.nameBtn.backgroundColor = [UIColor whiteColor];
    [self.nameBtn setTitle:media.userName forState:UIControlStateNormal];
    [self.nameBtn setTitleColor:YYYMainColor forState:UIControlStateNormal];
    [self.nameBtn addTarget:self action:@selector(touchUserName) forControlEvents:UIControlEventTouchUpInside];
    
    /** 点赞数 */
    self.likeCountLabel.frame = mediaFrame.likeCountF;
    self.likeCountLabel.text = media.supportCount;
    
    /** 点赞按钮 */
    self.likeBtn.frame = mediaFrame.likeImgF;
    self.likeBtn.highlighted = NO;
    [self.likeBtn setImage:[UIImage imageNamed:likeImgName] forState:UIControlStateNormal];
    [self.likeBtn addTarget:self action:@selector(addLike) forControlEvents:UIControlEventTouchUpInside];
    
    /** 子评论数 */
    self.subMediaCountLabel.frame = mediaFrame.subMediaCountF;
    self.subMediaCountLabel.text = media.subMediaCount;
    
    /** 子评论图片 */
    self.subMediaImgView.frame = mediaFrame.subMediaImgF;
    [self.subMediaImgView setImage:[UIImage imageNamed:subMediaImgName]];
    
    /** 时间 */
    NSString *time = [media.timeView creatMediaTime];
    CGSize timeSize = [time sizeWithFont:MediaCellTimeFont];
    CGFloat timeX = CGRectGetMaxX(mediaFrame.iconViewF) + MediaCellBorderW;;
    CGFloat timeY = CGRectGetMaxY(mediaFrame.nameLabelF) + MediaCellBorderW;
    self.timeLabel.frame = (CGRect){{timeX, timeY}, timeSize};
    self.timeLabel.text = time;
    
    /** 回复的内容 */
    self.mediaLabel.frame = mediaFrame.mediaLabelF;
    self.mediaLabel.text = media.content;
    
    /** cell分割线 */
    self.cellLineView.frame = mediaFrame.cellLineViewF;
}

#pragma mark - MediaDelegate
- (void)touchUserName
{
    if (_mediaDelegate) {
        [_mediaDelegate touchUserName:self.userId];
    }
}

- (void)addLike
{
    if (_mediaDelegate) {
        [_mediaDelegate addLike:self.userId];
    }
}

- (void)touchUserPhoto
{
    if (_mediaDelegate) {
        [_mediaDelegate touchUserPhotoWithUserId:self.userId];
    }
}
@end
