//
//  SearchResultsView.m
//  yyy
//
//  Created by TangXing on 16/3/7.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import "SearchResultsView.h"
#import "VideoSearchResultCell.h"
#import "PlaylistSearchResultCell.h"
#import "MusicalTableViewCell.h"

#import "PlayVideoViewController.h"
#import "PlaylistViewController.h"

#import "YYYHttpTool.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"

#define TOPHEIGHT 40
#define TABHEIGHT 49
#define NAVIGATIONHEIGHT 64

@interface SearchResultsView () <UITableViewDataSource,UITableViewDelegate>

@property (strong,nonatomic) UITableView *tableview;//搜索结果展示
@property (strong,nonatomic) UIScrollView *tabScrollView;//上方tabbutton容器
@property (strong,nonatomic) UIView *slideView;//滑动条
//@property (strong,nonatomic) UIView *topMainView;//
@property (strong,nonatomic) NSArray *buttonNames;//按钮名称数组
@property (strong,nonatomic) NSMutableArray *topViews;//按钮数组

@property (assign,nonatomic) NSInteger currentTag;
@property (assign) NSInteger tabCount;

@property (strong,nonatomic) NSMutableArray *searchResultItemArray;//搜索结果item数组
@property (strong,nonatomic) NSString *page;//当前页
@property (assign,nonatomic) bool next;//是否有下一页
@property (assign,nonatomic) BOOL nibRegistered;

@end

@implementation SearchResultsView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame])
    {
        self.frame = frame;
        self.backgroundColor = YYYBackGroundColor;
    }
    return self;
}

- (UIView *)setUpSearchResultsViewWithButtonNames:(NSArray *)btnName
{
    _topViews = [[NSMutableArray alloc] init];
    _searchResultItemArray = [[NSMutableArray alloc] init];
    _next = false;
    _nibRegistered = NO;
    
    _tabCount = btnName.count;
    _buttonNames = btnName;
    
    [self initTableview];
    
    [self addHeader];
    
    [self addFooter];
    
    [self initTopTabs];
    
    [self initSlideView];

    return self;
}
- (void)initTableview
{
    _tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, TOPHEIGHT, self.frame.size.width, self.frame.size.height - TOPHEIGHT - TABHEIGHT - NAVIGATIONHEIGHT) style:UITableViewStylePlain];
    _tableview.delegate = self;
    _tableview.dataSource = self;
    _tableview.backgroundColor = YYYBackGroundColor;
    [self addSubview:_tableview];
}

- (void)addHeader
{
    _tableview.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self loadSearchResultsViewsData:_searchText];
        [_tableview.header endRefreshing];
        
    }];
    
}

- (void)addFooter
{
    if (_next) {
        _tableview.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:_searchText,@"keyword",@"下页",@"button",_page,@"page",_searchDiv,@"searchDiv",nil];
            
            if (_next) {
                [YYYHttpTool post:YYYSearch params:params success:^(id json) {
                    
                    _next = [json[@"next"] intValue];
                    _page = json[@"page"];
                    
                    for (NSDictionary *dic in json[@"searchResultItemList"]) {
                        [_searchResultItemArray addObject:dic];
                    }
                    
                    [_tableview reloadData];
                    [_tableview.footer endRefreshing];
                    
                } failure:^(NSError *error) {
                    TSLog(@"SearchResultsFooterRefresh %@",error);
                }];
            } else {
                [_tableview.footer endRefreshingWithNoMoreData];
            }
        }];
    } else {
        _tableview.tableFooterView = [[UIView alloc] init];
    }
}

