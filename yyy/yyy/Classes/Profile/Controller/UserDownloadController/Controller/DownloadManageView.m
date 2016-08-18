//
//  DownloadManageView.m
//  yyy
//
//  Created by TangXing on 16/3/16.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import "DownloadManageView.h"
#import "DownloadedCell.h"
#import "DownloadingCell.h"

#import "YYYDownloadManager.h"

#import "YYYWeakTimer.h"
#import "DownloadFileTool.h"
#import "ManageBottomView.h"
#import "GlobalVariables.h"

#import "UIImageView+WebCache.h"

@interface DownloadManageView () <UITableViewDelegate,UITableViewDataSource,ManageBottomDelegate>

@property (strong,nonatomic) AFHTTPRequestOperation *operation;                 //AFN网络请求对象
@property (strong,nonatomic) ManageBottomView *manageBottom;                    //底部管理视图
@property (strong,nonatomic) YYYWeakTimer *timer;                               //计时器
@property (retain,nonatomic) GlobalVariables *globalVariables;                  //全局变量管理类

@property (strong,nonatomic) NSString *targetPath;                              //下载地址
@property (assign,nonatomic) CGFloat percent;                                   //progress值
@property (assign,nonatomic) CGFloat receivedContentLength;                     //已下载大小
@property (assign,nonatomic) CGFloat totalContentLength;                        //文件总大小
@property (assign,nonatomic) long long oldTRCL;                                 //上一秒的下载进度

@property (strong,nonatomic) UISegmentedControl *segmentedControl;              //分页选择器
@property (strong,nonatomic) UITableView *dataTableView;                        //数据展示tableview
@property (strong,nonatomic) NSMutableArray *downloadedArray;                   //已下载的数组
@property (strong,nonatomic) NSMutableArray *downloadlingArray;                 //正在下载的数组
@property (strong,nonatomic) UIButton *rightBarButton;                          //rightbarbutton
@property (assign,nonatomic) NSInteger deleteItemCount;                         //需要删除的数量
@property (assign,nonatomic) BOOL editState;                                    //是否正在编辑模式

@end

@implementation DownloadManageView

+ (instancetype)downloadManagerAlloc
{
    return [super allocWithZone:nil];
}

+ (DownloadManageView *)downloadManager
{
    static DownloadManageView *downloadManager;
    
    if (downloadManager == nil) {
        downloadManager = [[DownloadManageView downloadManagerAlloc] init];
        downloadManager.downloadedArray = [[NSMutableArray alloc] init];
        downloadManager.downloadlingArray = [[NSMutableArray alloc] init];
        downloadManager.globalVariables = GlobalVariables.getInstance;
        downloadManager.editState = NO;
        downloadManager.oldTRCL = 0;
        downloadManager.percent = 0;
        downloadManager.deleteItemCount = 0;
        downloadManager.receivedContentLength = 0;
        downloadManager.totalContentLength = 0;
        
        //检查沙盒是否有已下载完成的项目
        DownloadedFile *downloadedFile = [DownloadFileTool downloadedFile];
        for (NSDictionary *dic in downloadedFile.downloadedFile) {
            [downloadManager.downloadedArray addObject:dic];
        }
        //检查沙盒是否有未下载完成的项目
        DownloadingFile *downloadingFile = [DownloadFileTool downloadingFile];
        for (NSDictionary *dic in downloadingFile.downloadingFile) {
            [downloadManager.downloadlingArray addObject:dic];
        }
    }
    
    return downloadManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setUpUI];
}

