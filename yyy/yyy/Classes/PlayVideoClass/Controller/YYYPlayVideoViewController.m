//
//  YYYPlayCustomControlView.h
//  yyy
//
//  Created by TangXing on 15/11/3.
//  Copyright © 2015年 yiyinyue. All rights reserved.
//-----------------播放器vc-----------------------

#import "YYYPlayVideoViewController.h"
#import "YYYPlayCustomNavigationView.h"
#import "PlaylistViewController.h"
#import "FullScreenTopView.h"
#import "YYYHttpTool.h"
#import "UserInfoTool.h"
#import <MediaPlayer/MediaPlayer.h>

#import "ProfileViewTool.h"

@interface YYYPlayVideoViewController ()
//控件视图
@property (nonatomic,strong) FullScreenTopView *fullscreenTopView;

@property (nonatomic,assign) CGRect originFrame;
@property (nonatomic,assign) BOOL isFullscreen;                             //是否横屏
@property (nonatomic,assign) UIInterfaceOrientation currentOrientation;     //当前屏幕方向

@property (nonatomic,strong) id timeObserver;

@property (nonatomic,strong) UIButton *playButton;                          //播放暂停按钮
@property (nonatomic,assign) CGFloat currentTime;                           //当前播放时间

@property (nonatomic,assign) NSUInteger panDirection;                       //手势方向，0代表水平，1代表垂直
@property (nonatomic,strong) UIView *horizontalView;                        //水平滑动时出现的view
@property (nonatomic,strong) UIImageView *horizontalImg;                    //水平滑动时出现的img
@property (nonatomic,strong) UILabel *horizontalLabel;                      //水平滑动时显示进度
@property (nonatomic,assign) BOOL isVolume;                                 //判断是否正在滑动音量
@property (nonatomic,assign) BOOL isLight;                                  //判断是否正在滑动亮度
@property (nonatomic,assign) CGFloat sumTime;                               //用来保存快进的总时长
@property (nonatomic,strong) UISlider *volumeSlider;                        //系统音量条
@property (nonatomic,assign) CGFloat lightValue;                            //系统亮度

@property (nonatomic,assign) long indexPathRow;                             //存贮被点击的视频的indexpath.row
@property (nonatomic,assign) int playStatusDiv;                             //播放状态区分
@property (nonatomic,assign) int  playMode;                                 //播放模式

@property (nonatomic,assign) long playIndex;                                //顺序视频数组索引
@property (nonatomic,strong) NSArray *randomVideoArray;                     //乱序视频随机数组

@property (nonatomic,assign) BOOL isPlay;                                   //是否播放
@property (nonatomic,assign) CGFloat time;                                  //播放时间
@property (nonatomic,assign) BOOL canCount;                                 //是否计数

@property (nonatomic,assign) CGFloat hiddenTime;                            //隐藏工具条时间
@property (nonatomic,assign) BOOL sliderEnd;                                //滑块滑动结束

@property (nonatomic,strong) UserSetting *userSetting;

@end

@implementation YYYPlayVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.userSetting = [ProfileViewTool userSetting];
    
    //初始为－1，没有点击任何视频
    _indexPathRow = -1;
    //初始为NO，没有切换视频
    _playStatusDiv = playStatusDiv_virgin;
    //初始为0，默认列表循环
    _playMode = playMode_normalLoop;
    //初始为0
    _playIndex = 0;
    //初始为yes，播放
    _isPlay = YES;
    //初始为0
    _time = 0;
    //初始为0
    _hiddenTime = 0;
    //初始为NO
    _canCount = NO;
    //初始为yes
    _sliderEnd = YES;
    [_controlView setIsPlaying:NO];
    
    //创建播放器
    [self setupVideoPlayer];

//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(deviceOrientationChanged:) name:UIDeviceOrientationDidChangeNotification object:nil];
    
    //播放通知
    NSNotificationCenter *playVideo = [NSNotificationCenter defaultCenter];
    [playVideo addObserver:self selector:@selector(playVideo) name:@"playVideo" object:nil];
    
}

-(void)dealloc
{
    [self removeTimeObserver];
    [self.item removeObserver:self forKeyPath:@"status"];
    [_videoPlayer cancelPendingPrerolls];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"playVideo" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"exitFullScreen" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.item];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"hiddenBar" object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES];

    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [_videoPlayer pause];
    [_controlView setIsPlaying:NO];
    [self.navigationController setNavigationBarHidden:NO];
    
    [super viewWillDisappear:animated];
}

