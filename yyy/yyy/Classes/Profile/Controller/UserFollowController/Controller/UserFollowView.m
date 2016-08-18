//
//  UserFollowView.m
//  yyy
//
//  Created by TangXing on 16/4/12.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import "UserFollowView.h"
#import "YYYHttpTool.h"
#import "UIImageView+WebCache.h"
#import "MJRefresh.h"

#import "NoThingView.h"

@interface UserFollowView ()

@property (strong,nonatomic) NSMutableArray *dataSource;

@property (assign,nonatomic) BOOL next;
@property (copy,nonatomic)   NSString *page;
@property (copy,nonatomic)   NSString *pageButton;

@property (weak,nonatomic) NoThingView *noThingView;

@end

@implementation UserFollowView

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _dataSource  = [[NSMutableArray alloc] init];
    
    _next = NO;
    _page = nil;
    _pageButton = @"1";
    
    [self loadData];
    [self addHeader];
    [self addFooter];
}

- (void)loadData
{
    NSDictionary *params;
    if (_next) {
        params = @{@"pageButton":_pageButton,@"page":_page};
    } else {
        params = @{@"pageButton":_pageButton};
    }
    
    [YYYHttpTool post:YYYUserFollowURL params:params success:^(id json) {
        
        NSInteger checkPageCount = [json[@"page"] integerValue];
        
        if (checkPageCount > 0) {
            _next = [json[@"next"] boolValue];
            _page = json[@"page"];
            _pageButton = @"下页";
            
            for (NSDictionary *dic in json[@"followList"]) {
                [_dataSource addObject:dic];
            }
            
            [self.tableView reloadData];
            if (_next) {
                [self addFooter];
            }
            
        } else {
            
            NoThingView *noThingView = [[NoThingView alloc] initWithFrame:self.tableView.bounds];
            noThingView.tipsText = @"您还没有关注任何人哦～\n赶快去关注一些人吧～";
            noThingView.tipsImgName = @"noNetwork.jpg";
            self.noThingView = noThingView;
            [self.tableView addSubview:self.noThingView];
            
        }
        
    } failure:^(NSError *error) {
        TSLog(@"UserFollowERROR: %@",error);
    }];
}

- (void)addHeader
{
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        _next = NO;
        _page = nil;
        _pageButton = @"1";
        
        [_dataSource removeAllObjects];
        
        [self loadData];
        [self.tableView.header endRefreshing];
        
    }];
}

- (void)addFooter
{
    if (_next) {
        self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
            
            if (_next) {
                
                [self loadData];
                [self.tableView.footer endRefreshing];
                
            } else {
                [self.tableView.footer endRefreshingWithNoMoreData];
            }
        }];
    } else {
        self.tableView.tableFooterView = [[UIView alloc] init];
    }
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
    return 50;
}

//设置每行对应的cell(展示的内容)
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"userFollowCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    for (UIView *view in cell.subviews) {
        [view removeFromSuperview];
    }
    
    NSDictionary *dict = _dataSource[indexPath.row];
    
    UIImageView *userPhoto = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 40, 40)];
    [userPhoto sd_setImageWithURL:[NSURL URLWithString:dict[@"userPhoto"]]];
    userPhoto.layer.masksToBounds = YES;
    userPhoto.layer.cornerRadius = 20;
    [cell addSubview:userPhoto];
    
    UILabel *userName = [[UILabel alloc] initWithFrame:CGRectMake(60, 5, kScreenWidth - 70, 40)];
    [userName setFont:[UIFont systemFontOfSize:16.0]];
    [userName setTextColor:[UIColor blackColor]];
    [userName setTextAlignment:NSTextAlignmentLeft];
    [userName setText:dict[@"userName"]];
    [cell addSubview:userName];
    
    return cell;
}

//cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消cell选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
