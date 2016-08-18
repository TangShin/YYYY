//
//  VideoFullScreenController.m
//  yyy
//
//  Created by TangXing on 15/11/26.
//  Copyright © 2015年 yiyinyue. All rights reserved.
//

#import "VideoFullScreenController.h"
#import "YYYPlayCustomControlView.h"
#import "PlayerView.h"


@interface VideoFullScreenController ()

@property (nonatomic,strong) AVPlayer *videoPlayer;                         //播放器
@property (nonatomic,strong) PlayerView *videoView;                        //播放器显示层
@property (strong) AVPlayerItem *item;

@property (nonatomic,strong) YYYPlayCustomControlView *controlView;              //控件视图

@property (nonatomic,assign) CGRect originFrame;
@property (nonatomic,assign) BOOL isFullscreen;                             //是否横屏
@property (nonatomic,assign) UIInterfaceOrientation currentOrientation;     //当前屏幕方向

@property (nonatomic,strong) id timeObserver;

@end

@implementation VideoFullScreenController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSURL *sourceURL = [NSURL URLWithString:self.videoUrl];
    
    AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:sourceURL options:nil];
    _item = [AVPlayerItem playerItemWithAsset:movieAsset];
    _videoPlayer = [AVPlayer playerWithPlayerItem:_item];
    AVPlayerLayer *playerlayer = [AVPlayerLayer playerLayerWithPlayer:_videoPlayer];
    playerlayer.frame = self.view.layer.bounds;
    playerlayer.videoGravity = AVLayerVideoGravityResizeAspect;
    
    [self.view.layer addSublayer:playerlayer];
    [_videoPlayer play];
    
//    [self turnToRight:playerlayer];
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
}

-(void)turnToRight:(AVPlayerLayer *)player
{
    CGRect frect = [self getLandscapeFrame];
    
    if(_isFullscreen)
    {
        self.view.transform = CGAffineTransformIdentity;
    }
    
    [UIView animateWithDuration:0.5f animations:^{
        self.view.frame = frect;
        self.view.transform = CGAffineTransformMakeRotation(M_PI_2);
        player.frame = self.view.layer.bounds;
    }completion:^(BOOL finished) {
        self.isFullscreen = YES;
    }];
}

-(CGRect)getLandscapeFrame
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    CGRect frect = CGRectZero;
//    frect.origin.x = (screenSize.width - screenSize.height) / 2.0f;
//    frect.origin.y = (screenSize.height - screenSize.width) / 2.0f;
    frect.origin.x = 0.0f;
    frect.origin.y = 0.0f;
    frect.size.width = screenSize.height;
    frect.size.height = screenSize.width;
    
    return frect;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscapeLeft;
    //    return UIInterfaceOrientationMaskLandscape;
}

-(BOOL)shouldAutorotate
{
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
