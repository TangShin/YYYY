//
//  SystemNoticeCell.m
//  yyy
//
//  Created by TangXing on 16/4/14.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import "SystemNoticeCell.h"
#import "YYYIconView.h"

@interface SystemNoticeCell ()

/** 头像 */
@property (nonatomic, weak) YYYIconView *iconView;
/** 类别 */
@property (nonatomic, weak) UILabel *classLabel;
/** 未读消息计数视图 */
@property (nonatomic, weak) UIButton *unreadCountView;
/** cell分割线 */
@property (nonatomic, weak) UIView *cellLineView;

@end

@implementation SystemNoticeCell

+ (instancetype)cellWithTableView:(UITableView *)tableView withSystemName:(NSString *)systemName
{
    static NSString *ID = @"systemNoticeCell";
    SystemNoticeCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[SystemNoticeCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID withSystemName:systemName];
    }
    return cell;
}

/**
 *  cell的初始化方法，一个cell只会调用一次
 *  一般在这里添加所有可能显示的子控件，以及子控件的一次性设置
 */
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withSystemName:(NSString *)systemName
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        // 点击cell的时候不要变色
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //右边显示小箭头
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        // 初始化用户消息
        [self setupSystemNoticeWithSystemName:systemName];
        
    }
    return self;
}

- (void)setupSystemNoticeWithSystemName:(NSString *)systemName
{
    // cell的宽度
    CGFloat cellW = [UIScreen mainScreen].bounds.size.width;
    
    /** 头像 */
    YYYIconView *iconView = [[YYYIconView alloc] init];
    iconView.localImgName = @"userIcon";
    [self.contentView addSubview:iconView];
    self.iconView = iconView;
    
    /** 头像frame */
    CGFloat iconWH = 50;
    CGFloat iconX = 10;
    CGFloat iconY = 10;
    self.iconView.frame = CGRectMake(iconX, iconY, iconWH, iconWH);
    
    /** 变圆 */
    self.iconView.layer.masksToBounds = YES;
    self.iconView.layer.cornerRadius = self.iconView.size.width * 0.5;
    
    /** 昵称 */
    UILabel *classLabel = [[UILabel alloc] init];
    classLabel.font = [UIFont systemFontOfSize:15];
    classLabel.text = systemName;
    [self.contentView addSubview:classLabel];
    self.classLabel = classLabel;
    
    /** 昵称frame */
    CGFloat nameX = CGRectGetMaxX(self.iconView.frame) + 10;
    CGFloat nameMaxW = cellW - nameX;
    CGSize nameSize = [systemName sizeWithFont:[UIFont systemFontOfSize:15] maxW:nameMaxW];
    //为保证label在正中间，最后算y轴
    CGFloat nameY = (70 - nameSize.height)/2;
    self.classLabel.frame = (CGRect){{nameX, nameY}, nameSize};
    
    /** 未读消息计数视图 */
    UIButton *unreadCountView = [[UIButton alloc] init];
    unreadCountView.backgroundColor = [UIColor redColor];
    unreadCountView.enabled = NO;
    unreadCountView.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:unreadCountView];
    self.unreadCountView = unreadCountView;
    
    /** cell分割线 */ /* 70 = 10 + iconWH + 10 */
    UIView *cellLineView = [[UIView alloc] initWithFrame:CGRectMake(nameX, 70 - 1, cellW - nameX, 1)];
    cellLineView.backgroundColor = YYYBackGroundColor;
    [self.contentView addSubview:cellLineView];
    self.cellLineView = cellLineView;
}

- (void)setTotalStr:(NSString *)totalStr
{
    /** 未读数为0不显示 */
    if ([totalStr integerValue] == 0) {
        self.unreadCountView.hidden = YES;
        return;
    } else {
        self.unreadCountView.hidden = NO;
    }
    
    /** 未读消息计数 */ //(60 = 自身宽20 ＋ 间距 10 ＊ 2 ＋ accessoryTypeView的宽20)
    CGSize unreadCountSize = [totalStr sizeWithFont:[UIFont systemFontOfSize:12]];
    if (unreadCountSize.width < 20) {
        unreadCountSize.width = 20;
    } else {
        unreadCountSize.width += 5;
    }
    unreadCountSize.height = 20;
    
    self.unreadCountView.frame = (CGRect){{kScreenWidth - 60, CGRectGetMinY(self.classLabel.frame)},unreadCountSize};
    [self.unreadCountView setTitle:totalStr forState:UIControlStateNormal];
    [self.unreadCountView setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    /** 变圆 */
    self.unreadCountView.layer.masksToBounds = YES;
    self.unreadCountView.layer.cornerRadius = 20 * 0.5;
}

@end