//创建视频播放层
-(void)setupVideoPlayer
{
    self.originFrame = CGRectMake(0, 0, kScreenWidth, kScreenWidth * kVideoHWRatio);
    
    if (!_playButton) {
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat playbuttonX = self.originFrame.size.width - 60;
        CGFloat playbuttonY = self.originFrame.size.height - 50 - 60; //50为底部工具条的高度
        _playButton.frame = CGRectMake(playbuttonX, playbuttonY, 50, 50);
        [_playButton addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_playButton];
    }
    
    if(!_controlView)
    {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([YYYPlayCustomControlView class]) owner:nil options:nil];
        if(nibArray.count > 0)
        {
            YYYPlayCustomControlView *view = nibArray[0];
            
            view.translatesAutoresizingMaskIntoConstraints = NO;
            [self.view addSubview:view];
            
            self.controlView = view;
            
            NSDictionary *paramDic = @{@"viewHeight":@(50.0f)};
            NSArray *view_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)];
            NSArray *view_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[view(viewHeight)]|" options:0 metrics:paramDic views:NSDictionaryOfVariableBindings(view)];
            [self.view addConstraints:view_H];
            [self.view addConstraints:view_V];
        }
        else
        {
            NSAssert(0, @"there was no xib named ...");
        }
        
        __weak YYYPlayVideoViewController *weakSelf = self;
        [_controlView showWithClickHandle:^(NSInteger tag) {
                if (tag == buttonDiv_loop)
                {//循环事件
                    _playMode ++;
                    if (_playMode > playMode_randomLoop) {
                        _playMode = playMode_normalLoop;
                    }
                    if (_playMode == playMode_normalLoop) {
                        //顺序播放
                        [self.controlView.loopButton setImage:[UIImage imageNamed:@"list_play"] forState:UIControlStateNormal];
                        for (int i = 0; i < self.videoArray.count; i++) {
                            NSString *videoId = self.videoArray[i][@"videoId"];
                            if ([videoId isEqualToString:self.videoId]) {
                                self.playIndex = i;
                                break;
                            }
                        }
                    } else if (_playMode == playMode_allLoop) {
                        //全部循环播放
                        [self.controlView.loopButton setImage:[UIImage imageNamed:@"list_loop"] forState:UIControlStateNormal];
                        for (int i = 0; i < self.videoArray.count; i++) {
                            NSString *videoId = self.videoArray[i][@"videoId"];
                            if ([videoId isEqualToString:self.videoId]) {
                                self.playIndex = i;
                                break;
                            }
                        }
                    } else if (_playMode == playMode_singleLoop) {
                        //单曲循环播放
                        [self.controlView.loopButton setImage:[UIImage imageNamed:@"single_loop"] forState:UIControlStateNormal];
                        for (int i = 0; i < self.videoArray.count; i++) {
                            NSString *videoId = self.videoArray[i][@"videoId"];
                            if ([videoId isEqualToString:self.videoId]) {
                                self.playIndex = i;
                                break;
                            }
                        }
                    } else if (_playMode == playMode_randomLoop) {
                        //随机播放
                        [self.controlView.loopButton setImage:[UIImage imageNamed:@"random_loop"] forState:UIControlStateNormal];
                        //打乱视频数组
                        self.randomVideoArray = [self.videoArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
                            return (arc4random() % 3) - 1;
                        }];
                        self.playIndex = 0;
                    }
                }
                else if (tag == buttonDiv_fullScreen)
                {//全屏
                    if(!weakSelf.isFullscreen)
                    {
                        [_fullscreenTopView setHidden:NO];
                        [weakSelf turnToRight];
                        _playButton.frame = CGRectMake(self.view.frame.size.height - 60, self.view.frame.size.width - 60 - 50, 50, 50);
                    }
                    else
                    {
                        [_fullscreenTopView setHidden:YES];
                        [weakSelf turnToPortraint];
                        _playButton.frame = CGRectMake(self.originFrame.size.width - 60, self.originFrame.size.height - 60 - 50, 50, 50);
                    }
                }
            self.hiddenTime = 0;
            
        } slideHandle:^(CGFloat interval,BOOL isFinished) {
            
            self.hiddenTime = 0;
            TSLog(@"finished2 %d",isFinished);
            if(isFinished)
            {
                TSLog(@"finished3 %d",isFinished);
                _sliderEnd = YES;
                //滑块拖动停止
                CMTime time = CMTimeMakeWithSeconds(interval, weakSelf.videoPlayer.currentItem.duration.timescale);
                
                [weakSelf.videoPlayer seekToTime:time toleranceBefore:CMTimeMake(1, 30) toleranceAfter:CMTimeMake(1, 30) completionHandler:^(BOOL finished) {
                    TSLog(@"滑块拖动时间过小 %f",interval);
                    if (self.controlView.isPlaying == YES) {
                        [self.videoPlayer play];
                        TSLog(@"滑块play %d",self.controlView.isPlaying);
                    } else if (self.controlView.isPlaying == NO){
                        [self.videoPlayer pause];
                        TSLog(@"滑块pause %d",self.controlView.isPlaying);
                    }
                }];
            }
            else
            {
                _sliderEnd = NO;
                if(weakSelf.videoPlayer.rate > 0)
                {
                    TSLog(@"不明用处的isplaying %d",self.controlView.isPlaying);
//                    weakSelf.controlView.isPlaying = NO;
//                    [weakSelf.videoPlayer pause];
                }
                TSLog(@"finished1 %d",isFinished);
            }
        }];
    }
    
    [self setupTopView];
    
    // 水平滑动显示的进度label
    CGFloat horizontalViewX = (self.view.frame.size.width - 100)/2;
    CGFloat horizontalViewY = (kScreenWidth * kVideoHWRatio - 80)/2;
    
    self.horizontalView = [[UIView alloc] initWithFrame:CGRectMake(horizontalViewX, horizontalViewY, 100, 80)];
    self.horizontalView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    
    self.horizontalImg = [[UIImageView alloc] initWithFrame:CGRectMake(30, 10, 40, 30)];
    
    self.horizontalLabel = [[UILabel alloc]initWithFrame:CGRectMake(0,40,100,40)];
    self.horizontalLabel.textColor = [UIColor whiteColor];
    self.horizontalLabel.textAlignment = NSTextAlignmentCenter;
    self.horizontalLabel.text = @"00:00 / --:--";
    // 一上来先隐藏
    self.horizontalView.hidden = YES;
    [self.horizontalView addSubview:self.horizontalImg];
    [self.horizontalView addSubview:self.horizontalLabel];
    [self.view addSubview:self.horizontalView];
    
    //获取系统音量条
    MPVolumeView *volumeView = [[MPVolumeView alloc] init];
    self.volumeSlider = nil;
    for (UIView *view in volumeView.subviews) {
        self.volumeSlider = (UISlider *)view;
        break;
    }
    
    //添加屏幕单击手势
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleTapScreen:)];
    singleTap.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:singleTap];
    
    //添加屏幕双击手势
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTapScreen:)];
    doubleTap.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTap];
    
    //只有当没有检测到 doubleTap 或者检测 doubleTap 失败, singleTap 才有效
    [singleTap requireGestureRecognizerToFail:doubleTap];
    
    // 添加平移手势，用来控制音量和快进快退
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panDirection:)];
    [self.view addGestureRecognizer:pan];
}