- (void)setUpUI
{
    self.view.backgroundColor = [UIColor whiteColor];
 
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem itemWithTarget:self action:@selector(editingFile:) name:@"编辑" color:YYYMainColor];
    
    _segmentedControl = [ [ UISegmentedControl alloc ] initWithItems:nil];
    [_segmentedControl insertSegmentWithTitle:@"已下载" atIndex: 0 animated: NO ];
    [_segmentedControl insertSegmentWithTitle:@"正在下载" atIndex: 1 animated: NO ];
    _segmentedControl.selectedSegmentIndex = 0;
    _segmentedControl.tintColor = YYYMainColor;
    [_segmentedControl addTarget:self action:@selector(segementValueChange) forControlEvents:UIControlEventValueChanged];
    
    self.navigationItem.titleView = _segmentedControl;
    
    //创建文件下载选择列表
    _dataTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,kScreenHeight - 64 - 40) style:UITableViewStylePlain];
    _dataTableView.dataSource = self;
    _dataTableView.delegate = self;
    _dataTableView.showsVerticalScrollIndicator = NO;
    _dataTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _dataTableView.tableFooterView = [[UIView alloc] init];
    _dataTableView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:_dataTableView];
    
    //创建底部管理 64为navigationbar的高度，40为managebottom的高度
    _manageBottom = [[ManageBottomView alloc] initWithFrame:CGRectMake(0,kScreenHeight - 64 - 40,kScreenWidth,40)];
    _manageBottom.delegate = self;
    [_manageBottom Managemode:0];
    
    [self.view addSubview:_manageBottom];
}

#pragma mark - Table view data source
//设置tableview的高度自动获取
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 87;
}

////初始加载tableviewcell时，给出预估高度
//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return UITableViewAutomaticDimension;
//}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_segmentedControl.selectedSegmentIndex == 0) {
        return _downloadedArray.count;
    } else {
        return _downloadlingArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UINib *downloadingNib = [UINib nibWithNibName:@"DownloadingCell" bundle:nil];
    [tableView registerNib:downloadingNib forCellReuseIdentifier:@"downloadingCell"];
    
    UINib *downloadedNib = [UINib nibWithNibName:@"DownloadedCell" bundle:nil];
    [tableView registerNib:downloadedNib forCellReuseIdentifier:@"downloadedCell"];
    
    if (_segmentedControl.selectedSegmentIndex == 1 && _downloadlingArray.count > 0) {
    
        DownloadingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"downloadingCell"];
        cell.downloadName.text = _downloadlingArray[indexPath.row][@"videoName"];
        
        cell.startAndPause.tag = indexPath.row;
        [cell.startAndPause addTarget:self action:@selector(changeStatus:) forControlEvents:UIControlEventTouchUpInside];
        
        if (_globalVariables.downloadingCellIndex == indexPath.row && _globalVariables.downloading) {
            
            cell.progress.progress = _percent;
            cell.downloadSpeed.text = [self calDownloadSpeed];
            cell.downloadTotalCal.text = [self calReceivedContentLength:_receivedContentLength totalContentLength:_totalContentLength];
            [cell.startAndPause setImage:[UIImage imageNamed:@"pause_btn"] forState:UIControlStateNormal];
            
        } else {
            
            cell.progress.progress = [_downloadlingArray[indexPath.row][@"progress"] floatValue];
            
            CGFloat receivedContentLength = [_downloadlingArray[indexPath.row][@"receivedContentLength"] floatValue];
            CGFloat totalContentLength = [_downloadlingArray[indexPath.row][@"totalContentLength"] floatValue];
            
            cell.downloadTotalCal.text = [self calReceivedContentLength:receivedContentLength totalContentLength:totalContentLength];
            
            BOOL queue = [_downloadlingArray[indexPath.row][@"queue"] boolValue];
            if (queue) {
                [cell.startAndPause setImage:[UIImage imageNamed:@"pause_btn"] forState:UIControlStateNormal];
                cell.downloadSpeed.text = @"等待下载";
            } else {
                [cell.startAndPause setImage:[UIImage imageNamed:@"play_btn"] forState:UIControlStateNormal];
                cell.downloadSpeed.text = @"点击继续下载";
            }
            
        }
        
        NSString *imgPath = [NSString stringWithFormat:@"%@/Documents/%@/preview.png",NSHomeDirectory(),_downloadlingArray[indexPath.row][@"videoId"]];
        cell.fileImage.image = [UIImage imageWithContentsOfFile:imgPath];
        cell.fileImage.layer.masksToBounds = YES;
        cell.fileImage.layer.cornerRadius = 5;
        
        cell.mask.layer.masksToBounds = YES;
        cell.mask.layer.cornerRadius = 5;

        return cell;
        
    } else if (_downloadedArray.count > 0) {
     
        DownloadedCell *cell = [tableView dequeueReusableCellWithIdentifier:@"downloadedCell"];
        
        NSString *imgPath = [NSString stringWithFormat:@"%@/Documents/%@/preview.png",NSHomeDirectory(),_downloadedArray[indexPath.row][@"videoId"]];
        cell.image.image = [UIImage imageWithContentsOfFile:imgPath];
        cell.image.layer.masksToBounds = YES;
        cell.image.layer.cornerRadius = 5;
        
        cell.title.text = _downloadedArray[indexPath.row][@"videoName"];
        cell.info.text = _downloadedArray[indexPath.row][@"uploadUserName"];
        
        return cell;
    }
    return nil;
}

