//
//  PlaylistCollectionCell.h
//  yyy
//
//  Created by TangXing on 15/11/19.
//  Copyright © 2015年 yiyinyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicalCollectionCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UIImageView *image;

@property (strong, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *fansCount;

@end
