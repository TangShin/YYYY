//
//  VideoHistoryView.m
//  yyy
//
//  Created by TangXing on 16/3/29.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import "VideoHistoryView.h"
#import "ProfileViewTool.h"
#import "VideoHistoryCell.h"
#import "PlayVideoViewController.h"
#import "PlaylistViewController.h"

@interface VideoHistoryView ()

@property (strong,nonatomic) NSArray *videoHistory; //播放历史数组

@end

@implementation VideoHistoryView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"历史记录";
    self.view.backgroundColor = YYYBackGroundColor;
    self.tableView.showsVerticalScrollIndicator = NO;//不显示右滑块
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableView.tableFooterView = [[UIView alloc] init];
    _videoHistory = [ProfileViewTool videoHistory].videoHistory;
    
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
    return _videoHistory.count;
}

//每一个分组下对应的tableviewCell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 87.0;
}

//设置每行对应的cell(展示的内容)
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"VideoHistoryCell";
    
    UINib *VideoHistoryNib = [UINib nibWithNibName:identifier bundle:nil];
    [tableView registerNib:VideoHistoryNib forCellReuseIdentifier:identifier];
    
    VideoHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    NSInteger row = _videoHistory.count- 1 - indexPath.row;
    BOOL isplaylist = [_videoHistory[row][@"isPlaylist"] boolValue];
    
    if (isplaylist) {
        cell.playlistImage.hidden = NO;
        cell.playlistImage.image = [UIImage imageWithData:_videoHistory[row][@"itemPreviewAddr"]];
        cell.image.hidden = YES;
    } else {
        cell.image.hidden = NO;
        cell.image.image = [UIImage imageWithData:_videoHistory[row][@"itemPreviewAddr"]];
        cell.playlistImage.hidden = YES;
        cell.image.layer.masksToBounds = YES;
        cell.image.layer.cornerRadius = 5;
    }
    cell.videoName.text = _videoHistory[indexPath.row][@"itemName"];
    
//    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

//cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    //取消cell选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger row = _videoHistory.count- 1 - indexPath.row;
    BOOL isplaylist = [_videoHistory[row][@"isPlaylist"] boolValue];
    if (isplaylist) {
        PlaylistViewController *playlistView = [[PlaylistViewController alloc] init];
        playlistView.playlistId = _videoHistory[row][@"itemId"];
        [self.navigationController pushViewController:playlistView animated:YES];
    } else {
        PlayVideoViewController *playVideoView = [[PlayVideoViewController alloc] init];
        playVideoView.videoId = _videoHistory[row][@"itemId"];
        [self.navigationController pushViewController:playVideoView animated:YES];
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