//创建顶部工具条
- (void)setupTopView
{
    if (!_fullscreenTopView) {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([FullScreenTopView class]) owner:nil options:nil];
        
        if (nibArray.count > 0) {
            FullScreenTopView *view = nibArray[0];
            view.videoName.text = self.videoName;
            
            [view.exitFullScreen addTarget:self action:@selector(exitFullScreen) forControlEvents:UIControlEventTouchUpInside];
            
            view.translatesAutoresizingMaskIntoConstraints = NO;
            [self.view addSubview:view];
            
            self.fullscreenTopView = view;
            
            NSDictionary *pramDic = @{@"viewHeight":@(64.0f)};
            NSArray *view_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(view)];
            NSArray *view_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view(viewHeight)]" options:0 metrics:pramDic views:NSDictionaryOfVariableBindings(view)];
            
            [self.view addConstraints:view_H];
            [self.view addConstraints:view_V];
        }
        else
        {
            NSAssert(0,@"there was no xib named ...");
        }
        
    }
    
    [self.fullscreenTopView setHidden:YES];
}

#pragma mark -
//屏幕支持方向
-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationPortrait | UIInterfaceOrientationLandscapeLeft | UIInterfaceOrientationLandscapeRight;
}

-(BOOL)shouldAutorotate
{
    return YES;
}

//视频url
-(void)setVideoUrl:(NSString *)videoUrl
{
    if(_videoUrl != videoUrl)
    {
        _videoUrl = videoUrl;
        if(_videoUrl == nil)
        {
            return;
        }
        
        [self valuation:_videoUrl];
    }
}

