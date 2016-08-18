//
//  UserNoticeView.m
//  yyy
//
//  Created by TangXing on 16/4/13.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import "UserNoticeView.h"
#import "UserNoticeModel.h"
#import "UserNoticeFrame.h"
#import "UserNoticeCell.h"
#import "SystemNoticeCell.h"

#import "ReplyMineView.h"
#import "SystemNoticeView.h"
#import "UserLetterView.h"

#import "YYYHttpTool.h"
#import "MJExtension.h"
#import "MJRefresh.h"

@interface UserNoticeView ()

@property (assign,nonatomic) BOOL next;
@property (copy,nonatomic)  NSString *systemNoticeTotalCount;
@property (copy,nonatomic)  NSString *replyMineTotalCount;
@property (copy,nonatomic)  NSString *page;
@property (copy,nonatomic)  NSString *pageButton;

@property (strong,nonatomic) NSArray *systemNoticeArray;
@property (strong,nonatomic) NSMutableArray *userNoticeFrames;

@end

@implementation UserNoticeView
#pragma mark - 实例化变量
- (NSMutableArray *)userNoticeFrames
{
    if (!_userNoticeFrames) {
        self.userNoticeFrames = [NSMutableArray array];
    }
    return _userNoticeFrames;
}

- (NSArray *)systemNoticeArray
{
    if (!_systemNoticeArray) {
        self.systemNoticeArray = @[@"回复我的",@"系统通知"];
    }
    return _systemNoticeArray;
}

#pragma mark - 界面入口
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//隐藏线条
    self.tableView.showsVerticalScrollIndicator = NO;//不显示右滑块
}

- (void)loadData
{
    //初始化参数字典
    NSDictionary *params;
    //拼接参数
    if (self.next) {
        params = @{@"pageButton":_pageButton,@"page":_page};
    } else {
        params = @{@"pageButton":_pageButton};
    }
    
    //发送请求
    [YYYHttpTool post:YYYUserNoticeURL params:params success:^(id json) {
        
        self.next = [json[@"next"] boolValue];
        self.page = json[@"page"];
        self.replyMineTotalCount = json[@"replyMineTotalCount"];
        self.systemNoticeTotalCount = json[@"systemNoticeTotalCount"];
        
        // 将json数据里的字符串数组转换成ios字符串,返回新生成的数据数组,便于模型解析
        NSArray *dataArray = [json[@"noticeList"] creatModelArrayWithDictionaryKey:@"previewMessage"];
        
        // 将 "消息字典"数组 转为 "消息模型"数组
        NSArray *newData = [UserNoticeModel objectArrayWithKeyValuesArray:dataArray];
        
        //  将"消息模型数组"转换为"消息frame数组"
        NSArray *newDataFrames = [self UserNoticeFramesWithUserNotice:newData];
        
        //追加数据小于一页最大数,删除footerview
        if (newDataFrames.count < VIEW_MAX_COUNT) {
            [self.tableView.footer removeFromSuperview];
        }
        
        //有下一页,添加footerview
        if (self.next) {
            [self addFooter];
        }
        
        //添加frame数组
        [self.userNoticeFrames addObjectsFromArray:newDataFrames];
        
        //刷新表格
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        TSLog(@"UserNoticeViewERROR: %@",error);
    }];
}

/**
 *  将UserNoticeModel模型转为UserNoticeModelFrame模型
 */
- (NSArray *)UserNoticeFramesWithUserNotice:(NSArray *)userNotices
{
    NSMutableArray *frames = [NSMutableArray array];
    for (UserNoticeModel *userNotice in userNotices) {
        UserNoticeFrame *uNotice = [[UserNoticeFrame alloc] init];
        uNotice.userNotice = userNotice;
        [frames addObject:uNotice];
    }
    return frames;
}

//上拉加载更多
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
        return self.systemNoticeArray.count;
    } else {
        return self.userNoticeFrames.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        SystemNoticeCell *cell = [SystemNoticeCell cellWithTableView:tableView withSystemName:_systemNoticeArray[indexPath.row]];
        if (indexPath.row == 0) {
            [cell setTotalStr:self.replyMineTotalCount];
        }
        if (indexPath.row == 1) {
            [cell setTotalStr:self.systemNoticeTotalCount];
        }
        return cell;
    } else {
        // 获得cell
        UserNoticeCell *cell = [UserNoticeCell cellWithTableView:tableView];
        // 给cell传递模型数据
        cell.userNoticeFrame = self.userNoticeFrames[indexPath.row];

        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return 70;
    } else {
        UserNoticeFrame *frame = self.userNoticeFrames[indexPath.row];
        return frame.cellHeight;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            ReplyMineView *replyMineView = [[ReplyMineView alloc] initWithStyle:UITableViewStylePlain];
            replyMineView.title = self.systemNoticeArray[indexPath.row];
            [self.navigationController pushViewController:replyMineView animated:YES];
        }
        
        if (indexPath.row == 1) {
            SystemNoticeView *systemNoticeView = [[SystemNoticeView alloc] initWithStyle:UITableViewStylePlain];
            systemNoticeView.title = self.systemNoticeArray[indexPath.row];
            [self.navigationController pushViewController:systemNoticeView animated:YES];
        }
        
    } else {
        
        UserLetterView *userLetterView = [[UserLetterView alloc] init];
        UserNoticeFrame *userNoticeF = self.userNoticeFrames[indexPath.row];
        
        userLetterView.title = userNoticeF.userNotice.userName;
        userLetterView.otherSideUserId = userNoticeF.userNotice.userId;
        userLetterView.otherSideUserName = userNoticeF.userNotice.userName;
        userLetterView.otherSideUserPhoto = userNoticeF.userNotice.userPhoto;
        [self.navigationController pushViewController:userLetterView animated:YES];
        
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    self.next = NO;
    self.pageButton = @"1";
    [self.userNoticeFrames removeAllObjects];
    
    //获取数据源
    [self loadData];
}
@end
