//
//  UserLetterView.m
//  yyy
//
//  Created by TangXing on 16/4/15.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import "UserLetterView.h"
#import "UserLetterModel.h"
#import "UserLetterFrame.h"
#import "UserLetterCell.h"

#import "WriteView.h"

#import "YYYHttpTool.h"
#import "MJExtension.h"
#import "MJRefresh.h"

#define TIME_DIFF_MIN 2

@interface UserLetterView () <UITableViewDelegate,UITableViewDataSource,WriteViewDelegate>

@property (strong,nonatomic) UITableView *letterTableView; //展示数据的tableview

@property (assign,nonatomic) BOOL next; //是否有下一页
@property (assign,nonatomic) BOOL isTableviewBottom;    //判断tableview底部是否处于最下面的边界(letterTableViewMaxY = kScreenHeight)

@property (copy,nonatomic)   NSString *startTimestamp; //发送新私信时，最后一条私信的时间
@property (copy,nonatomic)   NSString *endTimestamp;   //加载历史私信时，第一条私信的时间

@property (copy,nonatomic)   NSString *page;    //当前页
@property (copy,nonatomic)   NSString *pageButton;  //分页按钮

@property (strong,nonatomic) NSMutableArray *userLetterFrames;  //数据模型frame数组

@property (strong,nonatomic) WriteView *writeView;  //文本框

@end

@implementation UserLetterView
#pragma mark - 实例化变量
- (NSMutableArray *)userLetterFrames
{
    if (!_userLetterFrames) {
        self.userLetterFrames = [NSMutableArray array];
    }
    return _userLetterFrames;
}

- (UITableView *)letterTableView
{
    /** 64为navigationbar的高,40位writeview的高 */
    if (!_letterTableView) {
        self.letterTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 40) style:UITableViewStylePlain];
        self.letterTableView.delegate = self;
        self.letterTableView.dataSource = self;
        self.letterTableView.separatorStyle = UITableViewCellSeparatorStyleNone;//隐藏线条
        self.letterTableView.showsVerticalScrollIndicator = NO;//不显示右滑块
    }
    
    return _letterTableView;
}

- (WriteView *)writeView
{
    if (!_writeView) {
        self.writeView = [[WriteView alloc] init];
        self.writeView.writeDelegate = self;
        [self.writeView setWriteViewKeyboardType:YYYKeyboardTypeDefault];
        [self.writeView setWriteViewReturnKeyType:YYYReturnKeySend];
    }
    
    return _writeView;
}

#pragma mark - view入口
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.next = NO;
    self.pageButton = @"1";
    self.isTableviewBottom = YES;
    
    [self.view addSubview:self.letterTableView];
    [self.view addSubview:self.writeView];
    
    //获取数据
    [self loadDataWithContent:nil andURL:YYYUserLetterURL];
}

#pragma mark 数据获取、解析
//获取私信数据
- (void)loadDataWithContent:(NSString *)newContent andURL:(NSString *)url
{
    NSDictionary *params;
    if (newContent == nil) {
        params = @{@"pageButton":_pageButton,@"otherSideUserId":_otherSideUserId};
    } else {
        UserLetterFrame *lastUserLetterF = [self.userLetterFrames lastObject];
        self.startTimestamp = lastUserLetterF.userLetter.sendTime;
        params = @{@"otherSideUserId":_otherSideUserId,@"content":newContent,@"startTimestamp":self.startTimestamp};
    }
    
    [YYYHttpTool post:url params:params success:^(id json) {
        
        //取，是否有下一页，的值
        if (newContent == nil) {
            self.next = [json[@"next"] boolValue];
            self.page = json[@"page"];
            if (self.next) {
                [self addHeader];
            }
        }
        
        // 将json数据里的字符串数组转换成ios字符串,返回新生成的数据数组,便于模型解析
        NSArray *dataArray = [[json[@"letterList"] creatModelArrayWithDictionaryKey:@"content"] mutableCopy];
        
        //添加私信对象信息到数据源数组
        [self addOtherSideInfoToArray:dataArray];
        
        //判断时间是否显示,添加bool值到数据源数组
        dataArray = [self addTimehiddenToArray:dataArray];
        
        // 将 "消息字典"数组 转为 "消息模型"数组
        NSArray *newData = [UserLetterModel objectArrayWithKeyValuesArray:dataArray];
        
        // 将"消息模型数组"转换为"消息frame数组"
        NSArray *newDataFrames = [self UserLetterFramesWithArray:newData];
        
        //添加frame数组
        [self.userLetterFrames addObjectsFromArray:newDataFrames];
        
        //刷新tableview
        [self.letterTableView reloadData];
        
        //重新获取数据即为把“未读”变为“已读”
        [self upDataUserLetterToReaded];
        
        //显示tableview的最后一行
        [self.letterTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.userLetterFrames count] - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
        
        //结束刷新
        [self.letterTableView.header endRefreshing];
        
    } failure:^(NSError *error) {
        TSLog(@"UserLetterViewERROR: %@",error);
    }];
}