//视频播放
- (void)prepareToPlayAsset:(AVURLAsset *)asset withKeys:(NSArray *)requestedKeys
{
    for (NSString *thisKey in requestedKeys)
    {
        NSError *error = nil;
        AVKeyValueStatus keyStatus = [asset statusOfValueForKey:thisKey error:&error];
        if (keyStatus == AVKeyValueStatusFailed)
        {
            [self assetFailedToPrepareForPlayback:error];
            return;
        }
    }
    
    if (!asset.playable)
    {
        NSString *localizedDescription = NSLocalizedString(@"Item cannot be played", @"Item cannot be played description");
        NSString *localizedFailureReason = NSLocalizedString(@"The assets tracks were loaded, but could not be made playable.", @"Item cannot be played failure reason");
        NSDictionary *errorDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                   localizedDescription, NSLocalizedDescriptionKey,
                                   localizedFailureReason, NSLocalizedFailureReasonErrorKey,
                                   nil];
        NSError *assetCannotBePlayedError = [NSError errorWithDomain:@"StitchedStreamPlayer" code:0 userInfo:errorDict];
        
        [self assetFailedToPrepareForPlayback:assetCannotBePlayedError];
        
        return;
    }
    
    if (self.item)
    {
        [self.item removeObserver:self forKeyPath:@"status"];
    }
    
    self.item = [AVPlayerItem playerItemWithAsset:asset];
    
    [self.item addObserver:self
                       forKeyPath:@"status"
                          options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew
                          context:nil];
    
    if (!self.videoPlayer)
    {
        self.videoPlayer = [AVPlayer playerWithPlayerItem:self.item];
    }
    
    if (self.videoPlayer.currentItem != self.item)
    {
        [self.videoPlayer replaceCurrentItemWithPlayerItem:self.item];
    }
    
    [self removeTimeObserver];
    
    __weak YYYPlayVideoViewController *weakSelf = self;
        self.timeObserver = [_videoPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
            _currentTime = CMTimeGetSeconds(time);
            
            if (weakSelf.sliderEnd) {
                [weakSelf.controlView setSlideValue:_currentTime / weakSelf.controlView.videoDuration];
            }
            if (_currentTime == 0) {
                _time = 0;
            }
            if (_time == 0 && _currentTime < 2) {
                _canCount = YES;
            }
            if (_currentTime - _time > 2) {
                _canCount = NO;
            }
            if (_hiddenTime >= 5 && !weakSelf.controlView.isHidden) {
                weakSelf.controlView.hidden = YES;
                weakSelf.playButton.hidden = YES;
                weakSelf.fullscreenTopView.hidden = YES;
                //隐藏顶部工具条通知
                NSNotification *notice = [NSNotification notificationWithName:@"hiddenBar" object:nil];
                [[NSNotificationCenter defaultCenter] postNotification:notice];
            }
            TSLog(@"%f",weakSelf.hiddenTime);
            if (!weakSelf.controlView.isHidden && weakSelf.sliderEnd) {
                weakSelf.hiddenTime ++;
            } else {
                weakSelf.hiddenTime = 0;
            }
            _time = _currentTime;
        }];
//    }
    //播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(videoEnd) name:AVPlayerItemDidPlayToEndTimeNotification object:self.item];
    
    if(!_videoView)
    {
        self.videoView = [[PlayerView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenWidth * kVideoHWRatio)];
        _videoView.translatesAutoresizingMaskIntoConstraints = NO;
        _videoView.player = _videoPlayer;
        [_videoView setFillMode:AVLayerVideoGravityResizeAspect];
        [self.view insertSubview:_videoView belowSubview:_controlView];
        
        NSArray *view_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_videoView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_videoView)];
        NSArray *view_V = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_videoView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_videoView)];
        [self.view addConstraints:view_H];
        [self.view addConstraints:view_V];
    }
    
    [self.view sendSubviewToBack:_videoView];
    
    if (_userSetting.autoPlay && _playStatusDiv == playStatusDiv_virgin) {
        [self playVideo];
    } else if (_playStatusDiv == playStatusDiv_virgin) {
        [_videoPlayer pause];
    } else {
        if (_isPlay) {
            [_videoPlayer play];
        } else {
            [_videoPlayer pause];
        }
        _playStatusDiv = playStatusDiv_noSwitch;
    }
    
    if (_userSetting.autoFullScreenPlay && _playStatusDiv == playStatusDiv_virgin) {
        [_fullscreenTopView setHidden:NO];
        [self turnToRight];
        _playButton.frame = CGRectMake(self.view.frame.size.height - 60, self.view.frame.size.width - 60 - 50, 50, 50);
    }
}

