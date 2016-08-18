//
//  PlayVideoView.m
//  yyy
//
//  Created by TangXing on 15/10/29.
//  Copyright © 2015年 yiyinyue. All rights reserved.
//

#import "PlayVideoViewController.h"
#import "YYYPlayVideoViewController.h"
#import "YYYPlayCustomNavigationView.h"
#import "YYYPlayCustomControlView.h"
#import "YYYLoginViewController.h"
#import "SubCommentView.h"
#import "DownloadListView.h"

#import "YYYHttpTool.h"
#import "UserInfoTool.h"
#import "ProfileViewTool.h"

#import "VideoShareCell.h"
#import "UpUserViewCell.h"
#import "VideoInfoViewCell.h"
#import "RcomdViewCell.h"
#import "ComentViewCell.h"

#import "MJRefresh.h"
#import "UIImageView+WebCache.h"

#define TOPHEIGHT 30

@interface PlayVideoViewController ()

@property (strong,nonatomic) UIImageView *videoPlacehoder;
@property (strong,nonatomic) UIButton *playButton;
@property (strong,nonatomic) YYYPlayVideoViewController *videoVC;
@property (strong,nonatomic) YYYPlayCustomNavigationView *navigationView;//顶部工具条
@property (strong,nonatomic) YYYPlayCustomControlView *controlview; //底部工具条

@property (strong,nonatomic) UserSetting *userSetting;

//////////////////////////
//整个视图的大小
@property (assign) CGRect mViewFrame;
//整个视图
@property (strong,nonatomic) UIView *mView;
//下方的ScrollView
@property (strong, nonatomic) UIScrollView *scrollView;
//上方的按钮数组
@property (strong, nonatomic) NSMutableArray *topViews;
//下方的表格数组
@property (strong, nonatomic) NSMutableArray *scrollTableViews;
//下面滑动的View
@property (strong, nonatomic) UIView *slideView;
//上方的ScrollView
@property (strong, nonatomic) UIScrollView *topScrollView;
//上方的view
@property (strong, nonatomic) UIView *topMainView;
//当前选中的按钮
@property (assign,nonatomic) NSInteger currentTag;
//tableview个数
@property (assign) NSInteger tabCount;

//回复框载体
@property (strong,nonatomic) UIView *commentView;
//创建回复框
@property (retain,nonatomic) UITextView *TextViewInput;
//创建回复按钮
@property (retain,nonatomic) UIButton *btnSendComment;
//区分上下view的手势事件
@property (assign,nonatomic) BOOL splitTap;
//评论当前页
@property (strong,nonatomic) NSString *commentPage;
//是否有下一页
@property (assign,nonatomic) bool next;
//展开折叠文本
@property (assign,nonatomic) BOOL showTextState;
//cell复用判断数组
@property (strong,nonatomic) NSMutableArray *cellSelecArray;

@property (strong,nonatomic) NSMutableArray *videoHistoryArray;

@end

@implementation PlayVideoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBarHidden = YES;
    
    _userSetting = [ProfileViewTool userSetting];
    
    _isHiddenBar = NO;
    _showTextState = NO;
    _tabCount = 3;
    _topViews = [[NSMutableArray alloc] init];
    _scrollTableViews = [[NSMutableArray alloc] init];
    _mediaList = [[NSMutableArray alloc] init];
    _cellSelecArray = [[NSMutableArray alloc] init];
    _videoHistoryArray = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dic in [ProfileViewTool videoHistory].videoHistory) {
        [_videoHistoryArray addObject:dic];
    }
    
    [self loadVideoData:self.videoId];
    
    //隐藏状态栏通知
    NSNotificationCenter *hiddenBarCenter = [NSNotificationCenter defaultCenter];
    [hiddenBarCenter addObserver:self selector:@selector(hiddenBar) name:@"hiddenBar" object:nil];
    //隐藏顶部工具条通知
    NSNotificationCenter *hiddenTopViewCenter = [NSNotificationCenter defaultCenter];
    [hiddenTopViewCenter addObserver:self selector:@selector(hiddenTopView:) name:@"hiddenTopView" object:nil];
    //获取键盘的高度
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];

}

#pragma mark 加载视频数据
- (void)loadVideoData:(NSString *)videoId
{
    NSMutableDictionary *prametersVideoId = [NSMutableDictionary dictionaryWithCapacity:1];
    [prametersVideoId setObject:videoId forKey:@"videoId"];
    
    [YYYHttpTool post:YYYLoadVideoURL params:prametersVideoId success:^(id json) {
        
        _commentDic = json[@"media"];
        _reCommendArray = [json valueForKey:@"recommend"];
        _videoDic = [NSMutableDictionary dictionaryWithDictionary:json[@"video"]];
        
        [self.mediaList removeAllObjects];
        [self.cellSelecArray removeAllObjects];
        self.commentPage = self.commentDic[@"page"];
        self.next = [self.commentDic[@"next"] intValue];
        for (NSDictionary *commentDic in _commentDic[@"mediaList"]) {
            [self.mediaList addObject:commentDic];
            [self.cellSelecArray addObject:@"0"];
        }
        
        [self buildUI];
        
    } failure:^(NSError *error) {
        
        TSLog(@"loadVideoERROR___%@",error);
        
    }];
}