- (void)initTopTabs
{
    CGFloat width = self.frame.size.width / _tabCount;
    
    _tabScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, TOPHEIGHT)];
    _tabScrollView.showsHorizontalScrollIndicator = NO;
    _tabScrollView.showsVerticalScrollIndicator = YES;
    _tabScrollView.bounces = NO;
    _tabScrollView.delegate = self;
    _tabScrollView.backgroundColor = [UIColor whiteColor];
    _tabScrollView.contentSize = CGSizeMake(width * _tabCount, TOPHEIGHT);
    
    [self addSubview:_tabScrollView];
    
    for (int i = 0; i < _tabCount; i++) {
        [self TopTabsButtonWithName:_buttonNames[i] tag:i];
    }
    [_topViews[0] setSelected:YES];
    _currentTag = 0;
}

- (void)initSlideView
{
    CGFloat width = self.frame.size.width / _tabCount;
    
    _slideView = [[UIView alloc] initWithFrame:CGRectMake(0, TOPHEIGHT - 5, width, 5)];
    [_slideView setBackgroundColor:YYYMainColor];
    [_tabScrollView addSubview:_slideView];
}



- (void)TopTabsButtonWithName:(NSString *)buttonName tag:(int)tag
{
    CGFloat width = self.frame.size.width / _tabCount;
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(tag * width, 0, width, TOPHEIGHT)];
    button.tag = tag;
    [button setTitle:buttonName forState:UIControlStateNormal];
    [button setTitleColor:YYYColor(126,119,121) forState:UIControlStateNormal];
    [button setTitleColor:YYYMainColor forState:UIControlStateSelected];
    [button addTarget:self action:@selector(tabButton:) forControlEvents:UIControlEventTouchUpInside];
    
    [_topViews addObject:button];
    [_tabScrollView addSubview:button];
}

#pragma mark 点击顶部的按钮所触发的方法
- (void)tabButton:(UIButton *)sender
{
    if (sender.selected && sender.tag == _currentTag) {
        return;
    }
    
    [_searchResultItemArray removeAllObjects];
    [_tableview reloadData];
    
    for (UIButton *btn in _topViews) {
        btn.selected = NO;
    }
    
    [self buttonTagChooseSearchDiv:sender.tag];
    
    sender.selected = !sender.selected;
    _currentTag = sender.tag;
    
    CGRect frame = _slideView.frame;
    
    frame.origin.x = sender.origin.x;
    
    _slideView.frame = frame;
    
    [self loadSearchResultsViewsData:_searchText];
}

#pragma mark tableview的代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _searchResultItemArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!_nibRegistered) {
        UINib *videoNib = [UINib nibWithNibName:@"VideoSearchResultCell" bundle:nil];
        [tableView registerNib:videoNib forCellReuseIdentifier:@"VideoCell"];
        
        UINib *playlistNib = [UINib nibWithNibName:@"PlaylistSearchResultCell" bundle:nil];
        [tableView registerNib:playlistNib forCellReuseIdentifier:@"playlistCell"];
        
        UINib *musicalNib = [UINib nibWithNibName:@"MusicalTableViewCell" bundle:nil];
        [tableView registerNib:musicalNib forCellReuseIdentifier:@"musicalCell"];
        
        _nibRegistered = YES;
    }
    
    NSString *itemPreviewAddr,*userName,*playCount,*comdCount,*likeCount,*favoriteCount,*fansCount,*title;
    if (_searchResultItemArray.count > 0) {
        itemPreviewAddr = _searchResultItemArray[indexPath.row][@"itemPreviewAddr"];
        favoriteCount = _searchResultItemArray[indexPath.row][@"favoriteCount"];
        comdCount = _searchResultItemArray[indexPath.row][@"commentCount"];
        playCount = _searchResultItemArray[indexPath.row][@"playCount"];
        likeCount = _searchResultItemArray[indexPath.row][@"likeCount"];
        fansCount = _searchResultItemArray[indexPath.row][@"fansCount"];
        userName = _searchResultItemArray[indexPath.row][@"userName"];
        title = _searchResultItemArray[indexPath.row][@"itemName"];
    }
    
    if ([_searchDiv isEqualToString:SEARCH_DIV_VIDEO]) {
        
        VideoSearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VideoCell"];
        [cell.addrImg sd_setImageWithURL:[NSURL URLWithString:itemPreviewAddr]];
        cell.title.text = title;
        cell.userName.text = userName;
        cell.playCount.text = playCount;
        cell.comdCount.text = comdCount;
        cell.addrImg.layer.masksToBounds = YES;
        cell.addrImg.layer.cornerRadius = 5;
        
        return cell;
        
    } else if ([_searchDiv isEqualToString:SEARCH_DIV_PLAYLIST]) {
        
        PlaylistSearchResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"playlistCell"];
        [cell.playlistImg sd_setImageWithURL:[NSURL URLWithString:itemPreviewAddr]];
        cell.title.text = title;
        cell.userName.text = userName;
        cell.likeCount.text = likeCount;
        cell.favoriteCount.text = favoriteCount;
        cell.comdCount.text = comdCount;
        
        return cell;
        
    } else {
        
        MusicalTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"musicalCell"];
        [cell.userPhoto sd_setImageWithURL:[NSURL URLWithString:itemPreviewAddr]];
        cell.userName.text = title;
        cell.fansCount.text = [NSString stringWithFormat:@"粉丝:%@",fansCount];
        
        if ([_searchDiv isEqualToString:SEARCH_DIV_MUSICAL]) {
            cell.userPhoto.layer.masksToBounds = YES;
            cell.userPhoto.layer.cornerRadius = cell.userPhoto.size.width/2;
            cell.userPhoto.layer.borderWidth = 2;
            cell.userPhoto.layer.borderColor = [UIColor whiteColor].CGColor;
        }
        
        return cell;
        
    }
    return nil;
}