//添加header刷新控件
- (void)addHeader
{
    NSMutableArray *idleImages = [NSMutableArray arrayWithObject:[UIImage imageNamed:@"profile_0"]];
    NSMutableArray *pullingImages = [NSMutableArray arrayWithObject:[UIImage imageNamed:@"profile_0"]];
    NSMutableArray *refreshimages = [NSMutableArray array];
    for (NSUInteger i = 0; i < 4; i++) {
        UIImage *img = [UIImage imageNamed:[NSString stringWithFormat:@"profile_%lu",i]];
        [refreshimages addObject:img];
    }
    
    
    MJRefreshGifHeader *header = [MJRefreshGifHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadLetterHistory)];
    
    header.lastUpdatedTimeLabel.hidden = YES;
    [header setImages:idleImages forState:MJRefreshStateIdle];
    [header setImages:pullingImages forState:MJRefreshStatePulling];
    [header setImages:refreshimages forState:MJRefreshStateRefreshing];
    
    self.letterTableView.header = header;
}

//加载历史私信
- (void)loadLetterHistory
{
    // 1.拼接请求参数
    UserLetterFrame *firstUserLetterF = [self.userLetterFrames firstObject];
    self.endTimestamp = firstUserLetterF.userLetter.sendTime;
    NSDictionary *params = @{@"pageButton":_pageButton,@"otherSideUserId":_otherSideUserId,@"endTimestamp":self.endTimestamp};
    
    if (self.next) {
        // 2.发送请求
        [YYYHttpTool post:YYYUserLetterURL params:params success:^(id json) {
            
            self.next = [json[@"next"] boolValue];
            self.page = json[@"page"];
            
            if (!self.next) {
                [self.letterTableView.header removeFromSuperview];
            }
            
            // 将json数据里的字符串数组转换成ios字符串,返回新生成的数据数组,便于模型解析
            NSArray *dataArray = [[json[@"letterList"] creatModelArrayWithDictionaryKey:@"content"] mutableCopy];
            
            //添加私信对象信息到数据源数组
            [self addOtherSideInfoToArray:dataArray];
            
            //判断时间是否显示,添加bool值到数据源数组
            dataArray = [self addTimehiddenToArray:dataArray];
            
            // 将 "消息字典"数组 转为 "消息模型"数组
            NSArray *newData = [UserLetterModel objectArrayWithKeyValuesArray:dataArray];
            
            //  将"消息模型数组"转换为"消息frame数组"
            NSArray *newDataFrames = [self UserLetterFramesWithArray:newData];
            
            // 将最新的私信数据，添加到总数组的最前面
            NSRange range = NSMakeRange(0, newDataFrames.count);
            NSIndexSet *set = [NSIndexSet indexSetWithIndexesInRange:range];
            [self.userLetterFrames insertObjects:newDataFrames atIndexes:set];
            
            //刷新tableview
            [self.letterTableView reloadData];
            
            //保持刷新前第一行在顶部(刷新前的首行的下标即为dataArray的count)
            [self.letterTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:dataArray.count inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
            
            // 结束刷新(隐藏footer)
            [self.letterTableView.header endRefreshing];
            
            //重新获取数据即为把“未读”变为“已读”
            [self upDataUserLetterToReaded];
            
        } failure:^(NSError *error) {
            TSLog(@"LoadMoreDataUserLetterError:%@",error);
        }];
        
    } else {
        [self.letterTableView.header endRefreshing];
    }
}

/**
 *  将UserLetterModel模型转为UserLetterModelFrame模型
 */
- (NSArray *)UserLetterFramesWithArray:(NSArray *)array
{
    NSMutableArray *frames = [NSMutableArray array];
    for (UserLetterModel *userLetter in array) {
        UserLetterFrame *uLetter = [[UserLetterFrame alloc] init];
        uLetter.userLetter = userLetter;
        [frames addObject:uLetter];
    }
    return frames;
}

/**
 *  添加私信对象信息到数据源数组,并且判断时间差,显示时间与否
 */
- (void)addOtherSideInfoToArray:(NSArray *)array
{
    for (int i = 0; i < array.count ; i++) {
        NSMutableDictionary *userLetterDic = [array[i] mutableCopy];
        [userLetterDic setObject:_otherSideUserName forKey:@"otherSideUserName"];
        [userLetterDic setObject:_otherSideUserPhoto forKey:@"otherSideUserPhoto"];
    }
}

//添加时间是否显示的属性到数据源数组
- (NSArray *)addTimehiddenToArray:(NSArray *)array
{
    NSMutableArray *newArray = [NSMutableArray array];
    NSMutableDictionary *userLetterDic;
    int row = (int)array.count - 1;
    for (int i = row ; i >= 0; i--) {
        
        userLetterDic = [array[i] mutableCopy];
        BOOL timehidden;
        
        if (i == row && self.startTimestamp == nil) {
            
            timehidden = NO;
            self.startTimestamp = array[i][@"sendTime"];
            
        } else if (i == 0 && self.endTimestamp != nil) {
            
            timehidden = [self calTimeDifferenceWithArray:array AndIndex:i];
            
            //取出当前模型frame数组里的数据模型，改变它的timehidden属性(也就是第一个,数组首位)
            UserLetterFrame *userFramesArrayLastObject = [self.userLetterFrames firstObject];
            UserLetterModel *lastUserLetter = userFramesArrayLastObject.userLetter;
            lastUserLetter.timehidden = [self calTimeDifferenceWithArray:array AndIndex:-1];
            
            //根据timehidden属性，重新生成模型frame
            UserLetterFrame *newUserLetterFrame = [[UserLetterFrame alloc] init];
            newUserLetterFrame.userLetter = lastUserLetter;
            
            //删除旧的firstobject的模型frame，把新生成的模型frame放到删除的位置(也就是第一个,数组首位)
            [self.userLetterFrames removeObjectAtIndex:0];
            [self.userLetterFrames insertObject:newUserLetterFrame atIndex:0];
            
        } else {
            timehidden = [self calTimeDifferenceWithArray:array AndIndex:i];
        }
        
        [userLetterDic setObject:[NSNumber numberWithBool:timehidden] forKey:@"timehidden"];
        
        [newArray addObject:userLetterDic];
    }
    
    self.startTimestamp = nil;
    self.endTimestamp = nil;
    
    return newArray;
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
    return self.userLetterFrames.count;
}

//每一个分组下对应的tableviewCell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserLetterFrame *frame = self.userLetterFrames[indexPath.row];
    return frame.cellHeight;
}

