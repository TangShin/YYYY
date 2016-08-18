//
//  SubMediaCell.h
//  yyy
//
//  Created by TangXing on 16/5/11.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SubMediaFrame;

@protocol SubMediaCellDelegate <NSObject>

//子回复用户名点击事件
- (void)touchUserName:(NSString *)userId;
//被回复用户名点击事件
- (void)touchReUserName:(NSString *)reUserId;
//点赞事件
- (void)addLike:(NSString *)userId;
//头像点击事件
- (void)touchUserPhotoWithUserId:(NSString *)userId;

@end

@interface SubMediaCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (strong,nonatomic) SubMediaFrame *subMediaFrame;

@property (weak,nonatomic) id<SubMediaCellDelegate> subMediaDelegate;

@end
