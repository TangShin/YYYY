//
//  SystemNoticeView.m
//  yyy
//
//  Created by TangXing on 16/4/26.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import "SystemNoticeView.h"
#import "SystemNoticeModel.h"
#import "SystemNoticeFrame.h"
#import "SystemLetterCell.h"

#import "UserInfoTool.h"
#import "YYYHttpTool.h"
#import "MJExtension.h"
#import "MJRefresh.h"

@interface SystemNoticeView ()

@property (assign,nonatomic) BOOL next;
@property (copy,nonatomic) NSString *page;
@property (copy,nonatomic) NSString *pageButton;

@property (strong,nonatomic) NSMutableArray *systemNoticeFrames;

@end

@implementation SystemNoticeView

- (NSMutableArray *)systemNoticeFrames
{
    if (!_systemNoticeFrames) {
        self.systemNoticeFrames = [NSMutableArray array];
    }
    return _systemNoticeFrames;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;//隐藏线条
    self.tableView.showsVerticalScrollIndicator = NO;//不显示右滑块
    
    [self loadData];
}

//需要导入MJExtension.h,并且与ArrayFramesWithArray代码块联用(YYYHttpTool为网络请求管理类)
//并且为数组扩展里creatModelArrayFromArray:withDictionaryKey:方法
- (void)loadData
{
    [YYYHttpTool post:YYYSystemNoticeURL params:nil success:^(id json) {
        
        self.next = json[@"next"];
        self.page = json[@"page"];
        // 将json数据里的字符串数组转换成ios字符串,返回新生成的数据数组,便于模型解析
        NSArray *dataArray = [json[@"letterList"] creatModelArrayWithDictionaryKey:@"content"];
    
        //newNoticeList判断是否有数据
        if (dataArray.count > 0) {
            
            self.next = [json[@"next"] boolValue];
            self.page = json[@"page"];
            
            // 将 "系统消息字典"数组 转为 "系统消息模型"数组
            NSArray *newData = [SystemNoticeModel objectArrayWithKeyValuesArray:dataArray];
            
            // 将"系统消息模型数组"转换为"系统消息frame数组"
            NSArray *newDataFrames = [self ArrayFramesWithArray:newData];
            
            // 将 SystemNotice数组 转为 SystemNoticeFrame数组
            // 如果有下一页,将新得到的消息模型数组追加到数组的最后面
            if (self.next) {
                
                self.pageButton = @"下页";
//                [self addFooter];
                
            } else {
                
                self.tableView.tableFooterView = [[UIView alloc] init];
                [self.systemNoticeFrames removeAllObjects];
            }
            
            //添加frame数组
            [self.systemNoticeFrames addObjectsFromArray:newDataFrames];
            
        } else {
            self.tableView.tableFooterView = [[UIView alloc] init];
        }
        
        //刷新表格
        [self.tableView reloadData];
        
    } failure:^(NSError *error) {
        TSLog(@"SystemNoticeERROR: %@",error);
    }];
}

/**
 *  将模型转为frame模型
 */
- (NSArray *)ArrayFramesWithArray:(NSArray *)array
{
    NSMutableArray *frames = [NSMutableArray array];
    for (SystemNoticeModel *systemNotice in array) {
        SystemNoticeFrame *systemNoticeF = [[SystemNoticeFrame alloc] init];
        systemNoticeF.systemNotice = systemNotice;
        [frames addObject:systemNoticeF];
    }
    return frames;
}

#pragma mark - tableViewDataSource
//设置每个tableview的分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//设置每个分组下tableview的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.systemNoticeFrames.count;
}

//每一个分组下对应的tableviewCell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SystemNoticeFrame *frame = self.systemNoticeFrames[indexPath.row];
    return frame.cellHeight;
}

//设置每行对应的cell(展示的内容)
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SystemLetterCell *cell = [SystemLetterCell cellWithTableView:tableView];
    cell.systemNoticeFrame = self.systemNoticeFrames[indexPath.row];
    
    return cell;
}

//cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //取消cell选中状态
    TSLog(@"123");
}

#pragma mark 更新未读条数
//更新此私信对象的未读消息为已读
- (void)upDataUserLetterToReaded
{
    [YYYHttpTool post:YYYSystemLetterUpdataToReaded params:nil success:^(id json) {
    } failure:^(NSError *error) {
        TSLog(@"updataSystemLetterToReaded ERROR:%@",error);
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self upDataUserLetterToReaded];
}
@end