//错误信息返回
-(void)assetFailedToPrepareForPlayback:(NSError *)error
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[error localizedDescription]
                                                        message:[error localizedFailureReason]
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
    [alertView show];
}

-(void)removeTimeObserver
{
    if (_timeObserver)
    {
        [self.videoPlayer removeTimeObserver:_timeObserver];
        _timeObserver = nil;
    }
}

#pragma mark 单击手势事件
-(void)singleTapScreen:(UITapGestureRecognizer *)tapGesture
{
    CGPoint point = [tapGesture locationInView:self.view];
    if(!CGRectContainsPoint(_controlView.frame, point))
    {
        [_controlView setHidden:!_controlView.isHidden];
        [_playButton setHidden:!_playButton.isHidden];
        if ([UIApplication sharedApplication].statusBarOrientation != 1) {
            [_fullscreenTopView setHidden:!_fullscreenTopView.isHidden];
        } else {
            [_fullscreenTopView setHidden:YES];
        }
        //隐藏顶部工具条通知
        NSNotification *notice = [NSNotification notificationWithName:@"hiddenBar" object:nil];
        [[NSNotificationCenter defaultCenter] postNotification:notice];
        _hiddenTime = 0;
    }
}

#pragma mark 双击手势事件
-(void)doubleTapScreen:(UITapGestureRecognizer *)tapGesture
{
    CGPoint point = [tapGesture locationInView:self.view];
    if(!CGRectContainsPoint(_controlView.frame, point))
    {
        if (self.controlView.isPlaying) {
            [self.videoPlayer pause];
            self.controlView.isPlaying = NO;
            [_playButton setImage:[UIImage imageNamed:@"play_btn"] forState:UIControlStateNormal];
        } else {
            [self.videoPlayer play];
            self.controlView.isPlaying = YES;
            [_playButton setImage:[UIImage imageNamed:@"pause_btn"] forState:UIControlStateNormal];
        }
        _hiddenTime = 0;
    }
}

//#pragma mark 手势点击开始
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    _hiddenTime = 0;
//    TSLog(@"began");
//}

//#pragma mark 手势点击结束
//- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
//{
//    TSLog(@"end");
//}

#pragma mark 视图滑动事件
- (void)panDirection:(UIPanGestureRecognizer *)pan
{
    //根据上次和本次的移动的位置，算出一个速率的point
    CGPoint veloctyPoint = [pan velocityInView:self.view];
    //判断是水平还是垂直移动
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
        {
            CGFloat x = fabs(veloctyPoint.x);
            CGFloat y = fabs(veloctyPoint.y);
            if (x > y) { //水平移动
                _panDirection = 0;
                //取消隐藏
                self.horizontalView.hidden = NO;
                //给sumTime初值
                _sumTime = _currentTime;
                
            } else if (x < y){ //垂直移动
                _panDirection = 1;
                _isVolume = YES;
                _lightValue = [UIScreen mainScreen].brightness;
            }
            break;
        }
         case UIGestureRecognizerStateChanged: //正在移动
        {
            _hiddenTime = 0;
            switch (_panDirection) {
                case 0:
                {
                    [self horizontalMoved:veloctyPoint.x];  //水平移动的方法只要x方向的值
                    break;
                }
                case 1:
                {
                    CGPoint point = [pan locationInView:self.view];
                    if (point.x < [UIScreen mainScreen].bounds.size.width/2) {
                        [self verticalMovedForLight:veloctyPoint.y];
                    } else if (point.x > [UIScreen mainScreen].bounds.size.width/2) {
                        [self verticalMovedForVol:veloctyPoint.y];    //垂直移动方法只要y方向的值
                    }
                    break;
                }
                default:
                    break;
            }
            break;
        }
        case UIGestureRecognizerStateEnded:
        {   //移动停止
            // 移动结束也需要判断垂直或者平移
            // 比如水平移动结束时，要快进到指定位置，如果这里没有判断，当我们调节音量完之后，会出现屏幕跳动的bug
            switch (_panDirection) {
                case 0:
                {
                    self.horizontalView.hidden = YES;
                    // ⚠️在滑动结束后，视屏要跳转
                    //滑块拖动停止
                    CMTime time = CMTimeMakeWithSeconds(_sumTime, self.videoPlayer.currentItem.duration.timescale);
                    [self.videoPlayer seekToTime:time toleranceBefore:kCMTimeZero toleranceAfter:kCMTimeZero completionHandler:^(BOOL finished) {
                        if (self.controlView.isPlaying == YES) {
                            [self.videoPlayer play];TSLog(@"滑块2play %d",self.controlView.isPlaying);
                        } else if (self.controlView.isPlaying == NO){
                            [self.videoPlayer pause];TSLog(@"滑块2pause %d",self.controlView.isPlaying);
                        }
                        self.hiddenTime = 0;
                    }];
                    // 把sumTime滞空，不然会越加越多
                    _sumTime = 0;
                    break;
                }
                case 1:
                {
                    CGPoint point = [pan locationInView:self.view];
                    if (point.x < [UIScreen mainScreen].bounds.size.width/2) {
                        [[UIScreen mainScreen] setBrightness:self.lightValue];
                    } else if (point.x > [UIScreen mainScreen].bounds.size.width/2) {
                        //把状态改为不再控制音量
                        _isVolume = NO;
                    }
                    break;
                }
                default:
                    break;
            }
            break;
        }
        default:
            break;
    }
    
}

