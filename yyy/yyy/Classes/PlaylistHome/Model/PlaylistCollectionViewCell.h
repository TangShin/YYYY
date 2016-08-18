//
//  PlaylistCollectionViewCell.h
//  yyy
//
//  Created by TangXing on 16/2/29.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaylistCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *playlistImg;//歌单图片
@property (weak, nonatomic) IBOutlet UILabel *playlistTitle;//歌单名字
@property (weak, nonatomic) IBOutlet UIImageView *userPhoto;//歌单上传者

@property (weak, nonatomic) IBOutlet UIImageView *sortImg;

@property (weak, nonatomic) IBOutlet UILabel *sortLabel;


@end