//tableview点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消cell选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (_currentTag == 0) {
        PlayVideoViewController *videoView = [[PlayVideoViewController alloc] init];
        videoView.videoId = _searchResultItemArray[indexPath.row][@"itemId"];
        [_fatherViewController.navigationController pushViewController:videoView animated:YES];
    } else if(_currentTag == 1) {
        PlaylistViewController *playlistView = [[PlaylistViewController alloc] init];
        playlistView.playlistId = _searchResultItemArray[indexPath.row][@"itemId"];
        [_fatherViewController.navigationController pushViewController:playlistView animated:YES];
    } else {
        TSLog(@"helloword");
    }
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

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (_delegate) {
        [_delegate searchResultsViewWillBeginDragging:scrollView];
    }
}

#pragma mark reloadTableView
- (void)loadSearchResultsViewsData:(NSString *)searchText
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:searchText,@"keyword",_searchDiv,@"searchDiv",nil];
    
    [YYYHttpTool post:YYYSearch params:params success:^(id json) {
        
        _next = [json[@"next"] intValue];
        _page = json[@"page"];
        
        [_searchResultItemArray removeAllObjects];
        for (NSDictionary *dic in json[@"searchResultItemList"]) {
            [_searchResultItemArray addObject:dic];
        }
        
        [_tableview.footer removeFromSuperview];
        [self addFooter];
        [_tableview reloadData];
        
    } failure:^(NSError *error) {
        TSLog(@"SearchError %@",error);
    }];
}

- (void)buttonTagChooseSearchDiv:(NSInteger)tag
{
    if (tag == 0) {
        _searchDiv = SEARCH_DIV_VIDEO;
    } else if (tag == 1) {
        _searchDiv = SEARCH_DIV_PLAYLIST;
    } else if (tag == 2) {
        _searchDiv = SEARCH_DIV_MUSICAL;
    } else if (tag == 3) {
        _searchDiv = SEARCH_DIV_BAND;
    }
}

- (void)reloadSlideViewOrigin
{
    for (UIButton *btn in _topViews) {
        btn.selected = NO;
    }
    
    UIButton *btn = _topViews[0];
    btn.selected = !btn.selected;
    _currentTag = btn.tag;
    
    CGRect frame = _slideView.frame;
    
    frame.origin.x = btn.origin.x;
    
    _slideView.frame = frame;
}
@end
