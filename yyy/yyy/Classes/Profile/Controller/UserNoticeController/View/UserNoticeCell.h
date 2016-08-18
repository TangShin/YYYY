//
//  UserNoticeCell.h
//  yyy
//
//  Created by TangXing on 16/4/14.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UserNoticeFrame;

@interface UserNoticeCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (strong,nonatomic) UserNoticeFrame *userNoticeFrame;

@end
