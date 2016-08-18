//
//  ReusableView.m
//  yyy
//
//  Created by TangXing on 15/11/19.
//  Copyright © 2015年 yiyinyue. All rights reserved.
//

#import "ReusableView.h"

@implementation ReusableView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        CGFloat selfWidth = self.bounds.size.width;

        UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 40, 40)];
        image.image = [UIImage imageNamed:@"recommend.png"];
        [self addSubview:image];

        UIButton *moreClick = [UIButton buttonWithType:UIButtonTypeCustom];
        moreClick.frame = CGRectMake(selfWidth - 50, 10, 40, 40);
        [moreClick setTitle:@"更多>" forState:UIControlStateNormal];
        [moreClick setTitleColor:YYYColor(51, 204, 255) forState:UIControlStateNormal];
        [moreClick.titleLabel setFont:[UIFont systemFontOfSize:14.0]];
        [moreClick addTarget:self action:@selector(moreClick:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:moreClick];
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(60, 10, selfWidth - 130, 40)];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont systemFontOfSize:18];
        [self addSubview:label];
    }
    return self;
}

-(void)setText:(NSString *)text
{
    _text = text;
    
    ((UILabel *)self.subviews[2]).text = text;
}

- (void)moreClick:(UIButton *)sender
{
    TSLog(@"没有更多推荐了🐷");
}

@end