//设置每行对应的cell(展示的内容)
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UserLetterCell *cell = [UserLetterCell cellWithTableView:tableView];
    cell.userLetterFrame = self.userLetterFrames[indexPath.row];
    
    return cell;
}

#pragma mark - tableViewDelegate
//cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.writeView hiddenKeyboard];
    self.letterTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - NaviBarHeight - 40);
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.writeView hiddenKeyboard];
    self.letterTableView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - NaviBarHeight - 40);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (fabs(scrollView.contentSize.height - scrollView.frame.size.height - scrollView.contentOffset.y)<1.f) {
        self.isTableviewBottom = YES;
    } else {
        self.isTableviewBottom = NO;
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (fabs(scrollView.contentSize.height - scrollView.frame.size.height - scrollView.contentOffset.y)<1.f) {
        self.isTableviewBottom = YES;
    } else {
        self.isTableviewBottom = NO;
    }
}

#pragma mark - writeViewDelegate
- (void)sendContent
{
    [self loadDataWithContent:[self.writeView retuerTextViewText] andURL:YYYUserLetterAddContent];
}

- (void)returnWriteViewFrame:(CGRect)Frame
{
    self.letterTableView.frame = CGRectMake(0, 0, kScreenWidth, Frame.origin.y);
    if (self.isTableviewBottom) {
        [self.letterTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[self.userLetterFrames count] - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

#pragma mark - timeDifference
- (BOOL)calTimeDifferenceWithArray:(NSArray *)array AndIndex:(NSInteger)index
{
    NSString *startDateStr,*endDateStr;
    
    if (index == -1) {
        startDateStr = self.startTimestamp;
        endDateStr = self.endTimestamp;
    } else {
        endDateStr = array[index][@"sendTime"];
        startDateStr = self.startTimestamp;
    }
    
    NSDate *endDate = [endDateStr stringToDate:[endDateStr substringToIndex:16]];
    NSDate *startDate  = [startDateStr stringToDate:[startDateStr substringToIndex:16]];
    
    long timeDifference = [self calMinuteWithStartDate:startDate EndDate:endDate];
    
    self.startTimestamp = endDateStr;
    
    if (timeDifference >= TIME_DIFF_MIN) {
        return NO;
    } else {
        return YES;
    }
}

/**
 *  计算两个时间的时间差,返回分钟
 */
- (long)calMinuteWithStartDate:(NSDate *)startDate EndDate:(NSDate *)endDate
{
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    unsigned int unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
    
    NSDateComponents *d = [cal components:unitFlags fromDate:startDate toDate:endDate options:0];
    
    long minute = [d hour] * 60 + [d minute] + [d second] / 60;
    
    return minute;
}

#pragma mark 更新未读条数
//更新此私信对象的未读消息为已读
- (void)upDataUserLetterToReaded
{
    NSDictionary *params = @{@"otherSideUserId":_otherSideUserId};
    [YYYHttpTool post:YYYUserLetterUpdataToReaded params:params success:^(id json) {
    } failure:^(NSError *error) {
        TSLog(@"updataOtherSideUserLetterToReadedERROR:%@",error);
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [self upDataUserLetterToReaded];
}
@end
