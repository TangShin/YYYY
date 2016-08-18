//
//  ProfileViewCell.h
//  yyy
//
//  Created by TangXing on 16/3/14.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIPageControl *NewNotice;

@end
