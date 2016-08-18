//
//  PlaylistViewController.h
//  yyy
//
//  Created by TangXing on 16/2/14.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaylistViewController : UIViewController <UIScrollViewDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>

//歌单Id
@property (strong,nonatomic) NSString *playlistId;

//歌单评论字典
@property (strong,nonatomic) NSMutableDictionary *commentDic;
//歌单信息字典
@property (strong,nonatomic) NSMutableDictionary *playlistDic;
//歌单里的视频数组
@property (strong,nonatomic) NSMutableArray *videoArray;
//歌单评论数组
@property (strong,nonatomic) NSMutableArray *mediaList;
//简介的按钮
@property (strong,nonatomic) UIButton *infoBtn;
//歌单列表按钮
@property (strong,nonatomic) UIButton *playlistsBtn;
//评论的按钮
@property (strong,nonatomic) UIButton *commentBtn;

@end