#pragma mark - 上半部播放界面
#pragma mark 创建界面
- (void)buildUI
{
    self.automaticallyAdjustsScrollViewInsets = NO;// 去除自偏移
    
    //初始化下方界面数据
    if (self.mView == nil) {
        _mViewFrame = CGRectMake(0, kScreenWidth * kVideoHWRatio, kScreenWidth, kScreenHeight - kScreenWidth * kVideoHWRatio);
        self.mView = [[UIView alloc] initWithFrame:_mViewFrame];
        [self.view addSubview:self.mView];
        
        [self initScrollView];
        
        [self initTopTabs];
        
        [self initDownTables];
        
        //添加评论框
        [self setupCommentBoxView];
        
        [self initSlideView];
        
        [self loadMoreData];
    }
    
    
    //创建视频播放
    if (self.videoVC) {
        self.videoVC.videoUrl = [NSString stringWithFormat:@"%@",self.videoDic[@"videoAddr"]];
        self.videoVC.videoName = self.videoDic[@"videoName"];
    } else {
        self.videoVC = [[YYYPlayVideoViewController alloc] init];
        self.videoVC.videoUrl = [NSString stringWithFormat:@"%@",self.videoDic[@"videoAddr"]];
        self.videoVC.videoName = self.videoDic[@"videoName"];
        self.videoVC.view.frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth * kVideoHWRatio);
        [self addChildViewController:self.videoVC];
        [self.view addSubview:self.videoVC.view];
    }
    
    //创建起始视频占为图
    if (self.videoPlacehoder) {
        [self.videoPlacehoder sd_setImageWithURL:self.videoDic[@"videoPreviewAddr"]];
        self.videoPlacehoder.hidden = NO;
    }else {
        self.videoPlacehoder = [[UIImageView alloc] init];
        [self.videoPlacehoder sd_setImageWithURL:self.videoDic[@"videoPreviewAddr"]];
        self.videoPlacehoder.frame = self.videoVC.view.frame;
        [self.view addSubview:self.videoPlacehoder];
    }
    //创建未全屏时视频顶部工具条
    [self setupTopView];
    
    //创建播放按钮
    if (self.playButton) {
        self.playButton.hidden = NO;
    } else {
        self.playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat playButtonX = CGRectGetMaxX(self.videoPlacehoder.frame) - 60;
        CGFloat playButtonY = CGRectGetMaxY(self.videoPlacehoder.frame) - 60;
        self.playButton.frame = CGRectMake(playButtonX, playButtonY, 50, 50);
        [self.playButton setBackgroundImage:[UIImage imageNamed:@"play_btn"] forState:UIControlStateNormal];
        [self.playButton addTarget:self action:@selector(playVideo) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:self.playButton];
        
        //创建回复框
//        [self setupCommentBoxView];
        [_scrollView addSubview:_commentView];
        self.splitTap = NO;
        
        //创建手势事件
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hiddenKeyboard:)];
        tapGestureRecognizer.cancelsTouchesInView = NO;
        [_scrollTableViews[2] addGestureRecognizer:tapGestureRecognizer];
    }
 
    [_scrollTableViews[0] reloadData];
    [_scrollTableViews[1] reloadData];
    [_scrollTableViews[2] reloadData];
    
    if (_userSetting.autoPlay) {
        [self videoHistorySave];
        
        self.videoPlacehoder.hidden = YES;
        self.playButton.hidden = YES;
        self.videoVC.controlView.isPlaying = NO;
    }
}

