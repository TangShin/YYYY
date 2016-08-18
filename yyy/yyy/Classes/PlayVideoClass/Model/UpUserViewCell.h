//
//  UpUserViewCell.h
//  yyy
//
//  Created by TangXing on 15/12/4.
//  Copyright © 2015年 yiyinyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UpUserViewCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UIImageView *upUserPhoto;
@property (strong, nonatomic) IBOutlet UILabel *upUserName;
@property (strong, nonatomic) IBOutlet UILabel *upLoadTime;

@property (strong, nonatomic) IBOutlet UIButton *followed;
@property (strong, nonatomic) IBOutlet UIButton *follow;

@end
