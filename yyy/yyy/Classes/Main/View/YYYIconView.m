//
//  YYYIconView.m
//  yyy
//
//  Created by TangXing on 16/4/14.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import "YYYIconView.h"
#import "UIImageView+WebCache.h"

@interface YYYIconView ()

@property (nonatomic, weak) UIImageView *verifiedView;

@end

@implementation YYYIconView

- (UIImageView *)verifiedView
{
    if (!_verifiedView) {
        UIImageView *verifiedView = [[UIImageView alloc] init];
        [self addSubview:verifiedView];
        self.verifiedView = verifiedView;
    }
    return _verifiedView;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void)setIconUrl:(NSString *)iconUrl
{
    _iconUrl = iconUrl;
    
    // 1.下载图片
    [self sd_setImageWithURL:[NSURL URLWithString:iconUrl] placeholderImage:[UIImage imageNamed:@"userIcon"]];
}

- (void)setLocalImgName:(NSString *)localImgName
{
    _localImgName = localImgName;
    
    self.image = [UIImage imageNamed:localImgName];
}

- (void)setIconImage:(UIImage *)iconImage
{
    _iconImage = iconImage;
    
    self.image = iconImage;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.verifiedView.size = self.verifiedView.image.size;
    CGFloat scale = 0.6;
    self.verifiedView.x = self.width - self.verifiedView.width * scale;
    self.verifiedView.y = self.height - self.verifiedView.height * scale;
}

@end