#pragma mark 创建视频顶部工具条
- (void)setupTopView
{
    if (_navigationView) {
        _navigationView.title.text = self.videoDic[@"videoName"];
    } else {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([YYYPlayCustomNavigationView class]) owner:nil options:nil];
        
        if (nibArray.count > 0) {
            YYYPlayCustomNavigationView *view = nibArray[0];
            view.title.text = self.videoDic[@"videoName"];
            
            [view.goBack addTarget:self action:@selector(gobackToView) forControlEvents:UIControlEventTouchUpInside];
            
            view.translatesAutoresizingMaskIntoConstraints = NO;
            [self.view addSubview:view];
            
            self.navigationView = view;
            
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
}

#pragma mark -
#pragma mark 系统方法
#pragma mark 屏幕支持方向
-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
#pragma mark 是否允许屏幕变化
- (BOOL)shouldAutorotate
{
    return NO;
}
#pragma mark 隐藏statbar
- (BOOL)prefersStatusBarHidden
{
    if (self.splitTap == YES) {
        self.splitTap = NO;
        return _isHiddenBar;
    } else {
        _isHiddenBar = !_isHiddenBar;
        if ([UIApplication sharedApplication].statusBarOrientation == 1) {
            [self.navigationView setHidden:_isHiddenBar];
            [self.controlview setHidden:_isHiddenBar];
        }
        return _isHiddenBar;
    }
    
}

#pragma mark - 通知方法
#pragma mark 控制statsbar的显示或隐藏
- (void)hiddenBar
{
    if ([UIApplication sharedApplication].statusBarOrientation != 1) {
        [self.navigationView setHidden:YES];
    }
    [self setNeedsStatusBarAppearanceUpdate];
}

#pragma mark 返回上级界面
- (void)gobackToView
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 隐藏顶部视图
- (void)hiddenTopView:(NSNotification *)dic
{
    /**
     *  UIInterfaceOrientation
     *  1.竖屏
     *  2.向左横屏
     *  3.向右横屏
     *  4.倒屏
     */
    //横屏时下方界面隐藏，否则会遮盖视频的点击事件
    if ([dic.userInfo[@"isFullscreen"] isEqualToString:@"yes"]) {
        [_mView setHidden:YES];
        [self.navigationView setHidden:YES];
    }
    else {
        [_mView setHidden:NO];
        [self.navigationView setHidden:NO];
    }
}

#pragma mark 开始播放视频
- (void)playVideo
{
    [self videoHistorySave];
    
    self.videoPlacehoder.hidden = YES;
    self.playButton.hidden = YES;
    self.videoVC.controlView.isPlaying = NO;
    NSNotification *notice = [NSNotification notificationWithName:@"playVideo" object:nil];
    [[NSNotificationCenter defaultCenter]postNotification:notice];
}

- (void)videoHistorySave
{
    for (int i = 0; i < _videoHistoryArray.count; i++) {
        NSString *videoIdHistory = _videoHistoryArray[i][@"itemId"];
        if ([_videoId isEqualToString:videoIdHistory]) {
            [_videoHistoryArray removeObjectAtIndex:i];
            break;
        }
    }
    [_videoHistoryArray addObject:[self videoHistoryDicDIY:_videoDic isPlaylist:NO]];
    NSDictionary *videoHistoryDict = @{@"videoHistory":_videoHistoryArray};
    VideoHistory *videoHistory = [VideoHistory videoHistoryWithDic:videoHistoryDict];
    [ProfileViewTool saveVideoHistory:videoHistory];
}

- (NSDictionary *)videoHistoryDicDIY:(NSDictionary *)dic isPlaylist:(BOOL)isplaylist
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    if (isplaylist) {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:dic[@"coverAddr"]]];
        
        [dictionary setObject:data forKey:@"itemPreviewAddr"];
        [dictionary setObject:dic[@"playlistId"] forKey:@"itemId"];
        [dictionary setObject:dic[@"playlistName"] forKey:@"itemName"];
    } else {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:dic[@"videoPreviewAddr"]]];
        
        [dictionary setObject:data forKey:@"itemPreviewAddr"];
        [dictionary setObject:dic[@"videoId"] forKey:@"itemId"];
        [dictionary setObject:dic[@"videoName"] forKey:@"itemName"];
    }
    [dictionary setObject:[NSNumber numberWithBool:isplaylist] forKey:@"isPlaylist"];
    
    return dictionary;
}

#pragma mark - 下半部评论简介ui
#pragma mark 初始化滑动的指示View
- (void)initSlideView
{
    CGFloat width = _mViewFrame.size.width / 3;
    
    _slideView = [[UIView alloc] initWithFrame:CGRectMake(0, TOPHEIGHT - 5, width, 5)];
    [_slideView setBackgroundColor:YYYColor(255, 102, 153)];
    [_topScrollView addSubview:_slideView];
}

#pragma mark 实例化ScrollView
- (void)initScrollView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, TOPHEIGHT, _mViewFrame.size.width, _mViewFrame.size.height - TOPHEIGHT)];
    
    _scrollView.contentSize = CGSizeMake(_mViewFrame.size.width * _tabCount, _mViewFrame.size.height - 60);
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.pagingEnabled = YES;  //开启交互
    _scrollView.canCancelContentTouches = YES;
    _scrollView.showsHorizontalScrollIndicator = FALSE; //不显示左右滑动条
    _scrollView.bounces = NO; // 去除弹簧效果
    
    _scrollView.delegate = self;
    [self.mView addSubview:_scrollView];
}

#pragma mark 实例化顶部的tab
- (void)initTopTabs
{
    CGFloat width = _mViewFrame.size.width / 3;
    
    _topMainView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _mViewFrame.size.width, TOPHEIGHT)];
    _topScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _mViewFrame.size.width, TOPHEIGHT)];
    _topScrollView.showsHorizontalScrollIndicator = NO;
    _topScrollView.showsVerticalScrollIndicator = YES;
    _topScrollView.bounces = NO;
    _topScrollView.delegate = self;
    _topScrollView.contentSize = CGSizeMake(width * _tabCount, TOPHEIGHT);
    
    [self.mView addSubview:_topMainView];
    [_topMainView addSubview:_topScrollView];
    
    [self TopTabsButtonWithButton:_infoBtn Name:@"简介" tag:0];
    [_topViews[0] setSelected:YES];
    _currentTag = 0;
    [self TopTabsButtonWithButton:_recommendBtn Name:@"相关" tag:1];
    [self TopTabsButtonWithButton:_commentBtn Name:@"评论" tag:2];
}

