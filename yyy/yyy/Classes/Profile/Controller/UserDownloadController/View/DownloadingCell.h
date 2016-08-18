//
//  DownloadingCell.h
//  yyy
//
//  Created by TangXing on 16/3/16.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownloadingCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *downloadName;
@property (weak, nonatomic) IBOutlet UIProgressView *progress;
@property (weak, nonatomic) IBOutlet UILabel *downloadSpeed;
@property (weak, nonatomic) IBOutlet UILabel *downloadTotalCal;
@property (weak, nonatomic) IBOutlet UIImageView *fileImage;
@property (weak, nonatomic) IBOutlet UIButton *startAndPause;

@property (weak, nonatomic) IBOutlet UIView *mask;

@end
