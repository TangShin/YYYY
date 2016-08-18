//
//  VideoHistoryCell.h
//  yyy
//
//  Created by TangXing on 16/3/31.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoHistoryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UIImageView *playlistImage;

@property (weak, nonatomic) IBOutlet UILabel *videoName;

@end
