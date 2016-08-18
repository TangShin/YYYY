//
//  VideoSearchResultCell.h
//  yyy
//
//  Created by TangXing on 16/3/8.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoSearchResultCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *addrImg;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *playCount;
@property (weak, nonatomic) IBOutlet UILabel *comdCount;

@end
