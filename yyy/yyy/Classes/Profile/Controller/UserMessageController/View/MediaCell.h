//
//  MediaCell.h
//  yyy
//
//  Created by TangXing on 16/5/9.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import <UIKit/UIKit.h>


@class MediaFrame;

@protocol MediaCellDelegate <NSObject>

//用户名点击事件
- (void)touchUserName:(NSString *)userId;
//点赞事件
- (void)addLike:(NSString *)userId;
//头像点击事件
- (void)touchUserPhotoWithUserId:(NSString *)userId;

@end

@interface MediaCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (strong,nonatomic) MediaFrame *mediaFrame;

@property (weak,nonatomic) id<MediaCellDelegate> mediaDelegate;

@end
