//
//  MVCollectionCell.h
//  yyy
//
//  Created by TangXing on 16/3/3.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MVCollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *mvImg;
@property (weak, nonatomic) IBOutlet UILabel *mvName;
@property (weak, nonatomic) IBOutlet UIImageView *sortImg;
@property (weak, nonatomic) IBOutlet UILabel *sortLabel;

@end
