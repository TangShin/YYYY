//
//  PlaylistCollectionCell.m
//  yyy
//
//  Created by TangXing on 15/11/23.
//  Copyright © 2015年 yiyinyue. All rights reserved.
//

#import "PlaylistCollectionCell.h"

@implementation PlaylistCollectionCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        //初始化时加载xib文件
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"PlaylistCollectionCell" owner:self options:nil];
        
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
