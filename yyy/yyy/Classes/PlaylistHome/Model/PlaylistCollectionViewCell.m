//
//  PlaylistCollectionViewCell.m
//  yyy
//
//  Created by TangXing on 16/2/29.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import "PlaylistCollectionViewCell.h"

@implementation PlaylistCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        //初始化时加载xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"PlaylistCollectionViewCell" owner:self options:nil];
        
        //如果路径不存在,returen nil
        if (arrayOfViews.count < 1) {
            return nil;
        }
        
        //如果xib中view不属于UICollectionViewCell类,return nil
        if (![[arrayOfViews objectAtIndex:0] isKindOfClass:[UICollectionViewCell class]]) {
            return nil;
        }
        
        //加载xib
        self = [arrayOfViews objectAtIndex:0];
        
    }
    
    return self;
}

@end
