//
//  DownloadListView.m
//  yyy
//
//  Created by TangXing on 16/3/15.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import "DownloadListView.h"
#import "DownloadListViewCell.h"
#import "DownloadManageView.h"
#import "DownloadFileTool.h"
#import "WSProgressHUD.h"

#import <sys/param.h>
#import <sys/mount.h>

@interface DownloadListView () <UITableViewDelegate,UITableViewDataSource,DownloadManageViewDelegate>

@property (strong,nonatomic) UITableView *listTableView;
@property (strong,nonatomic) DownloadManageView *downloadManage;
@property (strong,nonatomic) UIButton *managerCache;
@property (strong,nonatomic) NSArray *loadingArray;
@property (strong,nonatomic) NSString *manageTitle;
@property (assign,nonatomic) BOOL isHave;
@property (assign,nonatomic) BOOL isLoading;

@end

@implementation DownloadListView

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = YYYColorA(0, 0, 0, 0.5);
    _loadingArray = [DownloadFileTool downloadingFile].downloadingFile;
    if (_loadingArray.count > 0) {
        _downloadManage = [[DownloadManageView downloadManager] init];
        _downloadManage.delegate = self;
    }
    _isHave = NO;
    
    [self setUpUI];
}

- (void)setUpUI
{
    CGFloat downloadViewW = kScreenWidth - 20;
    UIView *downloadView = [[UIView alloc] initWithFrame:CGRectMake(10,kScreenHeight/2 - 10, downloadViewW, kScreenHeight/2)];
    downloadView.layer.masksToBounds = YES;
    downloadView.layer.cornerRadius = 10;
    downloadView.backgroundColor = [UIColor whiteColor];
    
    //创建画质选择button
    UIButton *qualityChoose = [UIButton buttonWithType:UIButtonTypeCustom];
    qualityChoose.backgroundColor = [UIColor clearColor];
    qualityChoose.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [qualityChoose setTitle:@"画质:超清" forState:UIControlStateNormal];
    [qualityChoose setTitleColor:YYYMainColor forState:UIControlStateNormal];
    [qualityChoose setFrame:CGRectMake(10, 0, 65, 30)];
//    [qualityChoose addTarget:self action:@selector(chooseQuality:) forControlEvents:UIControlEventTouchUpInside];
    
    [downloadView addSubview:qualityChoose];
    
    //创建取消界面button
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancel setBackgroundImage:[UIImage imageNamed:@"cancel_downloadView"] forState:UIControlStateNormal];
    [cancel setFrame:CGRectMake(downloadViewW - 30, 10, 20, 20)];
    [cancel addTarget:self action:@selector(cancelDownloadView) forControlEvents:UIControlEventTouchUpInside];
    
    [downloadView addSubview:cancel];
    
    //创建信息文本
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 80, 20)];
    label.text = @"点击集数下载";
    label.textColor = YYYMainColor;
    label.textAlignment = NSTextAlignmentLeft;
    label.font = [UIFont systemFontOfSize:12.0];
    label.backgroundColor = [UIColor clearColor];
    
    [downloadView addSubview:label];
    
    //创建本机剩余内存文本
    UILabel *memory = [[UILabel alloc] initWithFrame:CGRectMake(downloadViewW - 90, 40, 80, 20)];
    memory.textColor = YYYMainColor;
    memory.textAlignment = NSTextAlignmentRight;
    memory.font = [UIFont systemFontOfSize:12.0];
    memory.backgroundColor = [UIColor clearColor];
    memory.text = [self freeDiskSpaceInBytes];
    
    [downloadView addSubview:memory];
                                                                                         //120 ＝ 30 ＋ 40 ＋ 50
    //创建文件下载选择列表                                                                  //其它控件的固定高度总和：120
    _listTableView = [[UITableView alloc] initWithFrame:CGRectMake(10, 70,downloadViewW-20 , kScreenHeight/2 - 120) style:UITableViewStylePlain];
    _listTableView.dataSource = self;
    _listTableView.delegate = self;
    _listTableView.showsVerticalScrollIndicator = NO;
    _listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _listTableView.tableFooterView = [[UIView alloc] init];
    _listTableView.backgroundColor = [UIColor whiteColor];
    
    [downloadView addSubview:_listTableView];
    
    UIButton *cacheAll = [UIButton buttonWithType:UIButtonTypeCustom];
    cacheAll.backgroundColor = [UIColor clearColor];
    cacheAll.titleLabel.font = [UIFont systemFontOfSize:14.0];
    [cacheAll setTitle:@"缓存全部" forState:UIControlStateNormal];
    [cacheAll setTitleColor:YYYMainColor forState:UIControlStateNormal];
    [cacheAll setFrame:CGRectMake(10, kScreenHeight/2 - 40, 100, 30)];
    [cacheAll addTarget:self action:@selector(cacheAllItem) forControlEvents:UIControlEventTouchUpInside];
    
    [downloadView addSubview:cacheAll];
    
    _managerCache = [UIButton buttonWithType:UIButtonTypeCustom];
    _managerCache.backgroundColor = [UIColor clearColor];
    _managerCache.titleLabel.font = [UIFont systemFontOfSize:14.0];
    _manageTitle = @"管理缓存";
    if (_loadingArray.count > 0) {
        _manageTitle = [NSString stringWithFormat:@"管理缓存 %ld",(unsigned long)_loadingArray.count];
    }
    [_managerCache setTitle:_manageTitle forState:UIControlStateNormal];
    [_managerCache setTitleColor:YYYMainColor forState:UIControlStateNormal];
    [_managerCache setFrame:CGRectMake(downloadViewW - 110, kScreenHeight/2 - 40, 100, 30)];
    [_managerCache addTarget:self action:@selector(managerCacheItem) forControlEvents:UIControlEventTouchUpInside];
    
    [downloadView addSubview:_managerCache];
 
    [self.view addSubview:downloadView];
}