//cell点击操作
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_editState) {
        
        NSMutableDictionary *dict;
        if (_segmentedControl.selectedSegmentIndex == 0) {
            dict = _downloadedArray[indexPath.row];
        } else {
            dict = _downloadlingArray[indexPath.row];
        }
        
        [dict setObject:[NSNumber numberWithBool:YES] forKey:@"isDelete"];
        _deleteItemCount ++;
        [_manageBottom checkDeleteBtn:[NSString stringWithFormat:@"删除选中(%ld)",(long)_deleteItemCount] enable:YES];
    
    } else {
    //取消cell选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

        if (_segmentedControl.selectedSegmentIndex == 0) {
            TSLog(@"我可以播放已下载的视频啦～");
        }
    }
}

//cell取消选中
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_deleteItemCount > 0) {
        NSMutableDictionary *dict;
        if (_segmentedControl.selectedSegmentIndex == 0) {
            dict = _downloadedArray[indexPath.row];
        } else {
            dict = _downloadlingArray[indexPath.row];
        }
        
        [dict setObject:[NSNumber numberWithBool:NO] forKey:@"isDelete"];
        _deleteItemCount --;
        
        if (_deleteItemCount == 0) {
            [_manageBottom checkDeleteBtn:@"删除选中" enable:NO];
        } else {
            [_manageBottom checkDeleteBtn:[NSString stringWithFormat:@"删除选中(%ld)",(long)_deleteItemCount] enable:YES];
        }
    }
}

//确认编辑类型
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_editState) {
        return UITableViewCellEditingStyleDelete | UITableViewCellEditingStyleInsert;
    } else {
        return UITableViewCellEditingStyleNone;
    }
}

#pragma mark ManageBottomViewDelegate
- (void)deleteItem:(UIButton *)sender
{
    if (_segmentedControl.selectedSegmentIndex == 0) {
        for (int i = 0; i < _deleteItemCount; i++) {
            for (int j = 0; j < _downloadedArray.count; j++) {
                BOOL isdelete = [_downloadedArray[j][@"isDelete"] boolValue];
                if (isdelete) {
                    [self deleteDownloadedItem:j];
                    break;
                }
            }
        }
    } else {
        for (int i = 0; i < _deleteItemCount; i++) {
            for (int j = 0; j < _downloadlingArray.count; j++) {
                BOOL isdelete = [_downloadlingArray[j][@"isDelete"] boolValue];
                if (isdelete) {
                    [self deleteVideoFileWithDictionary:_downloadlingArray[j]];
                    [self deleteDownloadingItem:j];
                    break;
                }
            }
        }
    }
    
    _deleteItemCount = 0;
    [_manageBottom checkDeleteBtn:@"删除选中" enable:NO];
    
    if (_downloadedArray.count > 0 || _downloadlingArray.count > 0) {
        
    } else {
        [_dataTableView setEditing:NO animated:YES];
        [_rightBarButton setTitle:@"编辑" forState:UIControlStateNormal];
        [_manageBottom Managemode:_segmentedControl.selectedSegmentIndex];
    }
    [_dataTableView reloadData];
}

