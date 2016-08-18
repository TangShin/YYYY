//
//  ComentViewCell.h
//  yyy
//
//  Created by TangXing on 15/12/3.
//  Copyright © 2015年 yiyinyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ComentViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *icon;
@property (strong, nonatomic) IBOutlet UILabel *userName;
@property (strong, nonatomic) IBOutlet UILabel *floor;
@property (strong, nonatomic) IBOutlet UILabel *timeView;
@property (strong, nonatomic) IBOutlet UIButton *subMediaCount;
@property (strong, nonatomic) IBOutlet UIButton *supportCount;
@property (strong, nonatomic) IBOutlet UILabel *coment;

@end
