//
//  PlayVideoView.h
//  yyy
//
//  Created by TangXing on 15/10/29.
//  Copyright © 2015年 yiyinyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayVideoViewController : UIViewController <UIScrollViewDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UITextViewDelegate>

//数据源
@property (strong,nonatomic) NSString *videoId;

//服务器获取的数据
@property (strong,nonatomic) NSMutableDictionary *commentDic;
@property (strong,nonatomic) NSMutableDictionary *videoDic;
@property (strong,nonatomic) NSArray *reCommendArray;

@property (strong,nonatomic) NSMutableArray *mediaList;

@property (assign,nonatomic) BOOL isHiddenBar;

//下部分ui
@property (strong,nonatomic) UIButton *infoBtn;
@property (strong,nonatomic) UIButton *recommendBtn;
@property (strong,nonatomic) UIButton *commentBtn;

@end