- (void)startItem:(UIButton *)sender
{
    if (_downloadlingArray.count < 1) {
        return;
    }
    
    [_rightBarButton setTitle:@"编辑" forState:UIControlStateNormal];
    [_dataTableView setEditing:NO animated:YES];
    [self startAllItem];
    if (!_globalVariables.downloading) {
        _globalVariables.downloadingCellIndex = 0;
        [self downloadImage:_downloadlingArray[_globalVariables.downloadingCellIndex] newItem:NO];
    }
}

- (void)pauseItem:(UIButton *)sender
{
    if (_downloadlingArray.count < 1) {
        return;
    }
    [_rightBarButton setTitle:@"编辑" forState:UIControlStateNormal];
    [_dataTableView setEditing:NO animated:YES];
    [self pauseAllItem];
    [self downloadPause];
}

- (void)startAllItem
{
    for (NSMutableDictionary *dic in _downloadlingArray) {
        [dic setObject:[NSNumber numberWithBool:YES] forKey:@"queue"];
    }
}

- (void)pauseAllItem
{
    for (NSMutableDictionary *dic in _downloadlingArray) {
        [dic setObject:[NSNumber numberWithBool:NO] forKey:@"queue"];
    }
}

#pragma mark segementclick
- (void)segementValueChange
{
    NSInteger selectedSegment = _segmentedControl.selectedSegmentIndex;
    if (selectedSegment == 0) {
        [_manageBottom Managemode:0];
    } else {
        [_manageBottom Managemode:1];
    }
    
    _editState = NO;
    [_dataTableView setEditing:NO animated:YES];
    if (_rightBarButton) {
        [_rightBarButton setTitle:@"编辑" forState:UIControlStateNormal];
    }
    _deleteItemCount = 0;
    [_manageBottom checkDeleteBtn:@"删除选中" enable:NO];
    [_dataTableView reloadData];
}

#pragma mark navigationRightBarButtonClick
- (void)editingFile:(UIButton *)sender
{
    if (_globalVariables.downloading) {
        [self downloadPause];
    }
    
    if (_segmentedControl.selectedSegmentIndex == 0 && _downloadedArray.count < 1) {
        return;
    }
    
    if (_segmentedControl.selectedSegmentIndex == 1 && _downloadlingArray.count < 1) {
        return;
    }
    
    if (_editState) {
        [sender setTitle:@"编辑" forState:UIControlStateNormal];
        _manageBottom.deleteBtn.hidden = YES;
        _editState = NO;
        _deleteItemCount = 0;
        
        [_manageBottom checkDeleteBtn:@"删除选中" enable:NO];
        [_manageBottom Managemode:_segmentedControl.selectedSegmentIndex];
    } else {
        [sender setTitle:@"完成" forState:UIControlStateNormal];
        _manageBottom.deleteBtn.hidden = NO;
        _editState = YES;
    }
    _rightBarButton = sender;
    [self.dataTableView setEditing:!self.dataTableView.editing animated:YES];
}

//暂停/下载 按钮
- (void)changeStatus:(UIButton *)sender
{
    if (_globalVariables.downloadingCellIndex == -1) {
        _globalVariables.downloadingCellIndex = sender.tag;
    }
    
    if (_globalVariables.downloadingCellIndex != sender.tag) {
            
        [self addToDownloadQueue:sender.tag];
        if (!_globalVariables.downloading) {
            [self checkAutoDownloadItem];
        }
            
    } else {
        if (_globalVariables.downloading) {
            [self downloadPause];
            [sender setImage:[UIImage imageNamed:@"play_btn"] forState:UIControlStateNormal];
        } else {
            [self addToDownloadQueue:sender.tag];
            [self downloadImage:_downloadlingArray[sender.tag] newItem:NO];
            [sender setImage:[UIImage imageNamed:@"pause_btn"] forState:UIControlStateNormal];
        }
    }
}

