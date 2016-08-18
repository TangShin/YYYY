//
//  YYYPlayCustomControlView.h
//  yyy
//
//  Created by TangXing on 15/11/3.
//  Copyright © 2015年 yiyinyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "PlayerView.h"
#import "YYYPlayCustomControlView.h"


/**
 *  播放状态区分
 *  0 初始状态
 *  1 未切换
 *  2 已切换
 */
typedef enum : NSUInteger{
    playStatusDiv_virgin = 0,
    playStatusDiv_noSwitch,
    playStatusDiv_switched,
}playStatusDiv;

/**
 *  播放模式
 *  0 顺序播放不循环
 *  1 全部循环
 *  2 单曲循环
 *  3 随机播放
 */
typedef enum : NSUInteger{
    playMode_normalLoop = 0,
    playMode_allLoop,
    playMode_singleLoop,
    playMode_randomLoop,
}playMode;

/**
 *  按钮区分
 *  1 播放模式按钮
 *  2 全屏按钮
 */
typedef enum : NSUInteger{
    buttonDiv_loop = 1,
    buttonDiv_fullScreen,
}buttonDiv;

@interface YYYPlayVideoViewController : UIViewController

@property (nonatomic,copy) NSString *videoUrl;
@property (nonatomic,copy) NSString *videoId;
@property (nonatomic,copy) NSString *videoName;

@property (nonatomic,strong) AVPlayer *videoPlayer;                         //播放器
@property (nonatomic,strong) PlayerView *videoView;                         //播放器显示层
@property (nonatomic,strong) YYYPlayCustomControlView *controlView;              //控件视图

@property (nonatomic,strong) NSArray *videoArray;                    //有序视频随机数组

@property (strong) AVPlayerItem *item;

- (void)switchVideoUrl:(NSString *)videoUrl indexPath:(NSIndexPath *)indexPath;

@end