#pragma mark pan水平移动的方法
- (void)horizontalMoved:(CGFloat)value
{
    if (_isFullscreen) {
        CGFloat horizontalViewX = (self.view.frame.size.height - 100)/2;
        CGFloat horizontalViewY = (self.view.frame.size.width - 80)/2;
        
        self.horizontalView.frame = CGRectMake(horizontalViewX, horizontalViewY, 100, 80);
    } else if (!_isFullscreen) {
        CGFloat horizontalViewX = (self.view.frame.size.width - 100)/2;
        CGFloat horizontalViewY = (kScreenWidth * kVideoHWRatio - 80)/2;
        
        self.horizontalView.frame = CGRectMake(horizontalViewX, horizontalViewY, 100, 80);
    }
    
    if (value < 0) {
        [self.horizontalImg setImage:[UIImage imageNamed:@"dd.png"]];
    } else if (value > 0) {
        [self.horizontalImg setImage:[UIImage imageNamed:@"bb.png"]];
    }
    
    //每次滑动叠加的时间
    _sumTime += value/200;
    
    // 需要限定sumTime的范围
    if (_sumTime > self.controlView.videoDuration) {
        _sumTime = self.controlView.videoDuration;
    }else if (_sumTime < 0){
        _sumTime = 0;
    }
    
    //当前快进的时间
    NSString *nowTime = [self durationStringWithTime:(int)_sumTime];
    // 总时间
    NSString *durationTime = [self durationStringWithTime:(int)self.controlView.videoDuration];
    // 给label赋值
    self.horizontalLabel.text = [NSString stringWithFormat:@"%@/%@",nowTime,durationTime];
}

#pragma mark - 根据时长求出字符串
- (NSString *)durationStringWithTime:(int)time
{
    // 获取分钟
    NSString *min = [NSString stringWithFormat:@"%02d",time / 60];
    // 获取秒数
    NSString *sec = [NSString stringWithFormat:@"%02d",time % 60];
    return [NSString stringWithFormat:@"%@:%@", min, sec];
}

#pragma mark pan垂直移动的亮度调节方法
- (void)verticalMovedForLight:(CGFloat)value
{
    self.lightValue -= value/1000;
    TSLog(@"亮度 : %f",self.lightValue);
}

#pragma mark pan垂直移动的音量调节方法
- (void)verticalMovedForVol:(CGFloat)value
{
    self.volumeSlider.value -= value/1000;
    TSLog(@"音量 : %f",self.volumeSlider.value);
}

//竖屏
-(void)turnToPortraint
{
    [UIView animateWithDuration:0.5f animations:^{
        self.view.transform = CGAffineTransformIdentity;
        self.view.frame = _originFrame;
    }completion:^(BOOL finished) {
        self.isFullscreen = NO;
    }];
    
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:YES];

    NSDictionary *isFullscreenDic = [[NSDictionary alloc] initWithObjectsAndKeys:@"no",@"isFullscreen", nil];
    NSNotification *notice = [NSNotification notificationWithName:@"hiddenTopView" object:nil userInfo:isFullscreenDic];
    [[NSNotificationCenter defaultCenter]postNotification:notice];
}

//横屏
-(void)turnToLeft
{
    CGRect frect = [self getLandscapeFrame];
    
    //横屏旋转的时候 需要先置为初始状态，否则会出现位置偏移的情况
    if(_isFullscreen)
    {
        self.view.transform = CGAffineTransformIdentity;
    }
    
    [UIView animateWithDuration:0.5f animations:^{
        self.view.frame = frect;
        self.view.transform = CGAffineTransformMakeRotation(-M_PI_2);
    }completion:^(BOOL finished) {
        self.isFullscreen = YES;
    }];
}

