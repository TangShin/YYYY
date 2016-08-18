//
//  SearchReusableView.m
//  yyy
//
//  Created by TangXing on 16/3/10.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import "SearchReusableView.h"

@implementation SearchReusableView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat selfWidth = self.bounds.size.width;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 80, 20)];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:17.0];
        [self addSubview:label];
        
        _clickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _clickBtn.frame = CGRectMake(selfWidth - 80, 0, 70, 20);
        _clickBtn.titleLabel.font = [UIFont systemFontOfSize:16.0];
        [_clickBtn setTitle:@"清空历史" forState:UIControlStateNormal];
        [_clickBtn setTitleColor:YYYMainColor forState:UIControlStateNormal];
        
        [self addSubview:_clickBtn];
        
        UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 23, kScreenWidth, 4)];
        line.backgroundColor = YYYMainColor;
        [self addSubview:line];
    }
    
    return self;
}

- (void)setText:(NSString *)text
{
    _text = text;
    ((UILabel *)self.subviews[0]).text = text;
}

@end