#pragma mark - tableviewdelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_dataDict != nil) {
        return 1;
    }
    return _dataSource.count;
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

#pragma mark - tableviewdatasource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UINib *downloadNib = [UINib nibWithNibName:@"DownloadListViewCell" bundle:nil];
    [tableView registerNib:downloadNib forCellReuseIdentifier:@"downloadCell"];
    
    DownloadListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"downloadCell"];
    
    cell.title.text = _dataDict[@"videoName"];
    
    _isHave = [self checkDownloadedFileIsHave:_dataDict[@"videoId"]];
    _isLoading = [self checkFileIsDownloading:_dataDict[@"videoId"]];
    
    if (_isLoading) {
        cell.image.hidden = NO;
        cell.image.image = [UIImage imageNamed:@"download_begin"];
    } else if (_isHave) {
        cell.image.hidden = NO;
        cell.image.image = [UIImage imageNamed:@"download_over"];
    } else {
        cell.image.hidden = YES;
    }
    
    cell.bgView.layer.masksToBounds = YES;
    cell.bgView.layer.cornerRadius = 5;
    cell.bgView.layer.borderWidth = 1.0;
    cell.bgView.layer.borderColor = YYYColor(200, 200, 200).CGColor;
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isHave) {
        [WSProgressHUD showImage:nil status:@"已缓存"];
        return;
    }
    if (!_downloadManage) {
        _downloadManage = [[DownloadManageView downloadManager] init];
        _downloadManage.delegate = self;
    }
    [WSProgressHUD showImage:nil status:@"缓存到本地"];
    [_downloadManage downloadImage:_dataDict newItem:YES];
    [self reloadTableViewAndLoadingTotal];
}

#pragma mark - touchesEvent
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];   //视图中的所有对象
    CGPoint point = [touch locationInView:self.view]; //返回触摸点在视图中的当前坐标
    
    if (point.y < kScreenHeight/2 || point.x < 10 || point.x > kScreenWidth - 10 || point.y > kScreenHeight - 10) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }
}

#pragma mark - otherFouncation
- (void)managerCacheItem
{
    if (_downloadManage) {
        [self.navigationController pushViewController:_downloadManage animated:YES];
    }
}

- (void)cacheAllItem
{
    TSLog(@"cacheAllItem");
}

//获取当前设备剩余存储空间
- (NSString *)freeDiskSpaceInBytes
{
    struct statfs buf;
    long long freespace = -1;
    if(statfs("/var", &buf) >= 0){
        freespace = (long long)(buf.f_bsize * buf.f_bfree);
    }
    
    CGFloat freespaceF = freespace/1024/1024/1024 * 0.01;
    
    if (freespaceF < 1.0) {
        return [NSString stringWithFormat:@"剩余%.2fMB" ,freespaceF * 1024];
    }
    return [NSString stringWithFormat:@"剩余%.2fGB" ,freespaceF];
}

- (void)cancelDownloadView
{
    _downloadManage.delegate = nil;
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (void)chooseQuality:(UIButton *)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *normal = [UIAlertAction actionWithTitle:@"标清" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        
        [sender setTitle:@"画质:标清" forState:UIControlStateNormal];
    }];
    
    UIAlertAction *hight = [UIAlertAction actionWithTitle:@"高清" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
        
        [sender setTitle:@"画质:高清" forState:UIControlStateNormal];
    }];
    
    UIAlertAction *veryHight = [UIAlertAction actionWithTitle:@"超清" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction *action) {
       
        [sender setTitle:@"画质:超清" forState:UIControlStateNormal];
    }];
    
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:(UIAlertActionStyleCancel) handler:^(UIAlertAction *action) {
        
    }];
    
    [alertController addAction:normal];
    [alertController addAction:hight];
    [alertController addAction:veryHight];
    [alertController addAction:cancel];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

//检查当前下载的视频是否存在
- (BOOL)checkDownloadedFileIsHave:(NSString *)videoId
{
    //文件名
//    NSString *fileName = [NSString stringWithFormat:@"%@",videoId];
    NSString *directoryPath = [NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),videoId];
    NSString *uniquePath=[directoryPath stringByAppendingPathComponent:@"video.mp4"];
    BOOL isHave = [[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
    return isHave;
}

//检查视频是否正在下载中
- (BOOL)checkFileIsDownloading:(NSString *)videoId
{
    //下载中的视频
    NSArray *loadingArray = [DownloadFileTool downloadingFile].downloadingFile;
    NSString *loadingVideoId;
    for (int i = 0; i < loadingArray.count; i++) {
        loadingVideoId = loadingArray[i][@"videoId"];
        if ([loadingVideoId isEqualToString:videoId]) {
            return YES;
        }
    }
    return NO;
}

//实时刷新
- (void)reloadTableViewAndLoadingTotal
{
    [_listTableView reloadData];
    
    _loadingArray = [DownloadFileTool downloadingFile].downloadingFile;
    if (_loadingArray.count > 0) {
        _manageTitle = [NSString stringWithFormat:@"管理缓存 %ld",(unsigned long)_loadingArray.count];
    } else {
        _manageTitle = @"管理缓存";
    }
    [_managerCache setTitle:_manageTitle forState:UIControlStateNormal];
}

- (void)downloadSuccess
{
    [self reloadTableViewAndLoadingTotal];
}

- (void)viewWillAppear:(BOOL)animated
{
    _downloadManage.delegate = self;
    [self reloadTableViewAndLoadingTotal];
}

- (void)viewWillDisappear:(BOOL)animated
{
    _downloadManage.delegate = nil;
}
@end
