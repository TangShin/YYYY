//
//  SettingTableView.m
//  yyy
//
//  Created by TangXing on 16/4/1.
//  Copyright © 2016年 yiyinyue. All rights reserved.
//

#import "SettingTableView.h"
#import "ProfileViewTool.h"

#import "UIImageView+WebCache.h"

@interface SettingTableView ()

@property (strong,nonatomic) UserSetting *userSetting;

@property (strong,nonatomic) NSArray *playSetting;
@property (strong,nonatomic) NSArray *netWorkSetting;
@property (strong,nonatomic) UISwitch *switchBtn;

@end

@implementation SettingTableView

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = YYYBackGroundColor;
    self.tableView.tableFooterView = [[UIView alloc] init];
    _playSetting = @[@"自动播放",@"自动全屏播放"];
    _netWorkSetting = @[@"允许蜂窝移动网络播放",@"允许蜂窝移动网络下载"];
    
    _userSetting = [ProfileViewTool userSetting];
}

#pragma mark tableViewDelegate
//设置每个分组下tableview的分组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

//设置每个分组下tableview的行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return _playSetting.count;
    } else if (section == 1) {
        return _netWorkSetting.count;
    } else {
        return 2;
    }
}

//每个分组上边预留空白高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    tableView.tableHeaderView.backgroundColor = YYYBackGroundColor;
    return 10;
}

//每个分组下边预留空白高度
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 20;
}

//每一个分组下对应的tableviewCell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
    //UITableViewAutomaticDimension 设置高度自动获取
}

//初始加载tableviewcell时，给出预估高度
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

//设置每行对应的cell(展示的内容)
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    UISwitch *switchBtn = [[UISwitch alloc] init];
    switchBtn.on = NO;
    switchBtn.onTintColor = YYYMainColor;
    [switchBtn addTarget:self action:@selector(valueChanged:) forControlEvents:UIControlEventValueChanged];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        cell.textLabel.text = _playSetting[indexPath.row];
        cell.accessoryView = switchBtn;
        switchBtn.tag = 0;
        if (_userSetting.autoPlay) {
            switchBtn.on = YES;
        }
    } else if (indexPath.section == 0 && indexPath.row == 1) {
        cell.textLabel.text = _playSetting[indexPath.row];
        cell.accessoryView = switchBtn;
        switchBtn.tag = 1;
        if (_userSetting.autoFullScreenPlay) {
            switchBtn.on = YES;
        }
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        cell.textLabel.text = _netWorkSetting[indexPath.row];
        cell.accessoryView = switchBtn;
        switchBtn.tag = 2;
        if (_userSetting.netWorkSatePlay) {
            switchBtn.on = YES;
        }
    } else if (indexPath.section == 1 && indexPath.row == 1) {
        cell.textLabel.text = _netWorkSetting[indexPath.row];
        cell.accessoryView = switchBtn;
        switchBtn.tag = 3;
        if (_userSetting.netWorkSateDownload) {
            switchBtn.on = YES;
        }
    } else if (indexPath.section == 2 && indexPath.row == 0) {
        cell.textLabel.text = @"帮助我们完善APP";
        cell.accessoryView = switchBtn;
        switchBtn.tag = 4;
        if (_userSetting.sendErrorLog) {
            switchBtn.on = YES;
        }
    } else {
        UILabel *cacheSize = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 20)];
        cacheSize.font = [UIFont systemFontOfSize:14.0];
        cacheSize.textColor = [UIColor grayColor];
        cacheSize.textAlignment = NSTextAlignmentRight;
        cacheSize.text = [NSString stringWithFormat:@"%.2fMB",[self calCacheFileSize]];
        cell.textLabel.text = @"清除图片缓存";
        cell.accessoryView = cacheSize;
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    return cell;
}

//cell点击事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    //取消cell选中状态
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 2) {
        [[SDWebImageManager sharedManager].imageCache clearDisk];
        [self.tableView reloadData];
    }
}

#pragma mark switch开关事件
- (void)valueChanged:(UISwitch *)sender
{
    NSInteger tag = sender.tag;
    BOOL senderValue  = [sender isOn];
    
    if (tag == 0) {
        if (senderValue) {
            _userSetting.autoPlay = YES;
        } else {
            _userSetting.autoPlay = NO;
        }
    }
    
    if (tag == 1) {
        if (senderValue) {
            _userSetting.autoFullScreenPlay = YES;
        } else {
            _userSetting.autoFullScreenPlay = NO;
        }
    }
    
    if (tag == 2) {
        if (senderValue) {
            _userSetting.netWorkSatePlay = YES;
        } else {
            _userSetting.netWorkSatePlay = NO;
        }
    }
    
    if (tag == 3) {
        if (senderValue) {
            _userSetting.netWorkSateDownload = YES;
        } else {
            _userSetting.netWorkSateDownload = NO;
        }
    }
    
    if (tag == 4) {
        if (senderValue) {
            _userSetting.sendErrorLog = YES;
        } else {
            _userSetting.sendErrorLog = NO;
        }
    }
    
    [ProfileViewTool saveUserSetting:_userSetting];
}

#pragma mark 计算缓存目录大小
- (float)calCacheFileSize
{
    float floatSize;
    //SDWebImage 计算缓存目录大小的方法
    floatSize += [[SDWebImageManager sharedManager].imageCache getSize]/1024.0/1024.0;
    return floatSize;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
