//
//  VideoInfoViewCell.h
//  yyy
//
//  Created by TangXing on 15/12/4.
//  Copyright © 2015年 yiyinyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoInfoViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *videoName;
@property (strong, nonatomic) IBOutlet UILabel *playCount;
@property (strong, nonatomic) IBOutlet UILabel *comentCount;
@property (strong, nonatomic) IBOutlet UILabel *videoInfo;
@property (strong, nonatomic) IBOutlet UIButton *showMore;

@end