#pragma mark - YYYDownloadManager
//图片下载开始
- (void)downloadImage:(NSDictionary *)dictionary newItem:(BOOL)isNew
{
    NSString *urlString = dictionary[@"videoPreviewAddr"];
    NSString *imgId = dictionary[@"videoId"];
    
    if (isNew) {
        
        [self addDownloadingItem:dictionary];
        
        if (_globalVariables.downloading) {
            
            return;
            
        } else {
            
            [self checkAutoDownloadItem];
            
        }
    }
    
    BOOL picHave = [self checkDownloadedFileIsHave:imgId];
    if (picHave) {
        
        [self downloadStart:dictionary];
        
    } else {
        
        _globalVariables.downloading = YES;
        self.operation = [YYYDownloadManager downloadFileWithURLString:urlString toDirectory:imgId cachePath:@"preview.png" progress:^(CGFloat progress, CGFloat totalMBRead, CGFloat totalMBExpectedToRead) {
            
        } success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            _globalVariables.downloading = NO;
            [_dataTableView reloadData];
            [self downloadStart:dictionary];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            _globalVariables.downloading = NO;
            if (error.code == -999) {
                TSLog(@"Task1 -> Maybe you pause download.");
            }
        }];
    }
}

//视频下载开始
- (void)downloadStart:(NSDictionary *)dictionary
{
    _percent = [dictionary[@"progress"] floatValue];
    _oldTRCL = [dictionary[@"receivedContentLength"] floatValue];
    _receivedContentLength = [dictionary[@"receivedContentLength"] floatValue];
    _totalContentLength = [dictionary[@"totalContentLength"] floatValue];
    
    [self startNSTimer];
    
    NSString *urlString = dictionary[@"videoAddr"];
    NSString *videoId = dictionary[@"videoId"];
    
    _globalVariables.downloading = YES;
    self.operation = [YYYDownloadManager downloadFileWithURLString:urlString toDirectory:videoId cachePath:@"video.mp4" progress:^(CGFloat progress, CGFloat totalMBRead, CGFloat totalMBExpectedToRead) {
        
        _receivedContentLength = totalMBRead;
        _totalContentLength = totalMBExpectedToRead;
        _percent = progress;
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"success");
        _oldTRCL = 0;
        _percent = 0.0;
        _receivedContentLength = 0;
        _totalContentLength = 0;
        
        _globalVariables.downloading = NO;
        
        //下载完成后，删除正在下载数组对应数据
        //添加下载完成数据到已下载数组
        for (int i = 0; i < _downloadlingArray.count; i++) {
            NSString *isequalStr = _downloadlingArray[i][@"videoId"];
            if ([videoId isEqual:isequalStr]) {
                [self addDownloadedItem:_downloadlingArray[i]];
                [self deleteDownloadingItem:i];
                break;
            }
        }
        
        //刷新tableview
        [_dataTableView reloadData];
        
        //停止计时器
        [self deleteNSTimer];
        
        //通知上层view下载完成
        if (_delegate) {
            [_delegate downloadSuccess];
        }
        
        //检测是否有自动下载项
        [self checkAutoDownloadItem];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        _globalVariables.downloading = NO;
    }];
    
    [_dataTableView reloadData];
    
}

//暂停下载
- (void)downloadPause
{
    // 暂停任务
    [YYYDownloadManager pauseWithOperation:self.operation];
    
    _globalVariables.downloading = NO;
   
    //保存当前下载行的下载进度
    NSMutableDictionary *currentDic = _downloadlingArray[_globalVariables.downloadingCellIndex];
    [currentDic setObject:[NSNumber numberWithBool:NO] forKey:@"queue"];
    [currentDic setObject:[NSNumber numberWithBool:NO] forKey:@"isDelete"];
    [currentDic setObject:[NSNumber numberWithFloat:_percent] forKey:@"progress"];
    [currentDic setObject:[NSNumber numberWithFloat:_receivedContentLength] forKey:@"receivedContentLength"];
    [currentDic setObject:[NSNumber numberWithFloat:_totalContentLength] forKey:@"totalContentLength"];
    
    [self fileInfoSaveWithArray:_downloadlingArray downloading:YES];
    
    [self deleteNSTimer];
    
    [_dataTableView reloadData];
    
    //手动暂停下载行后，检查是否还有可自动下载行
    [self checkAutoDownloadItem];
}

