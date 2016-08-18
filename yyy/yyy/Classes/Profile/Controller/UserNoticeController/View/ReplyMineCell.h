//
//  ReplyMineCell.h
//  yyy
//
//  Created by TangXing on 16/5/4.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ReplyMineFrame;

@interface ReplyMineCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (strong,nonatomic) ReplyMineFrame *replyMineFrame;

@end
