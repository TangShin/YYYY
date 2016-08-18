//
//  FavoriteViewCell.h
//  yyy
//
//  Created by TangXing on 16/3/31.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FavoriteViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *videoImage;
@property (weak, nonatomic) IBOutlet UIImageView *playlistImage;
@property (weak, nonatomic) IBOutlet UILabel *videoName;
@property (weak, nonatomic) IBOutlet UILabel *playlistName;

@end
