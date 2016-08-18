//
//  MediaView.m
//  yyy
//
//  Created by TangXing on 16/5/12.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import "MediaView.h"
#import "SubMediaView.h"
#import "MediaModel.h"
#import "MediaFrame.h"
#import "MediaCell.h"

#import "YYYHttpTool.h"
#import "UserInfoTool.h"
#import "MJExtension.h"
#import "MJRefresh.h"

#define JSONKey @"mediaList"
#define MODELKey @"content"

@interface MediaView () <MediaCellDelegate>

@property (assign,nonatomic) BOOL next;
@property (copy,nonatomic) NSString *page;
@property (copy,nonatomic) NSString *pageButton;

@property (strong,nonatomic) NSMutableArray *userMessageFrames;

@end

@implementation MediaView

- (NSMutableArray *)userMessageFrames
{
    if (!_userMessageFrames) {
        self.userMessageFrames = [NSMutableArray array];
    }
    return _userMessageFrames;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//隐藏线条
    self.tableView.showsVerticalScrollIndicator = NO;//不显示右滑块
    
//        //更新未读为已读
//        [self updataUnreadToRead];
    
    [self addHeader];
}

//需要导入MJExtension.h,MJRefresh.h (YYYHttpTool为请求管理类)
//拥有数组分类NSArray+DecoderFromHTML.h 才能使用objectArrayWithKeyValuesArray.
//此分类作用为，把java string数组转换成 ios NSString字符串.
- (void)loadData
{
    NSDictionary *params;
    if (self.next) {
        params = @{@"pageButton":self.pageButton,@"page":self.page,@"mediaId":self.mediaId};
    } else {
        params = @{@"pageButton":self.pageButton,@"mediaId":self.mediaId};
    }
    
    [YYYHttpTool post:YYYMediaPagingURL params:params success:^(id json) {
        
        self.next = [json[@"next"] boolValue];
        self.page = json[@"page"];
        
        // 将json数据里的字符串数组转换成ios字符串,返回新生成的数据数组,便于模型解析
        NSArray *dataArray = [json[JSONKey] creatModelArrayWithDictionaryKey:MODELKey];
        
        // 将 "消息字典"数组 转为 "消息模型"数组
        NSArray *newData = [MediaModel objectArrayWithKeyValuesArray:dataArray];
        
        // 将"消息模型数组"转换为"消息frame数组"
        NSArray *newDataFrames = [self ArrayFramesWithArray:newData];
        
        //追加数据小于一页最大数,删除footerview
        if (newDataFrames.count < VIEW_MAX_COUNT) {
            [self.tableView.footer removeFromSuperview];
        }
        
        //有下一页,添加footerview
        if (self.next) {
            [self addFooter];
        }
        
        //添加frame数组
        [self.userMessageFrames addObjectsFromArray:newDataFrames];
        
        [self.tableView reloadData];
        
        if ([self.pageButton isEqualToString:@"1"]) {
            [self.tableView.header endRefreshing];
        }
        
    } failure:^(NSError *error) {
    }];
}

/**
 *  将模型转为frame模型
 */
- (NSArray *)ArrayFramesWithArray:(NSArray *)array
{
    NSMutableArray *frames = [NSMutableArray array];
    for (MediaModel *media in array) {
        MediaFrame *mediaF = [[MediaFrame alloc] init];
        mediaF.media = media;
        [frames addObject:mediaF];
    }
    return frames;
}

//刷新数据
- (void)addHeader
{
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self.next = NO;
        self.pageButton = @"1";
        [self.userMessageFrames removeAllObjects];
        
        [self loadData];
        
    }];
    
    [self.tableView.header beginRefreshing];
}

//加载更多数据
- (void)addFooter
{
    self.tableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (self.next) {
            self.pageButton = @"下页";
            [self loadData];
            [self.tableView.footer endRefreshing];
        }
    }];
}

#pragma mark - tableViewDataSource
//设置每个分组下tableview的分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//设置每个分组下tableview的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.userMessageFrames.count;
}

//每一个分组下对应的tableviewCell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MediaFrame *mediaFrame = self.userMessageFrames[indexPath.row];
    return mediaFrame.cellHeight;
}

//设置每行对应的cell(展示的内容)
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MediaCell *cell = [MediaCell cellWithTableView:tableView];
    cell.mediaFrame = self.userMessageFrames[indexPath.row];
    cell.mediaDelegate = self;
    return cell;
}

//cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消cell选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MediaFrame *mediaF = self.userMessageFrames[indexPath.row];
    
    if ([mediaF.media.subMediaCount integerValue] == 0) {
        return;
    }
    
    SubMediaView *subMediaView = [[SubMediaView alloc] init];
    subMediaView.userId = [UserInfoTool userInfo].userId;
    subMediaView.mediaF = mediaF;
    subMediaView.title = @"评论详情";
    
    [self.navigationController pushViewController:subMediaView animated:YES];
}

#pragma mark - MediaCellDelegate
- (void)touchUserName:(UIButton *)sender
{
    TSLog(@"touchName");
}

- (void)addLike:(UIButton *)sender
{
    TSLog(@"addLike");
}

- (void)touchUserPhotoWithUserId:(NSString *)userId
{
    TSLog(@"%@",userId);
}

@end