- (void)TopTabsButtonWithButton:(UIButton *)button Name:(NSString *)buttonName tag:(int)tag
{
    CGFloat width = _mViewFrame.size.width / 3;
    
    button = [[UIButton alloc] initWithFrame:CGRectMake(tag * width, 0, width, TOPHEIGHT)];
    button.tag = tag;
    [button setTitle:buttonName forState:UIControlStateNormal];
    [button setTitleColor:YYYColor(126,119,121) forState:UIControlStateNormal];
    [button setTitleColor:YYYColor(255, 102, 153) forState:UIControlStateSelected];
    [button addTarget:self action:@selector(tabButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [_topViews addObject:button];
    [_topScrollView addSubview:button];
}

#pragma mark 点击顶部的按钮所触发的方法
- (void)tabButton:(UIButton *)sender
{
    if (sender.selected && sender.tag == _currentTag) {
        return;
    }
    sender.selected = !sender.selected;
    _currentTag = sender.tag;
    
    [_scrollView setContentOffset:CGPointMake(sender.tag * _mViewFrame.size.width, 0) animated:YES];
}

#pragma mark 初始化下方的TableView
- (void)initDownTables
{
    for (int i = 0; i <= 2;  i++) {
        
        UITableView *tableView = [[UITableView alloc] init];
        if (i == 2) {
            [tableView setFrame:CGRectMake(i * _mViewFrame.size.width, 0, _mViewFrame.size.width, _mViewFrame.size.height - TOPHEIGHT - 40)];
//            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        } else {
            [tableView setFrame:CGRectMake(i * _mViewFrame.size.width, 0, _mViewFrame.size.width, _mViewFrame.size.height - TOPHEIGHT)];
        }
        tableView.delegate = self;
        tableView.dataSource = self;
        tableView.tag = i;
        tableView.backgroundColor = YYYColor(240, 240, 240);
        [_scrollTableViews addObject:tableView];
        [_scrollView addSubview:tableView];
        
    }
}

#pragma mark - scrollView的代理方法
- (void)modifyScrollViewPositing:(UIScrollView *)scrollVeiw
{
    if ([_topScrollView isEqual:scrollVeiw]) {
        CGFloat contentOffsetX = _topScrollView.contentOffset.x;
        
        CGFloat width = _slideView.frame.size.width;
        
        int count = (int)contentOffsetX/(int)width;
        
        CGFloat step = (int)contentOffsetX%(int)width;
        
        CGFloat sumStep = width * count;
        
        if (step > width/2) {
            sumStep = width * (count + 1);
        }
        
        [_topScrollView setContentOffset:CGPointMake(sumStep, 0) animated:YES];
        return;
    }
    
}

//拖拽后调用的方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self modifyScrollViewPositing:scrollView];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if ([_scrollView isEqual:scrollView]) {
        CGRect frame = _slideView.frame;
        
        frame.origin.x = scrollView.contentOffset.x/_tabCount;
        
        _slideView.frame = frame;
        
        CGFloat buttonWidth = self.mView.frame.size.width/3;
        CGFloat offsetX = buttonWidth/5;
        
        _infoBtn = _topViews[0];
        _recommendBtn = _topViews[1];
        _commentBtn = _topViews[2];
        
        if (_slideView.origin.x <= buttonWidth) {
            
            if (frame.origin.x <= offsetX) {
                _infoBtn.titleLabel.textColor = YYYColor(255, 102, 153);
                _recommendBtn.titleLabel.textColor = YYYColor(126,119,121);
                _currentTag = 0;
            } else if (frame.origin.x <= offsetX * 2 && frame.origin.x >= offsetX){
                _infoBtn.titleLabel.textColor = YYYColor(215, 107, 143);
                _recommendBtn.titleLabel.textColor = YYYColor(161,114,130);
            } else if (frame.origin.x <= offsetX * 3 && frame.origin.x >= offsetX *2) {
                _infoBtn.titleLabel.textColor = YYYColor(186, 111, 136);
                _recommendBtn.titleLabel.textColor = YYYColor(186, 111, 136);
            } else if (frame.origin.x <= offsetX * 4 && frame.origin.x >= offsetX *3) {
                _infoBtn.titleLabel.textColor = YYYColor(161,114,130);
                _recommendBtn.titleLabel.textColor = YYYColor(215, 107, 143);
            } else {
                _infoBtn.titleLabel.textColor = YYYColor(126,119,121);
                _recommendBtn.titleLabel.textColor = YYYColor(255, 102, 153);
                _currentTag = 1;
            }
            
        } else if (_slideView.origin.x <= buttonWidth * 2 && _slideView.origin.x >= buttonWidth) {
            if (frame.origin.x - buttonWidth<= offsetX) {
                _recommendBtn.titleLabel.textColor = YYYColor(255, 102, 153);
                _commentBtn.titleLabel.textColor = YYYColor(126,119,121);
                _currentTag = 1;
            } else if (frame.origin.x - buttonWidth <= offsetX * 2 && frame.origin.x >= offsetX){
                _recommendBtn.titleLabel.textColor = YYYColor(215, 107, 143);
                _commentBtn.titleLabel.textColor = YYYColor(161,114,130);
            } else if (frame.origin.x - buttonWidth <= offsetX * 3 && frame.origin.x >= offsetX *2) {
                _recommendBtn.titleLabel.textColor = YYYColor(186, 111, 136);
                _commentBtn.titleLabel.textColor = YYYColor(186, 111, 136);
            } else if (frame.origin.x - buttonWidth <= offsetX * 4 && frame.origin.x >= offsetX *3) {
                _recommendBtn.titleLabel.textColor = YYYColor(161,114,130);
                _commentBtn.titleLabel.textColor = YYYColor(215, 107, 143);
            } else {
                _recommendBtn.titleLabel.textColor = YYYColor(126,119,121);
                _commentBtn.titleLabel.textColor = YYYColor(255, 102, 153);
                _currentTag = 2;
            }
        }
    }
}

#pragma mark tableview的代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView.tag == 0) {
        return 3;
    } else if (tableView.tag == 1) {
        return _reCommendArray.count;
    } else if (tableView.tag == 2){
        if (self.mediaList.count > 0) {
            tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
            return self.mediaList.count;
        } else {
            tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
            return 0;
        }
    }
    return 1;
}

//设置tableview的高度自动获取
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

