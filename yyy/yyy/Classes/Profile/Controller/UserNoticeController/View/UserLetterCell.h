//
//  UserLetterCell.h
//  yyy
//
//  Created by TangXing on 16/4/18.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserLetterFrame;

@interface UserLetterCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (strong,nonatomic) UserLetterFrame *userLetterFrame;

@end
