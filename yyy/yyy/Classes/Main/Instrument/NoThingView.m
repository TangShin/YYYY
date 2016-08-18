//
//  NoThingView.m
//  yyy
//
//  Created by TangXing on 16/5/6.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import "NoThingView.h"

#define SelfViewBoard 10
#define TipsTextFont [UIFont systemFontOfSize:14.0]

@implementation NoThingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)layoutSubviews
{
    
    CGFloat tipsTextH = 0;
    CGSize tipsTextSize = CGSizeZero;
    
    if (self.tipsText != nil) {
        CGFloat maxW = kScreenWidth - 2 * SelfViewBoard;
        tipsTextSize = [self.tipsText sizeWithFont:TipsTextFont maxW:maxW];
        tipsTextH = tipsTextSize.height;
    }
    
    if (self.tipsImgName != nil) {
        
        UIImageView *imgView = [[UIImageView alloc] init];
        UIImage *img = [UIImage imageNamed:self.tipsImgName];
        
        CGFloat imgViewX = (kScreenWidth - img.size.width)/2;
        CGFloat imgViewY = (kScreenHeight - NaviBarHeight - img.size.height - tipsTextH - SelfViewBoard) / 2;
        CGSize imgViewSize = img.size;
        imgView.frame = (CGRect){{imgViewX,imgViewY},imgViewSize};
        imgView.image = img;
        
        [self addSubview:imgView];
        
        UILabel *tipsTextLabel = [[UILabel alloc] init];
        
        CGFloat tipsTextLabelX = (kScreenWidth - tipsTextSize.width - 2 * SelfViewBoard) / 2;
        CGFloat tipsTextLaeblY = CGRectGetMaxY(imgView.frame) + SelfViewBoard;
        
        tipsTextLabel.text = self.tipsText;
        tipsTextLabel.textAlignment = NSTextAlignmentCenter;
        tipsTextLabel.numberOfLines = 0;
        tipsTextLabel.textColor = YYYMainColor;
        tipsTextLabel.font = TipsTextFont;
        tipsTextLabel.frame = (CGRect){{tipsTextLabelX,tipsTextLaeblY},tipsTextSize};
        
        [self addSubview:tipsTextLabel];
        
    }
}

@end
