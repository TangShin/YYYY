//
//  SubMediaView.m
//  yyy
//
//  Created by TangXing on 16/5/12.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import "SubMediaView.h"
#import "SubMediaModel.h"
#import "SubMediaFrame.h"
#import "SubMediaCell.h"

#import "MediaFrame.h"
#import "MediaModel.h"
#import "MediaCell.h"

#import "YYYHttpTool.h"
#import "MJExtension.h"
#import "MJRefresh.h"

#define JSONKey @"mediaList"
#define MODELKey @"content"

@interface SubMediaView () <MediaCellDelegate,SubMediaCellDelegate>

@property (assign,nonatomic) BOOL next;
@property (copy,nonatomic) NSString *page;
@property (copy,nonatomic) NSString *pageButton;

@property (strong, nonatomic) NSMutableArray *subMediaFrames;
@property (strong, nonatomic) NSArray *mediaFrames;

@end

@implementation SubMediaView

- (NSMutableArray *)subMediaFrames
{
    if (!_subMediaFrames) {
        self.subMediaFrames = [NSMutableArray array];
    }
    return _subMediaFrames;
}

- (NSArray *)mediaFrames
{
    if (!_mediaFrames) {
        self.mediaFrames = @[self.mediaF];
    }
    return _mediaFrames;
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

//需要导入MJExtension.h,并且与ArrayFramesWithArray代码块联用(YYYHttpTool为请求管理类)
//拥有数组分类NSArray+DecoderFromHTML.h 才能使用objectArrayWithKeyValuesArray.
//此分类作用为，把java string[]字符数组转换成 ios NSString字符串.
- (void)loadData
{
    NSDictionary *params;
    if (self.next) {
        params = @{@"pageButton":self.pageButton,@"page":self.page,@"mediaId":self.userId,@"timestamp":self.mediaF.media.timestamp};
    } else {
        params = @{@"pageButton":self.pageButton,@"mediaId":self.userId,@"timestamp":self.mediaF.media.timestamp};
    }
    
    [YYYHttpTool post:YYYSubMediaPagingURL params:params success:^(id json) {
        
        self.next = [json[@"next"] boolValue];
        self.page = json[@"page"];
        
        // 将json数据里的字符串数组转换成ios字符串,返回新生成的数据数组,便于模型解析
        NSArray *dataArray = [json[JSONKey] creatModelArrayWithDictionaryKey:MODELKey];
        
        // 将 "消息字典"数组 转为 "消息模型"数组
        NSArray *newData = [SubMediaModel objectArrayWithKeyValuesArray:dataArray];
        
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
        [self.subMediaFrames addObjectsFromArray:newDataFrames];
        
        [self.tableView reloadData];
        
        if ([self.pageButton isEqualToString:@"1"]) {
            [self.tableView.header endRefreshing];
        }
        
    } failure:^(NSError *error) {
        TSLog(@"SubMediaViewError %@",error);
    }];
}

/**
 *  将模型转为frame模型
 */
- (NSArray *)ArrayFramesWithArray:(NSArray *)array
{
    NSMutableArray *frames = [NSMutableArray array];
    for (SubMediaModel *subMedia in array) {
        SubMediaFrame *subMediaF = [[SubMediaFrame alloc] init];
        subMediaF.subMedia = subMedia;
        [frames addObject:subMediaF];
    }
    return frames;
}

//刷新数据
- (void)addHeader
{
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self.next = NO;
        self.pageButton = @"1";
        [self.subMediaFrames removeAllObjects];
        
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
    return 2;
}

//设置每个分组下tableview的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.mediaFrames.count;
    }
    return self.subMediaFrames.count;
}

//每一个分组下对应的tableviewCell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        MediaFrame *mediaFrame = self.mediaFrames[indexPath.row];
        return mediaFrame.cellHeight;
    }
    SubMediaFrame *subMediaFrame = self.subMediaFrames[indexPath.row];
    return subMediaFrame.cellHeight;
}

//设置每行对应的cell(展示的内容)
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        MediaCell *cell = [MediaCell cellWithTableView:tableView];
        cell.mediaFrame = self.mediaFrames[indexPath.row];
        cell.mediaDelegate = self;
        return cell;
    }
    SubMediaCell *cell = [SubMediaCell cellWithTableView:tableView];
    cell.subMediaFrame = self.subMediaFrames[indexPath.row];
    cell.subMediaDelegate = self;
    return cell;
}

//cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return;
    }
    //取消cell选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    TSLog(@"SubMediaCellClick");
}

#pragma mark - SubMediaCellDelegate
- (void)touchUserName:(NSString *)userId
{
    TSLog(@"touchUserName%@",userId);
}

- (void)touchReUserName:(NSString *)reUserId
{
    TSLog(@"touchReUserName%@",reUserId);
}

- (void)addLike:(NSString *)userId
{
    TSLog(@"addLike%@",userId);
}

- (void)touchUserPhotoWithUserId:(NSString *)userId
{
    TSLog(@"touchUserPhotoWithUserId%@",userId);
}

@end
