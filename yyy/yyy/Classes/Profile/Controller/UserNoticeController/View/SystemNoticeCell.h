//
//  SystemNoticeCell.h
//  yyy
//
//  Created by TangXing on 16/4/14.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SystemNoticeCell : UITableViewCell

@property (copy,nonatomic) NSString *totalStr;//计数

+ (instancetype)cellWithTableView:(UITableView *)tableView withSystemName:(NSString *)systemName;

@end