-(void)turnToRight
{
    CGRect frect = [self getLandscapeFrame];
    
    if(_isFullscreen)
    {
        self.view.transform = CGAffineTransformIdentity;
    }
    
    [UIView animateWithDuration:0.5f animations:^{
        self.view.frame = frect;
        self.view.transform = CGAffineTransformMakeRotation(M_PI_2);
    }completion:^(BOOL finished) {
        self.isFullscreen = YES;
    }];
    
    [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:YES];
    //全屏后传值给playvideoview
    NSDictionary *isFullscreenDic = [[NSDictionary alloc] initWithObjectsAndKeys:@"yes",@"isFullscreen", nil];
    NSNotification *notice = [NSNotification notificationWithName:@"hiddenTopView" object:nil userInfo:isFullscreenDic];
    [[NSNotificationCenter defaultCenter]postNotification:notice];
}

//视频frame
-(CGRect)getLandscapeFrame
{
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    
    CGRect frect = CGRectZero;
    frect.origin.x = (screenSize.width - screenSize.height) / 2.0f;
    frect.origin.y = (screenSize.height - screenSize.width) / 2.0f;
    frect.size.width = screenSize.height;
    frect.size.height = screenSize.width;
    
    return frect;
}

//视频时间长度
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"status"])
    {
        AVPlayerStatus status = [[change objectForKey:NSKeyValueChangeNewKey] integerValue];
        
        switch (status) {
            case AVPlayerStatusReadyToPlay:
            {
                [_controlView setIsPlaying:YES];
                [_controlView setIsControlEnable:YES];
                
                //只有在播放状态才能获取视频时间长度
                AVPlayerItem *playerItem = (AVPlayerItem *)object;
                NSTimeInterval duration = CMTimeGetSeconds(playerItem.asset.duration);
                _controlView.videoDuration = duration;
            }
                break;
            case AVPlayerStatusFailed:
            {
                [_controlView setIsPlaying:NO];
                AVPlayerItem *playerItem = (AVPlayerItem *)object;
                [self assetFailedToPrepareForPlayback:playerItem.error];
            }
                break;
            case AVPlayerStatusUnknown:
            {
                [_controlView setIsPlaying:NO];
            }
                break;
            default:
                break;
        }
    }
}

#pragma mark 播放结束后，不同播放模式所执行的方法
- (void)videoEnd
{
    if (self.playMode == playMode_normalLoop) {
        //当前列表顺序播放
        [self performSelector:@selector(normalLoopPlay) withObject:nil];
    } else if (self.playMode == playMode_allLoop) {
        //当前列表循环播放
        [self performSelector:@selector(allLoopPlay) withObject:nil];
    } else if (self.playMode == playMode_singleLoop) {
        //当前单曲循环播放
        [self performSelector:@selector(singleLoopPlay) withObject:nil];
    } else if (self.playMode == playMode_randomLoop) {
        //当前随机循环播放
        [self performSelector:@selector(randomLoopPlay) withObject:nil];
    }
    
    _time = 0;
    _hiddenTime = 0;
    
    if (_canCount) {
        _canCount = NO;
        NSDictionary *prametersPlayCount = [[NSDictionary alloc] init];
        prametersPlayCount = [NSDictionary dictionaryWithObjectsAndKeys:self.videoId,@"playId",[UserInfoTool userInfo].userId,@"userId",nil];
        [YYYHttpTool post:YYYPlayCountAddURL params:prametersPlayCount success:^(id json) {
            
            TSLog(@"playCoutnAdd : %@",json);
            
        } failure:^(NSError *error) {
            
            TSLog(@"PlayCountAddERROR: %@",error);
        }];
    }
}

#pragma mark 列表循环方法
- (void)normalLoopPlay
{
    self.playIndex ++;
    if (self.playIndex >= self.videoArray.count) {
        self.playIndex = 0;
        _isPlay = NO;
    } else {
        _isPlay = YES;
    }
    [self valuation:self.videoArray[self.playIndex][@"videoAddr"]];
    self.videoId = self.videoArray[self.playIndex][@"videoId"];
    _playStatusDiv = playStatusDiv_noSwitch;
}

