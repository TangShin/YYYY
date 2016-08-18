//
//  SystemLetterCell.m
//  yyy
//
//  Created by TangXing on 16/5/3.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import "SystemLetterCell.h"
#import "SystemNoticeModel.h"
#import "SystemNoticeFrame.h"

@interface SystemLetterCell ()

/** 时间 */
@property (nonatomic, weak) UILabel *timeLabel;
/** 内容 */
@property (nonatomic, weak) UILabel *contentLabel;

@end

@implementation SystemLetterCell

+(instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *ID = @"systemLetterCell";
    SystemLetterCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[SystemLetterCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
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
        [self setupSystemLetter];
        
    }
    return self;
}

- (void)setupSystemLetter
{
    /** 时间 */
    UILabel *timeLabel = [[UILabel alloc] init];
    timeLabel.font = SystemNoticeCellTimeFont;
    [self.contentView addSubview:timeLabel];
    self.timeLabel = timeLabel;
    
    /** 内容 */
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.font = SystemNoticeCellContentFont;
    [self.contentView addSubview:contentLabel];
    self.contentLabel = contentLabel;
}

- (void)setSystemNoticeFrame:(SystemNoticeFrame *)systemNoticeFrame
{
    _systemNoticeFrame = systemNoticeFrame;
    
    SystemNoticeModel *systemNotice = systemNoticeFrame.systemNotice;
    
    /** 时间 */
    self.timeLabel.text = systemNotice.sendTime;
    self.timeLabel.frame = systemNoticeFrame.timeLabelF;
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.timeLabel.textColor = YYYColor(200, 200, 200);
    
    /** 内容 */
    self.contentLabel.frame = systemNoticeFrame.contentLabelF;
    self.contentLabel.text = systemNotice.content;
    self.contentLabel.numberOfLines = 0;
    self.contentLabel.textAlignment = NSTextAlignmentLeft;
    self.contentLabel.textColor = [UIColor blackColor];
    self.contentLabel.layer.masksToBounds = YES;
    self.contentLabel.layer.cornerRadius = 5;
    self.contentLabel.backgroundColor = [UIColor clearColor];
}

@end