//检查当前下载的视频是否存在
- (BOOL)checkDownloadedFileIsHave:(NSString *)videoId
{
    //文件名
    NSString *directoryPath = [NSString stringWithFormat:@"%@/Documents/%@",NSHomeDirectory(),videoId];
    NSString *uniquePath=[directoryPath stringByAppendingPathComponent:@"preview.png"];
    BOOL isHave = [[NSFileManager defaultManager] fileExistsAtPath:uniquePath];
    return isHave;
}

#pragma mark checkAutoDownloadItem
- (void)checkAutoDownloadItem
{
    //检测是否有自动下载项
    if (_downloadlingArray.count > 0) {
        for (int i = 0; i < _downloadlingArray.count; i++) {
            BOOL queue = [_downloadlingArray[i][@"queue"] boolValue];
            if (queue) {
                _globalVariables.downloadingCellIndex = i;
                [self downloadImage:_downloadlingArray[i] newItem:NO];
                break;
            }
        }
    }
}

#pragma mark - NSTimer
//创建并启动计时器
- (void)startNSTimer
{
    self.timer = [YYYWeakTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(reloadTableview) userInfo:nil repeats:YES dispatchQueue:dispatch_get_main_queue()];
}

//删除计时器
- (void)deleteNSTimer
{
    [self.timer invalidate];
}

//刷新下载数据行，每秒执行一次
- (void)reloadTableview
{
    [_dataTableView reloadData];
}

//计算下载速度，每秒执行一次
- (NSString *)calDownloadSpeed
{
    NSString *downloadSpeed;
    CGFloat speed = (_receivedContentLength - _oldTRCL);
    
    if (speed < 0) {
        downloadSpeed = [NSString stringWithFormat:@"0KB/S"];
    } else if (speed < 1.0) {
        downloadSpeed = [NSString stringWithFormat:@"%.1fKB/S",speed * 1024];
    } else {
        downloadSpeed = [NSString stringWithFormat:@"%.1fMB/S",speed];
    }
    
    if (!_globalVariables.downloading) {
        downloadSpeed = @"点击继续下载";
    }
    
    _oldTRCL = _receivedContentLength;
    return downloadSpeed;
}

//计算下载进度
- (NSString *)calReceivedContentLength:(CGFloat)receivedContentLength totalContentLength:(CGFloat)totalContentLength
{
    CGFloat TRCL = receivedContentLength/1024;
    CGFloat TCL = totalContentLength/1024;
    NSString *TRCLStr = [NSString stringWithFormat:@"%.1fGB",TRCL];
    NSString *TCLStr = [NSString stringWithFormat:@"%.1fGB",TCL];
    
    if (TRCL < 1.0) {
        TRCL = TRCL * 1024;
        TRCLStr = [NSString stringWithFormat:@"%.1fMB",TRCL];
    }
    if (TCL < 1.0) {
        TCL = TCL * 1024;
        TCLStr = [NSString stringWithFormat:@"%.1fMB",TCL];
    }
    
    return [NSString stringWithFormat:@"%@/%@",TRCLStr,TCLStr];
}

#pragma mark downloadingIemManage
//添加下载项目
- (void)addDownloadingItem:(NSDictionary *)dict
{
    [_downloadlingArray addObject:[self creatDictionary:dict]];
    [self fileInfoSaveWithArray:_downloadlingArray downloading:YES];
}

//删除正在下载项目
- (void)deleteDownloadingItem:(NSInteger)index
{
    [_downloadlingArray removeObjectAtIndex:index];
    if (_downloadlingArray.count > 0) {
        [self fileInfoSaveWithArray:_downloadlingArray downloading:YES];
    } else {
        [self deleteArchiveFile:YES];
    }
}

#pragma mark downloadedIemManage
//添加完成项目
- (void)addDownloadedItem:(NSDictionary *)dict
{
    [_downloadedArray addObject:[self creatDictionary:dict]];
    [self fileInfoSaveWithArray:_downloadedArray downloading:NO];
}

