//
//  PlaylistSearchResultCell.h
//  yyy
//
//  Created by TangXing on 16/3/8.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaylistSearchResultCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *playlistImg;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *likeCount;
@property (weak, nonatomic) IBOutlet UILabel *favoriteCount;
@property (weak, nonatomic) IBOutlet UILabel *comdCount;


@end
