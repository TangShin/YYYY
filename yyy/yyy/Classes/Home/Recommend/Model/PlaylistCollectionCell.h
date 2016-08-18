//
//  PlaylistCollectionCell.h
//  yyy
//
//  Created by TangXing on 15/11/23.
//  Copyright © 2015年 yiyinyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaylistCollectionCell : UICollectionViewCell
@property (strong, nonatomic) IBOutlet UIImageView *image;

@property (strong, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UIImageView *userPhoto;

@property (weak, nonatomic) IBOutlet UIImageView *firstImg;

@property (weak, nonatomic) IBOutlet UILabel *firstLabel;

@property (weak, nonatomic) IBOutlet UIImageView *secondImg;

@property (weak, nonatomic) IBOutlet UILabel *secondLabel;

@end
