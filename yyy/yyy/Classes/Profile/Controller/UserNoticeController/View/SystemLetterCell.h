//
//  SystemLetterCell.h
//  yyy
//
//  Created by TangXing on 16/5/3.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SystemNoticeFrame;

@interface SystemLetterCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (strong,nonatomic) SystemNoticeFrame *systemNoticeFrame;

@end
