//
//  ReplyMineView.m
//  yyy
//
//  Created by TangXing on 16/5/3.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import "ReplyMineView.h"
#import "ReplyMineModel.h"
#import "ReplyMineFrame.h"
#import "ReplyMineCell.h"

#import "YYYHttpTool.h"
#import "MJExtension.h"
#import "MJRefresh.h"

@interface ReplyMineView ()

@property (assign,nonatomic) BOOL next;
@property (copy,nonatomic) NSString *page;
@property (copy,nonatomic) NSString *pageButton;

@property (strong,nonatomic) NSMutableArray *replyMineFrames;

@end

@implementation ReplyMineView
#pragma mark 懒加载
- (NSMutableArray *)replyMineFrames
{
    if (!_replyMineFrames) {
        self.replyMineFrames = [NSMutableArray array];
    }
    return _replyMineFrames;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//隐藏线条
    
    //更新未读为已读
    [self updataUnreadToRead];
    
    [self addHeader];
}

//需要导入MJExtension.h,并且与ArrayFramesWithArray代码块联用(YYYHttpTool为请求管理类)
- (void)loadData
{
    NSDictionary *params;
    if (self.next) {
        params = @{@"pageButton":self.pageButton,@"page":self.page};
    } else {
        params = @{@"pageButton":_pageButton};
    }
    
    [YYYHttpTool post:YYYReplyMineURL params:params success:^(id json) {
        
        self.next = [json[@"next"] boolValue];
        self.page = json[@"page"];
        
        // 将json数据里的字符串数组转换成ios字符串,返回新生成的数据数组,便于模型解析
        NSArray *dataArray = [json[@"replyMineList"] creatModelArrayWithDictionaryKey:@"replyContent"];
        dataArray = [dataArray creatModelArrayWithDictionaryKey:@"replyMediaInfo"];
        
        // 将 "消息字典"数组 转为 "消息模型"数组
        NSArray *newData = [ReplyMineModel objectArrayWithKeyValuesArray:dataArray];
        
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
        [self.replyMineFrames addObjectsFromArray:newDataFrames];
        
        [self.tableView reloadData];
        
        if ([self.pageButton isEqualToString:@"1"]) {
            [self.tableView.header endRefreshing];
        }
        
    } failure:^(NSError *error) {
        TSLog(@"ReplyMine ERROR %@",error);
    }];
}

/**
 *  将模型转为frame模型
 */
- (NSArray *)ArrayFramesWithArray:(NSArray *)array
{
    NSMutableArray *frames = [NSMutableArray array];
    for (ReplyMineModel *replyMineM in array) {
        ReplyMineFrame *replyMineF = [[ReplyMineFrame alloc] init];
        replyMineF.replyMine = replyMineM;
        [frames addObject:replyMineF];
    }
    return frames;
}

//刷新数据
- (void)addHeader
{
    self.tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self.next = NO;
        self.pageButton = @"1";
        [self.replyMineFrames removeAllObjects];
        
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
    return self.replyMineFrames.count;
}

//每一个分组下对应的tableviewCell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReplyMineFrame *replyMineFrame = self.replyMineFrames[indexPath.row];
    return replyMineFrame.cellHeight;
}

//设置每行对应的cell(展示的内容)
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReplyMineCell *cell = [ReplyMineCell cellWithTableView:tableView];
    cell.replyMineFrame = self.replyMineFrames[indexPath.row];
    return cell;
}

//cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TSLog(@"ReplyMineTableview");
}

#pragma mark - 未读更新为已读
- (void)updataUnreadToRead
{
    [YYYHttpTool post:YYYReplyMineUpdataToReaded params:nil success:^(id json) {
    } failure:^(NSError *error) {
        TSLog(@"ReplyMineUpdataToReadedERROR %@",error);
    }];
}
@end
