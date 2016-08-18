//
//  PlaylistController.m
//  yyy
//
//  Created by TangXing on 16/2/25.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import "PlaylistController.h"
#import "PlaylistCollectionViewController.h"
//#import "PellTableViewSelect.h"

#import "YYYHttpTool.h"
#import "MJRefresh.h"

#define Height 50

@interface PlaylistController ()

@property (strong,nonatomic) UIScrollView *segmentView;//标签的滑动view
@property (strong,nonatomic) UIButton *pullDownBtn;//下拉按钮

@property (strong,nonatomic) NSArray *playlistData;//歌单信息数组
@property (strong,nonatomic) NSMutableArray *dataSource;//标签数据源
@property (strong,nonatomic) NSMutableArray *buttonArray;//按钮数组

@property (strong,nonatomic) PlaylistCollectionViewController *playlistCollectionView;//显示歌单的collectionview

@property (strong,nonatomic) NSString *sortDiv;//排序区分
@property (assign,nonatomic) BOOL singleLine;//是否单行
@property (assign,nonatomic) NSInteger currentButtonTag;
@property (assign,nonatomic) bool next;//是否有下一页
@property (strong,nonatomic) NSString *page;//记录当前页

@end

@implementation PlaylistController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"歌单";
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(sortPlaylist) image:@"sort" highImage:@"sort"];
    
    _dataSource = [[NSMutableArray alloc] init];
    _buttonArray = [[NSMutableArray alloc] init];
    _singleLine = YES;
    _currentButtonTag = 0;
    
    [YYYHttpTool post:YYYPlaylisthomeURL params:nil success:^(id json) {

        _next = [json[@"playlist"][@"next"] intValue];
        _page = json[@"playlist"][@"page"];
        _sortDiv = json[@"playlist"][@"sortDiv"];
        _playlistData = json[@"playlist"][@"playlistList"];
        
        NSDictionary *allDic = [NSDictionary dictionaryWithObjectsAndKeys:@"",@"key",@"全部",@"value",nil];
        [_dataSource addObject:allDic];
        
        NSArray *tagArray = json[@"tagList"];
        for (int i = 0; i < tagArray.count; i++) {
            NSArray *cacheTagArray = tagArray[i][@"tagList"];
            for (int j = 0; j < cacheTagArray.count; j++) {
                [_dataSource addObject:cacheTagArray[j]];
            }
        }
        
        [self buildUI];
        
    } failure:^(NSError *error) {
        TSLog(@"PlaylistHome %@",error);
    }];
    
}

#pragma mark 创建标签选择scrollview
- (void)buildUI
{
    //标签滑动的view
    _segmentView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth - Height, Height)];
    _segmentView.backgroundColor = YYYColorA(225, 225, 225, 0.9);
    _segmentView.showsHorizontalScrollIndicator = false;
    _segmentView.showsVerticalScrollIndicator = false;
    _segmentView.bounces = NO;
    _segmentView.contentSize = [self calButtonWidthByStringWidth];
    
    //下拉按钮
    _pullDownBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_pullDownBtn setTitle:@"V" forState:UIControlStateNormal];
    [_pullDownBtn setTitleColor:YYYColor(80, 193, 233) forState:UIControlStateNormal];
    [_pullDownBtn setBackgroundColor:YYYColorA(225, 225, 225, 0.9)];
    [_pullDownBtn setFrame:CGRectMake(kScreenWidth - Height, 0, Height, Height)];
    [_pullDownBtn addTarget:self action:@selector(pullDownScrollView) forControlEvents:UIControlEventTouchUpInside];

    //显示歌单的collectionview
    _playlistCollectionView = [[PlaylistCollectionViewController alloc] init];
    [_playlistCollectionView.collectionView setBackgroundColor:[UIColor whiteColor]];
    [_playlistCollectionView.collectionView setFrame:CGRectMake(0, Height,kScreenWidth,kScreenHeight - Height)];
    
    //给collection传值
    _playlistCollectionView.sortDiv = _sortDiv;
    [_playlistCollectionView.playlistData addObjectsFromArray:_playlistData];
    
    //集成刷新控件
    [self addHeader:_currentButtonTag];
    [self addFooter];
    
    [self addChildViewController:_playlistCollectionView];
    [self.view addSubview:_playlistCollectionView.collectionView];
    [self.view addSubview:_segmentView];
    [self.view addSubview:_pullDownBtn];
}

#pragma mark 下拉刷新
- (void)addHeader:(NSInteger)currentButtonTag
{
    _playlistCollectionView.collectionView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self loadPlaylistData:currentButtonTag];
        [_playlistCollectionView.collectionView.header endRefreshing];
        
    }];
    
    [_playlistCollectionView.collectionView.header beginRefreshing];
}