//初始加载tableviewcell时，给出预估高度
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIImageView *iconImage = [[UIImageView alloc] init];
    
    BOOL nibRegistered = NO;
    if (!nibRegistered) {
        UINib *upUserNib = [UINib nibWithNibName:@"UpUserViewCell" bundle:nil];
        [tableView registerNib:upUserNib forCellReuseIdentifier:@"UpUserCell"];
        
        UINib *videoInfoNib = [UINib nibWithNibName:@"VideoInfoViewCell" bundle:nil];
        [tableView registerNib:videoInfoNib forCellReuseIdentifier:@"VideoInfoCell"];
        
        UINib *shareNib = [UINib nibWithNibName:@"VideoShareCell" bundle:nil];
        [tableView registerNib:shareNib forCellReuseIdentifier:@"ShareCell"];
        
        UINib *rcomdNib = [UINib nibWithNibName:@"RcomdViewCell" bundle:nil];
        [tableView registerNib:rcomdNib forCellReuseIdentifier:@"RcomdCell"];
        
        UINib *comentNib = [UINib nibWithNibName:@"ComentViewCell" bundle:nil];
        [tableView registerNib:comentNib forCellReuseIdentifier:@"ComentCell"];
        
        nibRegistered = YES;
    }
    
    if (tableView.tag == 0 && _videoDic != nil) {//视频简介的tableview
        if (indexPath.row == 0) {
            VideoShareCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShareCell"];
            cell.shareCountLabel.text = [NSString stringWithFormat:@"%@",_videoDic[@"shareCount"]];
            cell.favoriteCountLabel.text = [NSString stringWithFormat:@"%@",_videoDic[@"favoriteCount"]];
            cell.likeCountLabel.text = [NSString stringWithFormat:@"%@",_videoDic[@"likeCount"]];
            cell.downloadCountLabel.text = [NSString stringWithFormat:@"%@",_videoDic[@"downloadCount"]];
            [cell.shareBtn addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.favoriteBtn addTarget:self action:@selector(favoriteClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.likeBtn addTarget:self action:@selector(likeClick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.downloadBtn addTarget:self action:@selector(downloadClick:) forControlEvents:UIControlEventTouchUpInside];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else if (indexPath.row == 1) {
            UpUserViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UpUserCell"];
            [iconImage sd_setImageWithURL:_videoDic[@"uploadUserPhoto"]];
            cell.upUserPhoto.image = [self scaleImageSize:CGSizeMake(50, 50) image:iconImage];
            cell.upUserName.text = _videoDic[@"uploadUserName"];
            cell.upLoadTime.text = _videoDic[@"uploadTimeView"];
            cell.upUserPhoto.layer.masksToBounds = YES;
            cell.upUserPhoto.layer.cornerRadius = cell.upUserPhoto.bounds.size.width/2;
            bool followBool = [_videoDic[@"uploadUserFollowed"] integerValue];
            if (followBool) {
                cell.follow.hidden = YES;
                cell.followed.hidden = NO;
            } else {
                cell.follow.hidden = NO;
                cell.followed.hidden = YES;
            }
            [cell.follow addTarget:self action:@selector(followAddCilick:) forControlEvents:UIControlEventTouchUpInside];
            [cell.followed addTarget:self action:@selector(followCancelCilick:) forControlEvents:UIControlEventTouchUpInside];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else if (indexPath.row == 2) {
            VideoInfoViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoInfoCell"];
            cell.videoName.text = _videoDic[@"videoName"];
            cell.playCount.text = _videoDic[@"playCount"];
            cell.comentCount.text = _videoDic[@"commentCount"];
            if (_showTextState == YES) {
                cell.videoInfo.numberOfLines = 0;
                cell.videoInfo.lineBreakMode = NSLineBreakByClipping;
            } else {
                cell.videoInfo.text = [self decodeFromHTML:_videoDic[@"videoIntroduction"]];
            }
            [cell.showMore addTarget:self action:@selector(showMoreText:) forControlEvents:UIControlEventTouchUpInside];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
    else if (tableView.tag == 1 && _reCommendArray != nil) {//推荐视频的tableview
        RcomdViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RcomdCell"];
        [cell.videoImg sd_setImageWithURL:_reCommendArray[indexPath.row][@"videoPreviewAddr"]];
        cell.videoImg.layer.masksToBounds = YES;
        cell.videoImg.layer.cornerRadius = 5;
        cell.title.text = _reCommendArray[indexPath.row][@"videoName"];
        cell.userName.text = _reCommendArray[indexPath.row][@"userName"];
        cell.playCount.text = _reCommendArray[indexPath.row][@"playCount"];
        cell.comentCount.text = _reCommendArray[indexPath.row][@"commentCount"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (tableView.tag == 2 && self.mediaList != nil) {//视频评论的tableview
        ComentViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ComentCell"];
        [iconImage sd_setImageWithURL:self.mediaList[indexPath.row][@"userPhoto"]];
        cell.icon.image = [self scaleImageSize:CGSizeMake(40, 40) image:iconImage];
        cell.icon.layer.masksToBounds = YES;
        cell.icon.layer.cornerRadius = cell.icon.bounds.size.width/2;
        cell.userName.text = self.mediaList[indexPath.row][@"userName"];
        cell.floor.text = self.mediaList[indexPath.row][@"floor"];
        cell.timeView.text = self.mediaList[indexPath.row][@"timeView"];
        cell.coment.text = [self decodeFromHTML:self.mediaList[indexPath.row][@"content"]];
        
        if ([self.mediaList[indexPath.row][@"subMediaCount"] integerValue] > 0) {
            NSString *subMediaCount = [NSString stringWithFormat:@"%@",self.mediaList[indexPath.row][@"subMediaCount"]];
            [cell.subMediaCount setTitle:subMediaCount forState:UIControlStateNormal];
            cell.subMediaCount.hidden = NO;
        } else {
            cell.subMediaCount.hidden = YES;
        }
        
        cell.supportCount.tag = indexPath.row;
        NSString *supportCount = [NSString stringWithFormat:@"%@",self.mediaList[indexPath.row][@"supportCount"]];
        [cell.supportCount addTarget:self action:@selector(supportCountAdd:) forControlEvents:UIControlEventTouchUpInside];
        
        if ([self.cellSelecArray[indexPath.row] integerValue] == 0) {
            [cell.supportCount setTitle:supportCount forState:UIControlStateNormal];
            [cell.supportCount setImage:[UIImage imageNamed:@"support"] forState:UIControlStateNormal];
            cell.supportCount.selected = NO;
        } else {
            [cell.supportCount setTitle:[NSString stringWithFormat:@"%@",self.cellSelecArray[indexPath.row]] forState:UIControlStateSelected];
            [cell.supportCount setImage:[UIImage imageNamed:@"supported"] forState:UIControlStateSelected];
            cell.supportCount.selected = YES;
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    static NSString *identifer = @"normalCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifer];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifer];
    }
    cell.textLabel.text = @"没有";
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView.tag == 1) {
        self.videoId = _reCommendArray[indexPath.row][@"videoId"];
//        [self.videoVC removeTimeObserverAndNSNotification];
//        [self.videoVC viewWillDisappear:YES];
        [self loadVideoData:self.videoId];
    } else if (tableView.tag == 2) {
        self.splitTap = NO;
        SubCommentView *subCommentView = [[SubCommentView alloc] init];
        subCommentView.mediaIndex = indexPath.row;
        subCommentView.timestamp = _mediaList[indexPath.row][@"timestamp"];
        subCommentView.videoId = _videoId;
        subCommentView.selectedMedia = _mediaList[indexPath.row];
        [self.navigationController pushViewController:subCommentView animated:YES];
    }
}

#pragma mark - textview的代理方法
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{//将要开始编辑
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{//将要结束编辑
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{//开始编辑
    
}

- (void)textViewDidEndEditing:(UITextView *)textView
{//结束编辑
    _commentView.frame = CGRectMake(2*kScreenWidth, _scrollView.frame.size.height - 40, kScreenWidth, 40);
}

#pragma mark - 上拉刷新下拉加载
-(void)loadMoreData
{
    //视频简介的tableview
    UITableView *commentTableview = self.scrollTableViews[0];
    
    //给视频简介添加footerview去除多余线条
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [commentTableview setTableFooterView:view];
    
    //评论的tableview
    commentTableview = self.scrollTableViews[2];
    
    commentTableview.header=[MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        NSDictionary *prametersRefish = [[NSDictionary alloc] init];
        prametersRefish = [NSDictionary dictionaryWithObjectsAndKeys:self.videoId,@"mediaId",@"1",@"pageButton",nil];
        
        [YYYHttpTool post:YYYMediaPagingURL params:prametersRefish success:^(id json) {
            
            self.commentPage = json[@"page"];
            self.next = [json[@"next"] intValue];
            NSArray *array = json[@"mediaList"];
            [self.mediaList removeAllObjects];
            [self.cellSelecArray removeAllObjects];
            for (NSDictionary *commentDic in array) {
                [self.mediaList addObject:commentDic];
                [self.cellSelecArray addObject:@"0"];
            }
            [commentTableview reloadData];
            [commentTableview.header endRefreshing];
            
        } failure:^(NSError *error) {
            [commentTableview.header endRefreshing];
        }];

    }];
    
    if (self.next) {
        commentTableview.footer=[MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            if (self.next) {
                NSDictionary *prametersMediapaging = [[NSDictionary alloc] init];
                prametersMediapaging = [NSDictionary dictionaryWithObjectsAndKeys:self.videoId,@"mediaId",@"下页",@"pageButton",self.commentPage,@"page",nil];
              
                [YYYHttpTool post:YYYMediaPagingURL params:prametersMediapaging success:^(id json) {
                    
                    NSDictionary *mediaComent = json;
                    self.commentPage = mediaComent[@"page"];
                    self.next = [mediaComent[@"next"] intValue];
                    NSArray *array = [mediaComent valueForKey:@"mediaList"];
                    
                    for (NSDictionary *comentDic in array) {
                        [self.mediaList addObject:comentDic];
                        [self.cellSelecArray addObject:@"0"];
                    }
                    
                    [commentTableview reloadData];
                    [commentTableview.footer endRefreshing];
                    
                } failure:^(NSError *error) {
                    [commentTableview.footer endRefreshing];
                }];
            } else {
                [commentTableview.footer endRefreshing];
            }
        }];
    } else {
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = [UIColor clearColor];
        [commentTableview setTableFooterView:view];
    }
}

#pragma mark 展开折叠文本
- (void)showMoreText:(UIButton *)sender
{
    _showTextState = YES;
    [_scrollTableViews[0] reloadData];
    [sender removeFromSuperview];
}

#pragma mark 支持数按钮事件
- (void)supportCountAdd:(UIButton *)sender
{
    NSDictionary *prametersSupport = [[NSDictionary alloc] init];
    prametersSupport = [NSDictionary dictionaryWithObjectsAndKeys:self.videoId,@"mediaId",
                                                                  self.mediaList[sender.tag][@"timestamp"],@"timestamp",
                                                                  [UserInfoTool userInfo].userId,@"supportUserId",
                                                                  [NSNumber numberWithInteger:sender.tag],@"mediaIndex",nil];
    
    [YYYHttpTool post:YYYMediaSupportURL params:prametersSupport success:^(id json) {
        
        int supportCount =[json[@"supportCount"] intValue];
        self.cellSelecArray[sender.tag] = json[@"supportCount"];
        [sender setTitle:[NSString stringWithFormat:@"%d",supportCount] forState:UIControlStateSelected];
        [sender setImage:[UIImage imageNamed:@"supported"] forState:UIControlStateSelected];
        sender.selected = YES;
        
    } failure:^(NSError *error) {
        TSLog(@"hey man");
    }];
}

#pragma mark 创建回复输入框
- (void)setupCommentBoxView
{
    //创建回复框载体
    _commentView = [[UIView alloc] initWithFrame:CGRectMake(2 * kScreenWidth, _scrollView.frame.size.height - 40, kScreenWidth, 40)];
    _commentView.backgroundColor = [UIColor whiteColor];
    
    //输入框
    self.TextViewInput = [[UITextView alloc] initWithFrame:CGRectMake(10, 5, kScreenWidth - 70, 30)];
    self.TextViewInput.layer.cornerRadius = 4;
    self.TextViewInput.layer.masksToBounds = YES;
    self.TextViewInput.delegate = self;
    self.TextViewInput.layer.borderWidth = 1;
    self.TextViewInput.layer.borderColor = [[[UIColor lightGrayColor] colorWithAlphaComponent:0.4] CGColor];
    [_commentView addSubview:self.TextViewInput];
    
    //发送消息
    self.btnSendComment = [UIButton buttonWithType:UIButtonTypeCustom];
    self.btnSendComment.frame = CGRectMake(CGRectGetMaxX(self.TextViewInput.frame) + 10, 5, 40, 30);
    [self.btnSendComment setTitle:@"Send" forState:UIControlStateNormal];
    [self.btnSendComment setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    self.btnSendComment.titleLabel.font = [UIFont systemFontOfSize:12];
    [self.btnSendComment addTarget:self action:@selector(sendComment:) forControlEvents:UIControlEventTouchUpInside];
    [_commentView addSubview:self.btnSendComment];
}

#pragma mark 发送回复
- (void)sendComment:(UIButton *)sender
{
    UserInfo *userInfo = [UserInfoTool userInfo];
    self.splitTap = YES;
    if (userInfo.userId == nil) {
        
        UIAlertView *logoutAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"请先登录.\n_(:з)∠)_" delegate:self cancelButtonTitle:@"不登录" otherButtonTitles:@"登录", nil];
        [logoutAlert show];
        
    } else {
        
        NSDictionary *prameters = [[NSDictionary alloc] init];
        prameters = [NSDictionary dictionaryWithObjectsAndKeys:self.videoId,@"mediaId",self.TextViewInput.text,@"content",userInfo.userId,@"userId",nil];
        
        [YYYHttpTool post:YYYMediaAddURL params:prameters success:^(id json) {
            
            self.commentDic = json;
            self.TextViewInput.text = @"";
            [self.TextViewInput resignFirstResponder];
            self.commentPage = self.commentDic[@"page"];
            self.next = [self.commentDic[@"next"] intValue];
            [self.mediaList removeAllObjects];
            [self.cellSelecArray removeAllObjects];
            for (NSDictionary *commentDic in _commentDic[@"mediaList"]) {
                [self.mediaList addObject:commentDic];
                [self.cellSelecArray addObject:@"0"];
            }
            [_scrollTableViews[2] reloadData];
            
        } failure:^(NSError *error) {
            TSLog(@"Hey Man");
        }];
    }
    _commentView.frame = CGRectMake(2*kScreenWidth, _scrollView.frame.size.height - 40, kScreenWidth, 40);
}

#pragma mark 屏幕点击事件
- (void)hiddenKeyboard:(UITapGestureRecognizer *)tap {
    self.splitTap = YES;
    [self.TextViewInput resignFirstResponder];
    _commentView.frame = CGRectMake(2*kScreenWidth, _scrollView.frame.size.height - 40, kScreenWidth, 40);
}

#pragma mark 分享视频事件
- (void)shareClick:(UIButton *)sender
{
    TSLog(@"我分享啦");
}


#pragma mark 收藏视频事件
- (void)favoriteClick:(UIButton *)sender
{
    UserInfo *userInfo = [UserInfoTool userInfo];
    
    if (userInfo.userId == nil) {
        
        UIAlertView *logoutAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"请先登录.\n_(:з)∠)_" delegate:self cancelButtonTitle:@"不登录" otherButtonTitles:@"登录", nil];
        [logoutAlert show];
        
    } else {
        
        NSDictionary *prameters = [[NSDictionary alloc] init];
        prameters = [NSDictionary dictionaryWithObjectsAndKeys:self.videoId,@"videoId",userInfo.userId,@"userId",nil];
        
        [YYYHttpTool post:YYYFavoriteAddURL params:prameters success:^(id json) {
            
            bool success = [json[@"added"] integerValue];
            if (success) {
                [_videoDic setObject:json[@"favoriteCount"] forKey:@"favoriteCount"];
                [_scrollTableViews[0] reloadData];
            }
            
        } failure:^(NSError *error) {
            TSLog(@"hey,man");
        }];
    }
}

#pragma mark 点赞视频事件
- (void)likeClick:(UIButton *)sender
{
    UserInfo *userInfo = [UserInfoTool userInfo];
    
    if (userInfo.userId == nil) {
        
        UIAlertView *logoutAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"请先登录.\n_(:з)∠)_" delegate:self cancelButtonTitle:@"不登录" otherButtonTitles:@"登录", nil];
        [logoutAlert show];
        
    } else {
        
        NSDictionary *prameters = [[NSDictionary alloc] init];
        prameters = [NSDictionary dictionaryWithObjectsAndKeys:self.videoId,@"videoId",userInfo.userId,@"userId",nil];
        
        [YYYHttpTool post:YYYLikeAddURL params:prameters success:^(id json) {
            
            bool success = [json[@"added"] integerValue];
            if (success) {
                [_videoDic setObject:json[@"likeCount"] forKey:@"likeCount"];
                [_scrollTableViews[0] reloadData];
            }
            
        } failure:^(NSError *error) {
            TSLog(@"hey,man");
        }];
    }
}

#pragma mark 下载视频事件
- (void)downloadClick:(UIButton *)sender
{
    DownloadListView *downloadView = [[DownloadListView alloc] init];
    
    downloadView.dataDict = _videoDic;
    
    [self addChildViewController:downloadView];
    [self.view addSubview:downloadView.view];
}

#pragma mark 用户关注添加事件
- (void)followAddCilick:(UIButton *)sender
{
    UserInfo *userInfo = [UserInfoTool userInfo];
    
    if (userInfo.userId == nil) {
        
        UIAlertView *logoutAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"请先登录.\n_(:з)∠)_" delegate:self cancelButtonTitle:@"不登录" otherButtonTitles:@"登录", nil];
        [logoutAlert show];
        
    } else {
        
        NSDictionary *prameters = [[NSDictionary alloc] init];
        prameters = [NSDictionary dictionaryWithObjectsAndKeys:_videoDic[@"uploadUserId"],@"followedUserId",userInfo.userId,@"userId",nil];
        
        [YYYHttpTool post:YYYFollowAddURL params:prameters success:^(id json) {
            
            bool success = [json[@"added"] integerValue];
            if (success) {
                [_videoDic setObject:@"1" forKey:@"uploadUserFollowed"];
                [_scrollTableViews[0] reloadData];
            }
            
        } failure:^(NSError *error) {
            TSLog(@"hey,man");
        }];
    }
}

#pragma mark 用户关注取消事件
- (void)followCancelCilick:(UIButton *)sender
{
    UserInfo *userInfo = [UserInfoTool userInfo];
    
    if (userInfo.userId == nil) {
        
        UIAlertView *logoutAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"请先登录.\n_(:з)∠)_" delegate:self cancelButtonTitle:@"不登录" otherButtonTitles:@"登录", nil];
        [logoutAlert show];
        
    } else {
        
        NSDictionary *prameters = [[NSDictionary alloc] init];
        prameters = [NSDictionary dictionaryWithObjectsAndKeys:_videoDic[@"uploadUserId"],@"followedUserId",userInfo.userId,@"userId",nil];
        
        [YYYHttpTool post:YYYFollowCancelURL params:prameters success:^(id json) {
            
            bool success = [json[@"canceled"] integerValue];
            if (success) {
                [_videoDic setObject:@"0" forKey:@"uploadUserFollowed"];
                [_scrollTableViews[0] reloadData];
            }
            
        } failure:^(NSError *error) {
            TSLog(@"hey,man");
        }];
    }
}

#pragma mark 评论解码
- (NSString *)decodeFromHTML:(NSArray *)array
{
    NSString *coment = [array componentsJoinedByString:@"\n"];
    
    coment = [coment stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"];
    coment = [coment stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    coment = [coment stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    coment = [coment stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    coment = [coment stringByReplacingOccurrencesOfString:@"&#39;" withString:@"'"];
    coment = [coment stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    coment = [coment stringByReplacingOccurrencesOfString:@"&#92;" withString:@"\\"];
    
    return coment;
}

#pragma mark 头像缩放
- (UIImage *)scaleImageSize:(CGSize)size image:(UIImageView *)imageView
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 2.0);
    [imageView.image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *scaleImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaleImage;
}

#pragma mark 获取键盘高度
- (void)keyboardWillShow:(NSNotification *)aNotification
{
    NSDictionary *userInfoDic = [aNotification userInfo];
    
    //动画持续时间
    double duration = [userInfoDic[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    //键盘的frame
    CGRect keyboardF = [userInfoDic[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    
    float offset = _scrollView.frame.size.height - 40 - keyboardF.size.height;
    
    [UIView animateWithDuration:duration animations:^{
        _commentView.frame = CGRectMake(2*kScreenWidth, offset, self.view.frame.size.width, 40);
    }];
}

#pragma mark AlertView监听方法
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        //进入登陆界面
        YYYLoginViewController *loginVC = [[YYYLoginViewController alloc] init];
        loginVC.registState = NO;
        [self presentViewController:loginVC animated:YES completion:nil];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [_TextViewInput resignFirstResponder];
    _commentView.frame = CGRectMake(2*kScreenWidth, _scrollView.frame.size.height - 40, kScreenWidth, 40);
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"hiddenBar" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"hiddenTopView" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillShowNotification object:nil];
}

@end
