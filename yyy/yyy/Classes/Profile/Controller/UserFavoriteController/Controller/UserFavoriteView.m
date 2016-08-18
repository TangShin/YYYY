//
//  UserFavoriteView.m
//  yyy
//
//  Created by TangXing on 16/3/31.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import "UserFavoriteView.h"
#import "FavoriteViewCell.h"
#import "YYYHttpTool.h"
#import "MJRefresh.h"
#import "UIImageView+WebCache.h"

@interface UserFavoriteView ()

@property (strong,nonatomic) UISegmentedControl *segmentedControl;//分页选择器

@property (assign,nonatomic) BOOL next;
@property (copy,nonatomic)   NSString *page;
@property (copy,nonatomic)   NSString *pageButton;
@property (copy,nonatomic)   NSString *currentDiv;

@property (strong,nonatomic) NSMutableArray *dataSource;

@end

@implementation UserFavoriteView

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _dataSource = [[NSMutableArray alloc] init];
    
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    _segmentedControl = [ [ UISegmentedControl alloc ] initWithItems:nil];
    [_segmentedControl insertSegmentWithTitle:@"视频" atIndex: 0 animated: NO ];
    [_segmentedControl insertSegmentWithTitle:@"歌单" atIndex: 1 animated: NO ];
    _segmentedControl.selectedSegmentIndex = 0;
    _segmentedControl.tintColor = YYYMainColor;
    [_segmentedControl addTarget:self action:@selector(segementValueChange) forControlEvents:UIControlEventValueChanged];
    
    self.navigationItem.titleView = _segmentedControl;
    
    [self segementValueChange];
    [self addFooter];
}

- (void)loadDataWithFavoriteDiv:(NSString *)div
{
    NSDictionary *params;
    if (_next) {
        params = @{@"favoriteDiv":div,@"pageButton":_pageButton,@"page":_page};
    } else {
        params = @{@"favoriteDiv":div,@"pageButton":_pageButton};
    }
    
    [YYYHttpTool post:YYYUserFavoriteURL params:params success:^(id json) {
        
        _page = json[@"page"];
        _next = [json[@"next"] boolValue];
        _pageButton = @"下页";
        
        for (NSDictionary *dic in json[@"favoriteList"]) {
            [_dataSource addObject:dic];
        }
        
        [self.tableView reloadData];
        [self.tableView.footer endRefreshing];
        
    } failure:^(NSError *error) {
        TSLog(@"favoritePOST Error: %@",error);
    }];
}

- (void)addHeader
{
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [self.tableView.header endRefreshing];
        
    }];
    
    [self.tableView.header beginRefreshing];
}

- (void)addFooter
{
    if (_next) {
        self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            
            if (_next) {
                
                [self loadDataWithFavoriteDiv:_currentDiv];
                
            } else {
                [self.tableView.footer endRefreshingWithNoMoreData];
            }
            
        }];
    }
}

- (void)segementValueChange
{
    if (_segmentedControl.selectedSegmentIndex == 0) {
        _currentDiv = FAVORITE_DIV_VIDEO;
        
    } else {
        _currentDiv = FAVORITE_DIV_PLAYLIST;
        
    }
    _next = NO;
    _page = nil;
    _pageButton = @"1";
    [_dataSource removeAllObjects];
    [self loadDataWithFavoriteDiv:_currentDiv];
}

#pragma mark tableViewDelegate
//设置每个分组下tableview的分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//设置每个分组下tableview的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

//每个分组上边预留空白高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

//每个分组下边预留空白高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0;
}

//每一个分组下对应的tableviewCell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_segmentedControl.selectedSegmentIndex == 0) {
        return 87.0;
    } else {
        return 110.0;
    }
//UITableViewAutomaticDimension 设置高度自动获取
}

//初始加载tableviewcell时，给出预估高度
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

//设置每行对应的cell(展示的内容)
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"FavoriteViewCell";
//    //加载自定义cell
    UINib *favoriteNib = [UINib nibWithNibName:identifier bundle:nil];
    [tableView registerNib:favoriteNib forCellReuseIdentifier:identifier];
    
    FavoriteViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    NSString *imageUrl = _dataSource[indexPath.row][@"previewAddr"];
    NSString *name = _dataSource[indexPath.row][@"favoriteName"];
    
    if ([_currentDiv isEqualToString:FAVORITE_DIV_VIDEO]) {
        
        cell.playlistImage.hidden = YES;
        cell.playlistName.hidden = YES;
        cell.videoImage.hidden = NO;
        cell.videoName.hidden = NO;
        
        [cell.videoImage sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
        cell.videoImage.layer.masksToBounds =YES;
        cell.videoImage.layer.cornerRadius = 5;
        cell.videoName.text = name;
        
    } else {
        
        cell.videoImage.hidden = YES;
        cell.videoName.hidden = YES;
        cell.playlistImage.hidden = NO;
        cell.playlistName.hidden = NO;
        
        [cell.playlistImage sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
        cell.playlistName.text = name;
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

//cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
//    //取消cell选中状态
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
