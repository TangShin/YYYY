//
//  VideoShareCell.h
//  yyy
//
//  Created by TangXing on 15/12/3.
//  Copyright © 2015年 yiyinyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoShareCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIButton *shareBtn;
@property (strong, nonatomic) IBOutlet UIButton *favoriteBtn;
@property (strong, nonatomic) IBOutlet UIButton *likeBtn;
@property (strong, nonatomic) IBOutlet UIButton *downloadBtn;
@property (strong, nonatomic) IBOutlet UILabel *shareCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *favoriteCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *likeCountLabel;
@property (strong, nonatomic) IBOutlet UILabel *downloadCountLabel;
@end
