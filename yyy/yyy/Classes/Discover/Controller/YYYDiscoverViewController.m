//
//  YYYDiscoverViewController.m
//  yyy
//
//  Created by TangXing on 16/3/4.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import "YYYDiscoverViewController.h"
#import "SearchResultsView.h"
#import "YYYSearchView.h"
#import "SearchKeywordView.h"

#import "TextCollectionCell.h"

#import "YYYHttpTool.h"
#import "SearchHistoryTool.h"

@interface YYYDiscoverViewController () <UITableViewDataSource,UITableViewDelegate,YYYSearchViewDelegate,SearchKeywordDelegate,SearchResultsDelegate>

@property (strong,nonatomic) YYYSearchView *search;
@property (strong,nonatomic) SearchResultsView *searchResultsView;
@property (strong,nonatomic) SearchKeywordView *searchHotKeywordView;

@property (strong,nonatomic) NSArray *dataSource;
@property (strong,nonatomic) NSArray *hotKeywordArray;
@property (strong,nonatomic) NSMutableArray *searchHistory;

@property (assign,nonatomic) CGFloat hotKeywordHeight;

@end

@implementation YYYDiscoverViewController

- (void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    _searchHistory = [NSMutableArray array];
    _hotKeywordHeight = 100.0;
    
    SearchHistory *searchHistory = [SearchHistoryTool searchHistory];
    for (NSString *str in searchHistory.searchHistory) {
        [_searchHistory addObject:str];
    }
    
    [YYYHttpTool post:YYYHotSearchURL params:nil success:^(id json) {
        
        _hotKeywordArray = json[@"keywordList"];
        
        if (_hotKeywordArray.count > 0) {
            [self buildHotKeywordView];
        }
        
    } failure:^(NSError *error) {
        TSLog(@"POSTHotSearchError %@",error);
    }];
    
    _search = [[YYYSearchView alloc] initWithFrame:(CGRect){{0,0},{self.view.frame.size.width,64}}];
    _search.delegate = self;
    _search.searchResultsDataSource = self;
    _search.searchResultsDelegate   = self;
    _search.placeholder = @"搜索";
    [self.view addSubview:_search];
}

//创建热门搜索collectionview
- (void)buildHotKeywordView
{
    _searchHotKeywordView = [[SearchKeywordView alloc] initWithFrame:CGRectMake(0, _hotKeywordHeight, kScreenWidth, [self calCollectionHeight])];
    _searchHotKeywordView.keywordDelegate = self;
    _searchHotKeywordView.searchHistory = _searchHistory;
    _searchHotKeywordView.searchKeyword = _hotKeywordArray;
    _searchHotKeywordView.backgroundColor = [UIColor whiteColor];
//    _searchHotKeywordView.alwaysBounceVertical = YES;//数据不够一屏也能滚动
    
    [self.view addSubview:_searchHotKeywordView];
}

#pragma mark tableView dataSoure
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    }
    
    cell.textLabel.text = _dataSource[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _search.searchBar.text = _dataSource[indexPath.row];
    [_search.searchResultTableView removeFromSuperview];
    
    [self loadSearchResultsViewsData:_dataSource[indexPath.row]];
}


#pragma mark searchBar Delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:searchText,@"keyword",nil];
    
    [YYYHttpTool post:YYYCompletedSearchURL params:params success:^(id json) {
        
        _dataSource = json[@"keywordList"];
        [_search.searchResultTableView reloadData];
        
    } failure:^(NSError *error) {
        TSLog(@"POSTCompletedSearchError %@",error);
    }];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [_search.searchResultTableView removeFromSuperview];
    [self loadSearchResultsViewsData:searchBar.text];
}

#pragma mark - SearchResultsDelegate
- (void)searchResultsViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.search.searchBar resignFirstResponder];
}

#pragma mark other founction
- (void)loadSearchResultsViewsData:(NSString *)searchText
{
    _search.maskView.hidden = NO;
    if (_search.maskView.subviews.count == 0) {
        NSArray *buttonNames = @[@"视频",@"歌单",@"音乐人",@"乐队组合"];
        _searchResultsView = [[SearchResultsView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        _searchResultsView.fatherViewController = self;
        [_searchResultsView setUpSearchResultsViewWithButtonNames:buttonNames];
        [_search.maskView addSubview:_searchResultsView];
    }
    
    _searchResultsView.delegate = self;
    _searchResultsView.searchText = searchText;
    _searchResultsView.searchDiv = SEARCH_DIV_VIDEO;
    [_searchResultsView reloadSlideViewOrigin];
    [_searchResultsView loadSearchResultsViewsData:searchText];

    //存储搜索历史
    BOOL isHistory = NO,isDelete = NO;
    
    if (_searchHistory.count > 0) {
        isHistory = YES;
        
        for (NSString *str in _searchHistory) {
            if ([searchText isEqualToString:str]) {
                NSUInteger index = [_searchHistory indexOfObject:str];
                [_searchHistory removeObjectAtIndex:index];
                [_searchHistory addObject:searchText];
                isDelete = YES;
                break;
            }
        }
    }
    
    if (!isHistory || !isDelete) {
        [_searchHistory addObject:searchText];
    }
    
    if (_searchHistory.count > 10) {
        [_searchHistory removeObjectAtIndex:0];
    }
    
    if (_searchHistory.count > 0) {
        
        _searchHotKeywordView.searchHistory = _searchHistory;
        [_searchHotKeywordView reloadData];
        _searchHotKeywordView.frame = CGRectMake(0, _hotKeywordHeight, kScreenWidth, [self calCollectionHeight]);
        //将搜索历史存储到沙盒
        NSArray *historyArray = [_searchHistory copy];
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:historyArray,@"searchHistory",nil];
        SearchHistory *searchHistory = [SearchHistory searchHistoryWithDic:dictionary];
        [SearchHistoryTool saveSearchHistory:searchHistory];
        
    }
}

//searchHotKeywordCellClick
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [_search.searchBar becomeFirstResponder];
    
    if (indexPath.section == 0 && _searchHistory.count > 0) {
        _search.searchBar.text = _searchHistory[_searchHistory.count - 1 - indexPath.row];
    } else {
        _search.searchBar.text = _hotKeywordArray[indexPath.row];
    }
    [self loadSearchResultsViewsData:_search.searchBar.text];
}

- (void)clearHistory
{
    [_searchHistory removeAllObjects];
    _searchHotKeywordView.frame = CGRectMake(0, _hotKeywordHeight, kScreenWidth, [self calCollectionHeight]);
    
    NSFileManager* fileManager=[NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES);
    
    //文件名
    NSString *uniquePath=[[paths objectAtIndex:0] stringByAppendingPathComponent:@"searchHistory.archive"];
    [[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
    [fileManager removeItemAtPath:uniquePath error:nil];
}

- (CGFloat)calCollectionHeight
{
    CGFloat height = 0.0;
    if (_searchHistory.count > 0) {
        height = (_searchHistory.count + 1)/2*33;
        height += 60;
    }
    
    height += (_hotKeywordArray.count + 1)/2*33;
    
    //50为collection.footer的高
    return height + 60;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