#pragma mark 上拉加载
- (void)addFooter
{
    if (_next) {
        _playlistCollectionView.collectionView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
           
            NSDictionary *params;
            if (_currentButtonTag == 0) {
                params = [NSDictionary dictionaryWithObjectsAndKeys:@"下页",@"button",_sortDiv,@"sortDiv",_page,@"page",nil];
            } else {
                params = [NSDictionary dictionaryWithObjectsAndKeys:_dataSource[_currentButtonTag][@"key"],@"tags",@"下页",@"button",_sortDiv,@"sortDiv",_page,@"page",nil];
            }
            
            if (_next) {
                [YYYHttpTool post:YYYPlaylisthomeURL params:params success:^(id json) {
                    
                    _next = [json[@"playlist"][@"next"] intValue];
                    _page = json[@"playlist"][@"page"];
                    _sortDiv = json[@"playlist"][@"sortDiv"];
                    
                    for (NSDictionary *dic in json[@"playlist"][@"playlistList"]) {
                        [_playlistCollectionView.playlistData addObject:dic];
                    }
                    
                    [_playlistCollectionView.collectionView reloadData];
                    [_playlistCollectionView.collectionView.footer endRefreshing];
                    
                } failure:^(NSError *error) {
                    TSLog(@"FooterRefresh %@",error);
                }];
            } else {
                [_playlistCollectionView.collectionView.footer endRefreshingWithNoMoreData];
            }
            
        }];
    }
}

#pragma mark 标签button点击事件
- (void)handleclick:(UIButton *)button
{
    if (!_singleLine) {
        [self pullUpScrollView];
    }
    
    if (_currentButtonTag != button.tag)
    {
        [self addHeader:button.tag];
    }
    _currentButtonTag = button.tag;
    
    UIButton *offsetButton = [[UIButton alloc] init];
    
    for (int i = 0; i < _buttonArray.count; i++) {//先把所有button置为初始状态
        offsetButton = _buttonArray[i];
        [offsetButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        offsetButton.layer.borderColor = YYYColor(204, 204, 204).CGColor;
    }
    
    offsetButton = _buttonArray[button.tag];
    [offsetButton setTitleColor:YYYColor(80, 193, 233) forState:UIControlStateNormal];
    offsetButton.layer.borderColor = YYYColor(80, 193, 233).CGColor;
    
    CGFloat offsetX = offsetButton.origin.x;
    CGFloat MAXoffsetX = _segmentView.contentSize.width - kScreenWidth + Height + 10;
    
    if (MAXoffsetX < offsetX) {
        offsetX = MAXoffsetX;
    }
    
    [_segmentView setContentOffset:CGPointMake(offsetX - 10, 0) animated:YES];
}

#pragma mark 加载歌单数据
- (void)loadPlaylistData:(NSInteger)tag
{
    NSDictionary *params;
    if (tag == 0) {
        params = [NSDictionary dictionaryWithObjectsAndKeys:@"确定",@"button",_sortDiv,@"sortDiv",_page,@"page",nil];
    } else {
        params = [NSDictionary dictionaryWithObjectsAndKeys:_dataSource[tag][@"key"],@"tags",@"确定",@"button",_sortDiv,@"sortDiv",_page,@"page",nil];
    }
    
    [YYYHttpTool post:YYYPlaylisthomeURL params:params success:^(id json) {
        
        _next = [json[@"playlist"][@"next"] intValue];
        _page = json[@"playlist"][@"page"];
        _sortDiv = json[@"playlist"][@"sortDiv"];
        _playlistCollectionView.sortDiv = _sortDiv;
        
        [_playlistCollectionView.playlistData removeAllObjects];
        for (NSDictionary *dict in json[@"playlist"][@"playlistList"]) {
            [_playlistCollectionView.playlistData addObject:dict];
        }
        
        [_playlistCollectionView.collectionView.footer removeFromSuperview];
        [self addFooter];
        [_playlistCollectionView.collectionView reloadData];
        
    } failure:^(NSError *error) {
        
        TSLog(@"TagPOST %@",error);
    }];
}

#pragma mark 排序点击事件
- (void)sortPlaylist
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *normalSortAction = [UIAlertAction actionWithTitle:@"按默认排序" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        // 给定义的全局变量赋值
        if (![self.sortDiv isEqualToString:PLAYLIST_SORT_TIME]) {
            self.sortDiv = PLAYLIST_SORT_TIME;
            [self addHeader:_currentButtonTag];
        }
    }];
    // 添加收藏排序按钮
    UIAlertAction *favoriteSortAction = [UIAlertAction actionWithTitle:@"按收藏排序" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        if (![self.sortDiv isEqualToString:PLAYLIST_SORT_FAVORITE_COUNT]) {
            self.sortDiv = PLAYLIST_SORT_FAVORITE_COUNT;
            [self addHeader:_currentButtonTag];
        }
    }];
    // 添加点赞排序按钮
    UIAlertAction *likeSortAction = [UIAlertAction actionWithTitle:@"按点赞排序" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        if (![self.sortDiv isEqualToString:PLAYLIST_SORT_LIKE_COUNT]) {
            self.sortDiv = PLAYLIST_SORT_LIKE_COUNT;
            [self addHeader:_currentButtonTag];
        }
    }];
    
    [alertController addAction:normalSortAction];
    [alertController addAction:favoriteSortAction];
    [alertController addAction:likeSortAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
//    TSLog(@"%@",NSStringFromCGRect(butt.frame));
//    [PellTableViewSelect addPellTableViewSelectWithWindowFrame:CGRectMake(370, 10, 150, 200) selectData:@[@"默认排序",@"收藏排序",@"点赞排序"]  images:@[@"sort",@"sort",@"sort"] action:^(NSInteger index) {
//        
//        TSLog(@"hello world");
//        
//    } animated:YES];
}