//删除已完成项目
- (void)deleteDownloadedItem:(NSInteger)index
{
    [self deleteVideoFileWithDictionary:_downloadedArray[index]];
    [_downloadedArray removeObjectAtIndex:index];
    if (_downloadedArray.count > 0) {
        [self fileInfoSaveWithArray:_downloadedArray downloading:NO];
    } else {
        [self deleteArchiveFile:NO];
    }
}

#pragma mark 沙盒操作
- (void)fileInfoSaveWithArray:(NSArray *)array downloading:(BOOL)isLodaing
{
    //将数据存储到沙盒
    if (array == nil) {
        return;
    }
    if (isLodaing) {
        
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:array,@"downloadingFile",nil];
        DownloadingFile *downloadingFile = [DownloadingFile downloadingFileWithDic:dictionary];
        [DownloadFileTool saveDownloadingFile:downloadingFile];
        
    } else {
        
        NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:array,@"downloadedFile",nil];
        DownloadedFile *downloadedFile = [DownloadedFile downloadedFileWithDic:dictionary];
        [DownloadFileTool saveDownloadedFile:downloadedFile];
    }
}

#pragma mark 删除沙盒里的archive文件
- (void)deleteArchiveFile:(BOOL)isLoading
{
    NSString *fileName;
    if (isLoading) {
        fileName = @"downloadingFile.archive";
    } else {
        fileName = @"downloadedFile.archive";
    }
    
    //文件名
    NSFileManager* fileManager=[NSFileManager defaultManager];
    NSString *uniquePath=[DocumentsDirectory stringByAppendingPathComponent:fileName];
    [fileManager removeItemAtPath:uniquePath error:nil];
}

#pragma mark 删除沙盒里的视频和图片文件
- (void)deleteVideoFileWithDictionary:(NSDictionary *)dic
{
    NSString *fileName = dic[@"videoId"];
    
    //文件名
    NSString *uniquePath=[DocumentsDirectory stringByAppendingPathComponent:fileName];
    NSFileManager* fileManager=[NSFileManager defaultManager];
    [fileManager removeItemAtPath:uniquePath error:nil];
}

//重构下载项目信息字典
- (NSDictionary *)creatDictionary:(NSDictionary *)dic
{
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    
    [dictionary setObject:dic[@"videoPreviewAddr"] forKey:@"videoPreviewAddr"];
    [dictionary setObject:dic[@"videoId"] forKey:@"videoId"];
    [dictionary setObject:dic[@"videoName"] forKey:@"videoName"];
    [dictionary setObject:dic[@"videoAddr"] forKey:@"videoAddr"];
    [dictionary setObject:dic[@"uploadUserName"] forKey:@"uploadUserName"];
    
    [dictionary setObject:[NSNumber numberWithBool:YES] forKey:@"queue"];
    [dictionary setObject:[NSNumber numberWithBool:NO] forKey:@"isDelete"];
    [dictionary setObject:[NSNumber numberWithFloat:0] forKey:@"progress"];
    [dictionary setObject:[NSNumber numberWithFloat:0] forKey:@"receivedContentLength"];
    [dictionary setObject:[NSNumber numberWithFloat:0] forKey:@"totalContentLength"];
    
    return dictionary;
}

//添加下载队列
- (void)addToDownloadQueue:(NSInteger)index
{
    NSMutableDictionary *dictionary = _downloadlingArray[index];
    [dictionary setObject:[NSNumber numberWithBool:YES] forKey:@"queue"];
}

//删除下载队列
- (void)removeFromDownloadQueue:(NSInteger)index
{
    NSMutableDictionary *dictionary = _downloadlingArray[index];
    [dictionary setObject:[NSNumber numberWithBool:NO] forKey:@"queue"];
}

- (void)dealloc
{
    [_timer invalidate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 重写实例化方法
+ (instancetype)alloc
{
    return nil;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    return [self alloc];
}

- (id)copy
{
    return self;
}

+ (instancetype)new
{
    return [self alloc];
}

@end