#pragma mark 列表循环方法
- (void)allLoopPlay
{
    self.playIndex ++;
    if (self.playIndex >= self.videoArray.count) {
        self.playIndex = 0;
    }
    [self valuation:self.videoArray[self.playIndex][@"videoAddr"]];
    self.videoId = self.videoArray[self.playIndex][@"videoId"];
    _isPlay = YES;
    _playStatusDiv = playStatusDiv_noSwitch;
}

#pragma mark 列表循环方法
- (void)singleLoopPlay
{
    [self valuation:self.videoArray[self.playIndex][@"videoAddr"]];
    _isPlay = YES;
    _playStatusDiv = playStatusDiv_noSwitch;
}

#pragma mark 随机播放方法
- (void)randomLoopPlay
{
    self.playIndex ++;
    if (self.playIndex > self.randomVideoArray.count) {
        self.playIndex = 0;
        //随机视频数组播放完成后再打乱一次
        self.randomVideoArray = [self.videoArray sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return (arc4random() % 3) - 1;
        }];
        _isPlay = NO;
    } else {
        _isPlay = YES;
    }
    [self valuation:self.randomVideoArray[self.playIndex][@"videoAddr"]];
    self.videoId = self.randomVideoArray[self.playIndex][@"videoId"];
    _playStatusDiv = playStatusDiv_noSwitch;
}

#pragma mark 播放视频按钮点击事件
- (void)playVideo
{
    if (self.controlView.isPlaying) {
        self.controlView.isPlaying = NO;
        [self.videoPlayer pause];
        [_playButton setImage:[UIImage imageNamed:@"play_btn"] forState:UIControlStateNormal];
        [self operationInfoRemin:@"暂停播放"];
    } else {
        self.controlView.isPlaying = YES;
        [self.videoPlayer play];
        [_playButton setImage:[UIImage imageNamed:@"pause_btn"] forState:UIControlStateNormal];
        [self operationInfoRemin:@"继续播放"];
    }
    self.hiddenTime = 0;
}

#pragma mark 全屏时上方的后退按钮的方法
- (void)exitFullScreen
{
    [_fullscreenTopView setHidden:YES];
    [self turnToPortraint];
    _playButton.frame = CGRectMake(self.originFrame.size.width - 60, self.originFrame.size.height - 60 - 50, 50, 50);
    _hiddenTime = 0;
}

#pragma mark 切换视频地址
- (void)switchVideoUrl:(NSDictionary *)videoDic indexPath:(NSIndexPath *)indexPath
{
    if (_indexPathRow != indexPath.row) {
        [_playButton setImage:[UIImage imageNamed:@"pause_btn"] forState:UIControlStateNormal];
        _playStatusDiv = playStatusDiv_switched;
        [self valuation:videoDic[@"videoAddr"]];
        self.videoId = videoDic[@"videoId"];
        _indexPathRow = indexPath.row;
        self.playIndex = indexPath.row;
        _time = 0;
        _hiddenTime = 0;
    }
}

#pragma mark 切换并播放视频
- (void)valuation:(NSString *)videoUrl
{
    self.videoUrl = videoUrl;
    AVURLAsset *asset = [AVURLAsset URLAssetWithURL:[NSURL URLWithString:videoUrl] options:nil];
    NSArray *requestedKeys = @[@"playable"];
    
    [asset loadValuesAsynchronouslyForKeys:requestedKeys completionHandler:^{
        dispatch_async(dispatch_get_main_queue(),^{
            [self prepareToPlayAsset:asset withKeys:requestedKeys];
            
        });
    }];
}

#pragma mark 操作信息提示
- (void)operationInfoRemin:(NSString *)text
{
    UIView *remindView = [[UIView alloc] initWithFrame:CGRectMake((kScreenWidth - 50)/2, 64, 50, 20)];
    remindView.backgroundColor = YYYColorA(50, 50, 50, 0.5);
    remindView.alpha = 0.0;
    
    UILabel *reminLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 50, 20)];
    reminLabel.text = text;
    reminLabel.textColor = [UIColor whiteColor];
    reminLabel.textAlignment = NSTextAlignmentCenter;
    reminLabel.font = [UIFont systemFontOfSize:12.0];
    
    [remindView addSubview:reminLabel];
    [self.view addSubview:remindView];
    
    [UIView animateWithDuration:0.7 animations:^{
        
        remindView.alpha = 1.0;
        
    } completion:^(BOOL finished) {
        
        if (finished) {
            [UIView animateWithDuration:0.7 animations:^{
                
                remindView.alpha = 0.0;
                
            } completion:^(BOOL finished) {
                
                if (finished) {
                    [remindView removeFromSuperview];
                }
            }];
        }
    }];
    
}

#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