#pragma mark 下拉弹出标签视图
- (void)pullDownScrollView
{
    [UIView animateWithDuration:0.1 animations:^{
       
        _segmentView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 200);
        _pullDownBtn.frame = CGRectMake(0, kScreenHeight - 200, kScreenWidth, Height);
        
    }];
    
    _segmentView.contentSize = [self getScrollViewContentSize:NO];
    [_pullDownBtn setTitle:@"^" forState:UIControlStateNormal];
    [_pullDownBtn addTarget:self action:@selector(pullUpScrollView) forControlEvents:UIControlEventTouchUpInside];
    
    _singleLine = NO;
}

#pragma mark 上拉收回标签视图
- (void)pullUpScrollView
{
    [UIView animateWithDuration:0.1 animations:^{
        
        _segmentView.frame = CGRectMake(0, 0, kScreenWidth - Height, Height);
        
    }];
    
    _segmentView.contentSize = [self getScrollViewContentSize:YES];
    _pullDownBtn.frame = CGRectMake(kScreenWidth - Height, 0, Height, Height);
    [_pullDownBtn setTitle:@"V" forState:UIControlStateNormal];
    [_pullDownBtn addTarget:self action:@selector(pullDownScrollView) forControlEvents:UIControlEventTouchUpInside];
    
    _singleLine = YES;
}

#pragma mark 首次创建标签button,返回scrollview可滑动范围
- (CGSize)calButtonWidthByStringWidth
{
    CGFloat widthBtn = 0;
    CGFloat height = 10; //控制button距离父视图的高
    CGFloat scrollViewWidth = 0;
    
    for (int i = 0; i < _dataSource.count; i++) {
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.backgroundColor = [UIColor whiteColor];
        [button addTarget:self action:@selector(handleclick:) forControlEvents:UIControlEventTouchUpInside];
        if (i != 0) {
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.layer.borderColor = YYYColor(204, 204, 204).CGColor;
        } else { //首次进入界面，第一个button为选中状态
            [button setTitleColor:YYYColor(80, 193, 233) forState:UIControlStateNormal];
            button.layer.borderColor = YYYColor(80, 193, 233).CGColor;
        }
        button.layer.borderWidth = 1;
        button.layer.cornerRadius = 15;
        button.clipsToBounds = true;//去除下边界
        
        //根据计算文字的长度改变button大小
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
        NSString *labelValue = _dataSource[i][@"value"];
        CGFloat length = [labelValue boundingRectWithSize:CGSizeMake(kScreenWidth - Height - 20, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
        //为button赋值
        [button setTitle:labelValue forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12];
        button.tag = i;
        //设置button的frame
        button.frame = CGRectMake(10 + widthBtn, height, length + 15, 30);
        
        scrollViewWidth += button.frame.size.width + 10;
        widthBtn = button.frame.size.width + button.frame.origin.x;
        
        [_buttonArray addObject:button];
        [_segmentView addSubview:button];
    }

    return  CGSizeMake(scrollViewWidth + 10, 40);
}

#pragma mark 改变button的frame,返回scrollview可滑动范围
- (CGSize)getScrollViewContentSize:(BOOL)singleLine
{
    CGFloat widthBtn = 0;
    CGFloat height = 10; //控制button距离父视图的高
    CGFloat scrollViewWidth = 0;
    CGFloat scrollViewheight = 0;
   
    if (_buttonArray.count > 0) {
        
        for (int i = 0; i < _buttonArray.count; i++) {
            
            UIButton *button = _buttonArray[i];
           
            //根据计算文字的长度改变button大小
            NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:12]};
            NSString *labelValue = _dataSource[i][@"value"];
            CGFloat length = [labelValue boundingRectWithSize:CGSizeMake(kScreenWidth - Height - 20, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
            button.frame = CGRectMake(10 + widthBtn, height, length + 15, 30);
            
            scrollViewWidth += button.frame.size.width + 10;
            //当button的位置超出屏幕边缘时换行，320只是button所在父视图的宽度
            if (!singleLine) {
                if (10 + widthBtn + length + 15 > kScreenWidth) {
                    widthBtn = 0; //换行宽度置为0
                    height = height + button.frame.size.height + 10; //距离父视图也变化
                    button.frame = CGRectMake(10 + widthBtn, height, length + 15, 30); //重设button的frame
                }
                
                if (i == _buttonArray.count - 1) {
                    scrollViewheight = CGRectGetMaxY(button.frame) + 10;
                }
            }
            
            widthBtn = button.frame.size.width + button.frame.origin.x;
        }
        
    }
    
    if (singleLine) {
        return CGSizeMake(scrollViewWidth + 10, 40);
    } else {
        return CGSizeMake(kScreenWidth, scrollViewheight);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
